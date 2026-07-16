Last month, I switched the backend database for labordata from
[SQLite](https://en.wikipedia.org/wiki/SQLite) to
[DuckDB](https://en.wikipedia.org/wiki/DuckDB) for clearer and faster queries.

Labordata should be easier to use and much snappier. Unfortunately, some older
saved queries may not work because of changes between the SQL dialect. Please
get in touch if you need help or have run into any other problems.

## Dialect Improvements

SQLite's minimalist SQL dialect and loose typing can lead to complicated
queries.

Here are two queries that both get the upper and lower bound on count of LM20
contracts filed per year. The first is in the SQLite dialect:

```sql
with most_recent_amendment as (
  select
    *
  from
    (
      select
        *
      from
        filing
      order by
        srNum,
        beginDate,
        endDate,
        formFiled,
        yrCovered,
        amendment desc
    )
  group by
    srNum,
    beginDate,
    endDate,
    formFiled,
    yrCovered
),
new_contracts_lower as (
  select
    yrCovered as year,
    sum(repOrgsCnt) as "new contracts minimum"
  from
    most_recent_amendment
  where
    formFiled = 'LM-20'
  group by
    yrCovered
),
new_contracts_upper as (
  select
    yrCovered as year,
    sum(repOrgsCnt) as "new contracts maximum"
  from
    filing
  where
    formFiled = 'LM-20'
  group by
    yrCovered
)
select
  *
from
  new_contracts_lower
  inner join new_contracts_upper using(year)
where year <= 2025
order by
  year desc;
```

DuckDB is built for analytic queries and so its dialect is much nicer for this
type of query.

```sql
WITH ranked AS (
  SELECT
    *,
    row_number() OVER (
      PARTITION BY srNum, beginDate, endDate, formFiled, yrCovered
      ORDER BY amendment DESC
    ) AS rn
  FROM filing
  WHERE formFiled = 'LM-20'
)
SELECT
  yrCovered AS year,
  sum(repOrgsCnt) FILTER (WHERE rn = 1) AS "new contracts minimum",
  sum(repOrgsCnt) AS "new contracts maximum"
FROM ranked
GROUP BY yrCovered
HAVING year <= 2025
ORDER BY year DESC
```

## Speed

As for speed, on analytic queries, we have been seeing 10-50× speedups.
