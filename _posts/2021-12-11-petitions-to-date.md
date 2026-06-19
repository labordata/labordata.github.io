---
title: Petitions for representation certification elections filed with the NLRB to date
layout: post
description: Cumulative NLRB representation petitions by day of year, with a case-type selector.
reactive: true
---

This graph shows the cumulative filings for representation certifications (RC)
elections with the NLRB. Each line represents a different year.

This graph is using live data from https://labordata.bunkum.us/nlrb and should
update daily.

You can select different case types (other than RC) to see their trajectories.

```js
const case_type = view(
  Inputs.select(
    ["RC", "RD", "CA", "CB", "UC", "CC", "UD", "RM", "CD", "CE", "CG", "WH", "CP", "AC"],
    { label: "Select Case Type" },
  ),
);
```

```js
display(
  Plot.plot({
    marginRight: 30,
    y: {
      grid: true,
      label: "Filings to date",
    },
    x: {
      transform: (d) => d3.utcDay.offset(d, (2000 - d.getUTCFullYear()) * 365.24),
      tickFormat: "%b",
      line: true,
    },
    color: {
      domain: [false, true],
      range: ["#ccc", "red"],
    },
    marks: [
      Plot.line(
        filings_by_region,
        Plot.mapY("cumsum", {
          x: "day",
          y: "count",
          z: ({ day }) => day.getUTCFullYear(),
          curve: "step-before",
          stroke: ({ day }) => new Date().getUTCFullYear() === day.getUTCFullYear(),
        }),
      ),
      Plot.text(
        filings_by_region,
        Plot.selectLast(
          Plot.mapY("cumsum", {
            x: "day",
            y: "count",
            z: ({ day }) => day.getUTCFullYear(),
            text: ({ day }) => day.getUTCFullYear().toString(),
            textAnchor: "start",
            dx: 3,
          }),
        ),
      ),
    ],
    title: "Annual cumulative filings by day of years.",
  }),
);
```

```js
display(
  Plot.plot(
    (() => {
      const n = 4; // number of facet columns
      const keys = Array.from(
        d3.union(filings_by_region.map((d) => d.region_assigned)),
      );
      const index = new Map(keys.map((key, i) => [key, i]));
      const fx = (key) => index.get(key) % n;
      const fy = (key) => Math.floor(index.get(key) / n);
      return {
        axis: null,
        y: {
          grid: true,
          label: "Filings to date",
        },
        x: {
          transform: (d) =>
            d3.utcDay.offset(d, (2000 - d.getUTCFullYear()) * 365.24),
        },
        color: {
          domain: [false, true],
          range: ["#ccc", "red"],
        },
        marks: [
          Plot.frame(),
          Plot.line(
            filings_by_region,
            Plot.mapY("cumsum", {
              x: "day",
              y: "count",
              z: ({ day }) => day.getUTCFullYear(),
              curve: "step-before",
              fx: (d) => fx(d.region_assigned),
              fy: (d) => fy(d.region_assigned),
              stroke: ({ day }) =>
                new Date().getUTCFullYear() === day.getUTCFullYear(),
            }),
          ),
          Plot.text(keys, {
            fx,
            fy,
            frameAnchor: "top-left",
            dx: 6,
            dy: 6,
            text: (d) => d.split(", ")[1] + ", " + d.split(", ")[0].substring(7),
          }),
        ],
        title: "Annual cumulative filings by day of years, by region.",
      };
    })(),
  ),
);
```

```js
import { table } from "/assets/js/toms-table.js";
display(table(yearly.map((d) => ({ ...d, year: d.year.toString() }))));
```

```js
display(md`# Yearly Trends

Number of ${case_type} cases filed per year with the National Labor Relations Board, through ${new Date().getFullYear() - 1}.`);
```

```js
display(
  Plot.plot({
    title: `${case_type} cases, 1984 - ${new Date().getFullYear() - 1}`,
    marginLeft: 50,
    y: { nice: true, grid: true },
    marks: [
      Plot.ruleY([0]),
      Plot.line(yearly_cases, {
        x: (d) => new Date(d.year.toString()),
        y: "count",
      }),
    ],
  }),
);
```

```js
import { DatasetteClient } from "/assets/js/datasette-client.js";
const db = new DatasetteClient("https://labordata.bunkum.us/nlrb");
const mem_db = new DatasetteClient("https://labordata.bunkum.us/_memory");
```

```js
const yearly = await mem_db.query(
  `
WITH combined AS (
    SELECT
        left(r_case_number, 6) || '0' || right(r_case_number, 5) AS case_number,
        case_type,
        dayofyear(date_filed) AS day,
        year(date_filed) AS year
    FROM
cats.r_case
    UNION
    SELECT
        case_number,
        case_type,
        dayofyear(date_filed) AS day,
        year(date_filed) AS year
    FROM
nlrb.filing
)
SELECT
    cast(year AS text) AS year,
    count(*) FILTER (WHERE day < dayofyear(today())) AS "total up to this day of year",
    count(*) AS "total for year"
FROM
    combined
WHERE
    case_type = :case_type
    AND year >= 2000
GROUP BY
    year
ORDER BY
    year DESC`,
  { case_type: case_type },
);
```

```js
const filings_by_region = await db.query`WITH daily AS (
  SELECT
    date_filed AS day,
    region_assigned,
    count(*) AS count
  FROM filing
  WHERE case_type = ${case_type}
    AND (year(current_date) - year(date_filed)) < 6
    AND region_assigned IS NOT NULL
  GROUP BY region_assigned, day
),
years AS (
  SELECT DISTINCT region_assigned, year(day) AS yr FROM daily
),
bounds AS (
  SELECT region_assigned, make_date(yr, 1, 1) AS day FROM years
  UNION ALL
  SELECT region_assigned, make_date(yr, 12, 31) FROM years
  WHERE yr != year(current_date)
)
SELECT
  coalesce(d.day, b.day) AS day,
  coalesce(d.region_assigned, b.region_assigned) AS region_assigned,
  coalesce(d.count, 0) AS count
FROM bounds b
FULL JOIN daily d
  ON d.day = b.day AND d.region_assigned = b.region_assigned
ORDER BY day`;
```

```js
const yearly_cases = await mem_db.query`with cases as (
  select
    left(case_number, 13) as case_number,
    ctype as case_type,
    year(file_date) as year
  from
    chips.c_master
  union all
  select
    case_number,
    ctype,
    year(file_date) as year
  from
    chips.r_master
  union all
  select
    left(r_case_number, 6) || '0' || right(r_case_number, 5) as case_number,
    case_type,
    year(date_filed) as year
  from
    cats.r_case
  union all
  select
    left(c_case_number, 6) || '0' || right(c_case_number, 5) as case_number,
    case_type,
    year(date_filed) as year
  from
    cats.c_case
  union all
  select
    case_number,
    case_type,
    year(date_filed) as year
  from
    nlrb.filing
)
select
  year,
  any_value(case_type) as case_type,
  count(distinct case_number) as count
from
  cases
where
  case_type = ${case_type}
  AND year >= 1984
  and year < year(current_date)
group by
  year
order by
  year`;
```
