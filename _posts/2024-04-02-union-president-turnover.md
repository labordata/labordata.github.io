---
title: Union President Turnover
layout: post
description: Approximating how often local union presidents change, and what predicts it.
reactive: true
---

Local unions are required to file information about their organization and
finances every year to the Department of Labor's Office of Management and Labor
Standards (OLMS). These forms include information about the officers of the
union.

We can use the information from these forms to make a measurement of how often
the leadership of local union changes.

We would like to know the rate at which presidents of a local union turns over.
We can approximate the rate of changes in presidents by counting the number of
distinct last names that are listed for a president in a yearly filing divided by
the number of yearly filings submitted by the union. In order to correct for
biases we subtract one from both the top and the bottom.

\[ \text{Turnover} \sim \frac{\text{Distinct names} - 1}{\text{Years} - 1} \]

If the the last name is very common, or if presidency passed from one relative to
another, then our measure will underestimate turnover. If the filing has a
misspelling of the president's last name, then we will overestimate.

Generally, though, our measure seems to be a reasonable approximation of
presidential turnover.

One way, we can check is to see if our measure performs as we would expect from
the literature on local union democracy.

In J.C. Anderson's 1979 article, ["A Comparative Analysis of Local Union
Democracy"](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1468-232X.1978.tb00138.x),
Anderson identified a number of factors that are correlated with measures of
local union democracy. In particular, he found that larger unions and
long-established unions tended to have less competitive elections for officers.

Competitive elections for union officers should have a strong relation with
turnover of officers. Losing elections is one direct cause of turnover. Similarly
the fear of losing, or unwillingness to fight a difficult campaign also lead
incumbent officers to decide to not run again.

## Union Size

As expected, larger local unions do have lower turnover of presidents.

```js
const sizeLoess = regressionLoess()
  .x((d) => Math.log10(d.members))
  .y((d) => d.turn_over_rate)
  .bandwidth(0.5)(local_unions);
display(
  Plot.plot({
    y: { label: "Changes in presidents per decade" },
    x: { tickFormat: (x) => 10 ** x, ticks: 5, label: "Members in local (log scale)" },
    caption: "Turnover by Size of Local Union",
    marks: [
      Plot.rect(
        local_unions,
        Plot.bin(
          { fillOpacity: "count" },
          { x: (d) => Math.log10(d.members), y: "turn_over_rate", fill: "lightblue" },
        ),
      ),
      Plot.line(sizeLoess, { x: (d) => d[0], y: (d) => d[1] }),
    ],
  }),
);
```

## Age of Union

And younger locals do have higher presidential turnover.

This chart only include locals started after December 1, 1970. The data from the
OLMS does not include establishment data for local unions established before that
date.

```js
const ageLoess = regressionLoess()
  .x((d) => +d.est_year)
  .y((d) => d.turn_over_rate)
  .bandwidth(0.5)(local_unions_post_70)
  .map(([x, y]) => [d3.utcParse("%Y")(String(Math.round(x))), y]);
display(
  Plot.plot({
    y: { label: "Changes in president per decade" },
    x: { label: "Year local established" },
    caption: "Turnover by Year the Local Union Was Established",
    marks: [
      Plot.rect(
        local_unions_post_70,
        Plot.bin(
          { fillOpacity: "count" },
          { x: (d) => d3.utcParse("%Y")(d.est_year), y: "turn_over_rate", fill: "lightblue" },
        ),
      ),
      Plot.line(ageLoess, { x: (d) => d[0], y: (d) => d[1] }),
    ],
  }),
);
```

```js
display(md`## National Union

The factor that most strongly relates to presidential turnover was not in Anderson's study: the affiliation of the local union with a national union.

Locals affiliated with the National Staff Organization, a union of union staff, change their presidents, on average, ${affiliations.find((row) => row["National union"] === "NSOI")["Average changes of local presidents per decade"]} times per decade, while United Mine Workers locals, on average, change presidents ${affiliations.find((row) => row["National union"] === "UMW")["Average changes of local presidents per decade"]} times per decade.`);
```

```js
import { table } from "/assets/js/toms-table.js";
display(table(affiliations, { title: "Turnover by National Union" }));
```

# Conclusion

At least in aggregate, our measure of presidential turnover seems reasonable. All
the relationships shown here are still substantial and statistically significant
in a multiple regression analysis.

It could be further refined by stricter checking that a difference in last names
means the person is different or the sharing of last names means the person is
the same. Using first name and a fuzzy string distance to allow for some typos
would be good next steps.

For modelling, logistic regression is likely the most appropriate choice. Every
year would be a trial with a binary outcome of whether this years president is the
same or different than last year. This modeling choice would handle different
number of available years naturally. This modeling would also allow for
year-varying features.

## Suggestions

From twitter, I got a number of really useful suggestions. Where the tweet was
public or I have permission, I will cite the user.

First, someone rightfully pointed out that presidents can change while the faction
in power remains the same. It could be really useful to compare the entire set of
officers in one year to the entire set officer in the next. If many or all
officers changed, that would be a much better signal that the union has
meaningfully different leadership than if just the president changed. I think this
idea could really improve the precision of the measure.

One way you could implement:

\[ \frac{\text{Distinct Officer Names} - \text{Distinct Officer Positions}}{(\text{Years} - 1) \cdot \text{Distinct Officer Positions}} \]

This is still a bit mushy. Would not distinguish a pattern of officers change that
has a high level of continuity

| year | president | vice-president | treasurer |
|-|-|-|-|
| 1 | alice | bob | candice|
| 2 | alice   | bob | dawn |
| 3 | alice | earl | frank |

versus many years of complete continuity and then a sudden change.

| year | president | vice-president | treasurer |
|-|-|-|-|
| 1 | alice | bob | candice|
| 2 | alice   | bob | candice |
| 3 | dawn | earl | frank |

Second, [Dave Kamper](https://twitter.com/dskamper) suggested that turnover should
correlate with:
- salary of president (I bet this correlates strongly with size of union)
- whether the local has paid staff
- the financial trajectory of the union
- the membership trajectory

## Appendix

```js
import { regressionLoess } from "https://cdn.jsdelivr.net/npm/d3-regression@1/+esm";
import { DatasetteClient } from "/assets/js/datasette-client.js";
const db = new DatasetteClient("https://duckdb-labordata.bunkum.us/opdr");
```

```js
const affiliations = await db.query`WITH presidents AS (
  SELECT
    DISTINCT ON (f_num, yr_covered) *
  FROM
    ar_disbursements_emp_off
    JOIN lm_data USING (rpt_id)
  WHERE
    title = 'PRESIDENT'
    AND desig_name = 'LU'
  ORDER BY
    f_num,
    yr_covered
),
turnover AS (
  SELECT
    f_num,
    any_value(aff_abbr) AS aff_abbr,
    min(est_date) AS est_date,
    year(min(est_date)) <= 1970 AS established_before_1971,
    avg(members) AS members,
    (count(DISTINCT last_name) - 1) * 10 / (count(*) - 1) AS turn_over_rate
  FROM
    presidents
  GROUP BY
    f_num
  HAVING
    count(*) >= 3
    AND avg(members) > 0
)
SELECT
  aff_abbr AS "National union",
  round(avg(turn_over_rate), 1) AS "Average changes of local presidents per decade",
  round(quantile_disc(turn_over_rate, 0.25), 1) AS "25th percentile",
  round(quantile_disc(turn_over_rate, 0.75), 1) AS "75th percentile",
  count(*) AS "Number of locals"
FROM
  turnover
GROUP BY
  aff_abbr
HAVING
  count(*) >= 10
ORDER BY
  avg(turn_over_rate) DESC`;
```

```js
const local_unions = await db.query`WITH presidents AS (
  SELECT
    distinct on (f_num, yr_covered) *
  FROM
    ar_disbursements_emp_off
    INNER JOIN lm_data USING (rpt_id)
  WHERE
    title = 'PRESIDENT'
    AND desig_name = 'LU'
  ORDER BY
    f_num,
    yr_covered
)
SELECT
  f_num,
  any_value(aff_abbr) as aff_abbr,
  nullif (min(est_date), DATE '1970-12-01') AS est_date,
  year(min(est_date)) < 1971 established_before_1971,
  avg(members) AS members,
  (count(DISTINCT last_name) - 1) * 10 / (count(*) - 1) AS turn_over_rate
FROM
  presidents
GROUP BY
  f_num
HAVING
  count(*) >= 3
  AND avg(members) > 0`;
```

```js
const local_unions_post_70 = await db.query`WITH presidents AS (
  SELECT DISTINCT ON (f_num, yr_covered) *
  FROM ar_disbursements_emp_off
  JOIN lm_data USING (rpt_id)
  WHERE title = 'PRESIDENT'
    AND desig_name = 'LU'
    AND est_date != DATE '1970-12-01'
  ORDER BY f_num, yr_covered
)
SELECT
  f_num,
  any_value(aff_abbr) AS aff_abbr,
  year(min(est_date)) AS est_year,
  avg(members) AS members,
  (count(DISTINCT last_name) - 1) * 10 / (count(*) - 1) AS turn_over_rate
FROM presidents
GROUP BY f_num
HAVING count(*) >= 3
  AND avg(members) IS NOT NULL
  AND count(*) FILTER (WHERE year(est_date) > yr_covered) <= 1
ORDER BY est_year DESC`;
```
