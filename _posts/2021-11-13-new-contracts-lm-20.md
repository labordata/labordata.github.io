---
title: New contracts reported by anti-labor consultants in LM-20 Filings
layout: post
description: Upper and lower bounds on new anti-labor consultant contracts reported in LM-20 filings.
reactive: true
---

Anti-labor consultants hired by employers are required to report details about
their hiring to the [Department of Labor's Office of Labor-Management
Standards](https://www.dol.gov/sites/dolgov/files/olms/regs/compliance/gpea_forms/instructions/lm-20_instructions.pdf).
Law firms that do not directly engage with employees but only provide advice to
employers on how to fight unions are currently exempt from reporting.

This graph shows the upper and lower bound for the number of contracts between
these consultants and employers.

Ignoring data before 2012, when the published number of clients were not
reliable, the big change is a sharp decline in the number of new hirings since
2016.

If the "[Persuader
Rule](https://news.bloomberglaw.com/daily-labor-report/biden-dol-explores-redo-of-obama-union-avoidance-reporting-rule-1)"
had gone into effect after 2016 instead of being rescinded by the Trump
administration, there probably would have been a sharp increase instead. That
rule would have required reporting by law firms that provide advice to employers
on how to combat unions.

```js
display(
  Plot.plot({
    x: {
      tickFormat: "d",
      label: "",
    },
    y: {
      label: "New contracts reported in LM-20 Filings",
      domain: [0, 800],
      grid: true,
    },
    color: {
      legend: true,
      domain: ["minimum", "maximum"],
      range: ["#4e79a7", "#f28e2c"],
    },
    marks: [
      Plot.line(filteredContracts, {
        x: "year",
        y: "new contracts minimum",
        stroke: () => "minimum",
      }),
      Plot.line(filteredContracts, {
        x: "year",
        y: "new contracts maximum",
        stroke: () => "maximum",
      }),
    ],
  }),
);
```

## Data Notes

Consultants are supposed to file notice of their hiring within 30 days in an
LM-20 form. If they have already submitted a form for that fiscal year, they are
supposed to submit an amended form.

Different consultants seem to interpret "amended form" differently.

Some consultants, resubmit all the information previously submitted plus the
information about the new hiring. So if the original LM-20 form listed one
client, and the consultant was hired by a new client, the consultant would
submit an amended form that listed two clients.

Other consultants only submit new information in an amendment. So, in the same
scenario, the second "amended" form would only list one client, the new one.

The Department of Labor publishes information about the number of clients listed
in an LM-20 form. We can use that to construct a lower and upper estimate of the
number of new contracts signed per year.

First, we can just look at the final amendment in a fiscal year. If we sum up all
the number of clients listed in that final amendment of every LM-20, that would
be a minimum estimate of the number of new hirings in that year. This method
will **undercount** the hirings done by consultants that file amendments that
only contain information about new hirings.

Second, we can sum up all the listed clients for every amendment, we can get an
maximum estimate. This estimate will **overcount** hirings done by consultants
that file amendments that keep the same information from previous versions and
add new information.

We could get a more accurate count by counting the distinct employers listed as
clients, but the data quality is not adequate to do that yet. I will clean up the
data to that, though.

```js
import { DatasetteClient } from "/assets/js/datasette-client.js";
const db = new DatasetteClient("https://duckdb-labordata.bunkum.us/lm20");
const last_year = new Date().getFullYear() - 1;
```

```js
const contracts = await db.query`WITH ranked AS (
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
HAVING year <= ${last_year}
ORDER BY year DESC`;
```

```js
const filteredContracts = contracts.filter((row) => row.year > 2011);
```
