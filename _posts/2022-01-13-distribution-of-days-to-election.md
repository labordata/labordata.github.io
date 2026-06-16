---
title: Distribution of days from filing to first election
layout: post
description: How long RC cases wait from filing to first election, and how NLRB rule changes shifted it.
reactive: true
---

For RC cases filed since January 1, 2010. Negative durations or durations greater
than 365 are truncated.

```js
display(md`| year | median | mean | stdev |
|-|-|-|-|
|overall | ${d3.median(time_to_election, (d) => d.days)}|${d3.mean(time_to_election, (d) => d.days).toFixed(2)}|${d3.deviation(time_to_election, (d) => d.days).toFixed(2)}|
| 2010 | ${d3.median(time_to_election.filter((d) => d.year_filed === 2010), (d) => d.days)}|${d3.mean(time_to_election.filter((d) => d.year_filed === 2010), (d) => d.days).toFixed(2)}|${d3.deviation(time_to_election.filter((d) => d.year_filed === 2010), (d) => d.days).toFixed(2)}|
| 2019 | ${d3.median(time_to_election.filter((d) => d.year_filed === 2019), (d) => d.days)}|${d3.mean(time_to_election.filter((d) => d.year_filed === 2019), (d) => d.days).toFixed(2)}|${d3.deviation(time_to_election.filter((d) => d.year_filed === 2019), (d) => d.days).toFixed(2)}|
| 2020 | ${d3.median(time_to_election.filter((d) => d.year_filed === 2020), (d) => d.days)}|${d3.mean(time_to_election.filter((d) => d.year_filed === 2020), (d) => d.days).toFixed(2)}|${d3.deviation(time_to_election.filter((d) => d.year_filed === 2020), (d) => d.days).toFixed(2)}|
| 2021 | ${d3.median(time_to_election.filter((d) => d.year_filed === 2021), (d) => d.days)}|${d3.mean(time_to_election.filter((d) => d.year_filed === 2021), (d) => d.days).toFixed(2)}|${d3.deviation(time_to_election.filter((d) => d.year_filed === 2021), (d) => d.days).toFixed(2)}|
| 2022 | ${d3.median(time_to_election.filter((d) => d.year_filed === 2022), (d) => d.days)}|${d3.mean(time_to_election.filter((d) => d.year_filed === 2022), (d) => d.days).toFixed(2)}|${d3.deviation(time_to_election.filter((d) => d.year_filed === 2022), (d) => d.days).toFixed(2)}|
| 2023 | ${d3.median(time_to_election.filter((d) => d.year_filed === 2023), (d) => d.days)}|${d3.mean(time_to_election.filter((d) => d.year_filed === 2023), (d) => d.days).toFixed(2)}|${d3.deviation(time_to_election.filter((d) => d.year_filed === 2023), (d) => d.days).toFixed(2)}|
| 2024 | ${d3.median(time_to_election.filter((d) => d.year_filed === 2024), (d) => d.days)}|${d3.mean(time_to_election.filter((d) => d.year_filed === 2024), (d) => d.days).toFixed(2)}|${d3.deviation(time_to_election.filter((d) => d.year_filed === 2024), (d) => d.days).toFixed(2)}|
| 2025 | ${d3.median(time_to_election.filter((d) => d.year_filed === 2025), (d) => d.days)}|${d3.mean(time_to_election.filter((d) => d.year_filed === 2025), (d) => d.days).toFixed(2)}|${d3.deviation(time_to_election.filter((d) => d.year_filed === 2025), (d) => d.days).toFixed(2)}|`);
```

```js
display(
  Plot.plot({
    y: {
      grid: true,
    },
    marks: [
      Plot.rectY(time_to_election, Plot.binX({ y: "count" }, { x: "days" })),
      Plot.ruleY([0]),
    ],
  }),
);
```

If we break out the distribution by year filed, we see that the time to first
election got a lot shorter starting in 2015. That year, the Obama-administration
NLRB [issued new rules to expedite
elections](https://www.wsj.com/articles/new-nlrb-election-rules-havent-helped-unions-grow-as-expected-1461190043).

Some of these rules [got rolled back in
2020](https://news.bloomberglaw.com/daily-labor-report/more-labor-law-charges-possible-under-nlrb-union-election-rule),
but the effect of that rollback is hard to discern because of the global
pandemic. By 2024, the delays returned to the pre-pandemic levels.

Eric Dirnbach [has a good article about these
changes](https://ericdirnbach.medium.com/the-nlrb-will-eliminate-faster-union-elections-how-much-does-it-matter-fd62060a1b3e).

```js
display(
  Plot.plot({
    y: {
      grid: true,
    },
    x: {
      grid: true,
    },
    facet: {
      data: time_to_election,
      y: (d) => d.year_filed.toString(),
    },
    marks: [
      Plot.rectY(time_to_election, Plot.binX({ y: "count" }, { x: "days" })),
      Plot.ruleY([0]),
    ],
  }),
);
```

```js
import { DatasetteClient } from "/assets/js/datasette-client.js";
const db = new DatasetteClient("https://duckdb-labordata.bunkum.us/nlrb");
```

```js
const time_to_election = await db.query`select
  min(date - date_filed) as days,
  year(any_value(date_filed)) as year_filed
from
  filing
  inner join election using (case_number)
where
  date_filed >= DATE'2010-01-01'
  and case_type = 'RC'
group by
  case_number
having
  days > 0
  and days <= 365`;
```
