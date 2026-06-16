---
title: Improving Success of Individual Certification Petitions at the NLRB
layout: post
description: Petitions fell sharply, but the odds a petition yields a certification rose — an explorable view from 1965.
reactive: true
---

```js
const start_year = view(
  Inputs.range([1965, last_year - 1], {
    label: "Starting Year",
    step: 1,
    value: 1968,
  }),
);
```

```js
display(htl.html`<style>
.title {
  text-align: center;
  font-family: sans-serif;
  padding-bottom: 0;
}
.chart {
  display: inline-block;
}
</style>`);
```

```js
display(md`Despite an overall decline in NLRB petitions and certifications, the chance that an individual certification petition will result in a union being certified as a workers' representative has gotten much better over the past ${cases[cases.length - 1].year - cases_start.year} years.

In ${start_year}, private-sector workers filed ${d3.format(",")(cases_start.cases)} petitions with the NLRB to certify a union as their representative for collective bargaining. Of these petitions, ${d3.format(",")(cases_start.elections)} went on to hold an election to certify a union as the workers' representative. When there was an election, there were ${d3.format(",")(cases_start.certifications)} union victories.

Almost ${Intl.NumberFormat(undefined, { maximumSignificantDigits: 1 }).format(cases[cases.length - 1].year - cases_start.year)} years later, certification petitions had fallen by ${d3.format(".0%")((cases_start.cases - cases[cases.length - 1].cases) / cases_start.cases)} to ${d3.format(",")(cases[cases.length - 1].cases)} petitions filed in ${last_year}. However, victorious elections had only fallen by ${d3.format(".0%")((cases_start.certifications - cases[cases.length - 1].certifications) / cases_start.certifications)}.  ${d3.format(",")(cases[cases.length - 1].certifications)} petitions filed in ${last_year} have resulted in a successful union certification.

(In this analysis, I am using ${last_year} as the most recent year for comparison because many cases filed in ${last_year + 1} are still in progress.)`);
```

```js
display(html`
<div class="chart">
${drawChart([0, 12000], "Certification petitions", cases, "cases", ".0s")}
</div>
<div class="chart">
${drawChart([0, 12000], "Elections", cases, "elections", ".0s")}
</div>
<div class="chart">
${drawChart([0, 12000], "Union certifications", cases, "certifications", ".0s")}
</div>
`);
```

```js
display(md`A ${d3.format(".0%")((cases_start.certifications - cases[cases.length - 1].certifications) / cases_start.certifications)} decline in union certifications is bad, but it is better than the decline in petitions. This relatively positive trend in winning elections is due to large changes in the fate of certification petitions after they are filed.

In ${start_year}, a petition only had a ${d3.format(".0%")(ratios_start.win_ratio)} chance of resulting in an election win. In ${last_year}, it had a ${d3.format(".0%")(ratios[ratios.length - 1].win_ratio)} chance. This ${d3.format(".2")((ratios[ratios.length - 1].win_ratio - ratios_start.win_ratio) * 100)}  point difference is because unions are winning more elections **and** more petitions are leading to elections.

Put another way, if unions could preserve their success rates, then if they increased the number of petitions they filed by ${d3.format(".2")(cases_start.certifications / cases[cases.length - 1].certifications)} times, they would they win almost as many representation certifications as they did ${cases[cases.length - 1].year - cases_start.year} years ago, when the number of petition filings was ${d3.format(".1f")(cases_start.cases / cases[cases.length - 1].cases)} times higher than today.

Hank Farber described the trend in increasing election success in his great 2014 article, ["Union Organizing Decisions in a Deteriorating Environment"](https://www.nber.org/system/files/working_papers/w19908/w19908.pdf). He explains it as unions choosing easier sites to organize in the face of more intense and effective employer opposition.`);
```

```js
display(html`
<div class="chart">
${drawChart([0, 1], "Petition to elections", ratios, "election_ratio", ".0%")}
</div>
<div class="chart">
${drawChart([0, 1], "Election to certifications", ratios, "election_win_ratio", ".0%")}
</div>
<div class="chart">
${drawChart([0, 1], "Petition to certifications", ratios, "win_ratio", ".0%")}
</div>
`);
```

```js
display(md`## Single-Union Elections

When we look at single-union elections, the level of unionization of the ${new Intl.NumberFormat("en", { maximumSignificantDigits: 3, useGrouping: false }).format(start_year)}s looks even more reachable.

Single-union elections can be a better indicator of newly organized workers as they exclude elections where unions are competing to represent already unionized workers.

From the election petitions filed in ${start_year}, ${d3.format(",")(cases.find((d) => d.year === start_year).single_union_certification_workers)} workers won a certified bargaining unit in a single-union election. From the petitions filed in ${last_year}, ${d3.format(",")(cases[cases.length - 1].single_union_certification_workers)} did.`);
```

```js
display(md`
If unions could preserve their success rates and the distribution of unit sizes, then if they increased the number of petitions they filed by only ${d3.format(".2")(cases.find((d) => d.year === 1965).single_union_certification_workers / cases[cases.length - 1].single_union_certification_workers)} times, they would cover as many workers in new, single-union elections as they did in 1965, when there were ${d3.format(".2")(cases.find((d) => d.year === 1965).cases / cases[cases.length - 1].cases)} times more cases filed.`);
```

```js
display(html`
<div class="chart">
${drawChart([0, 450000], "Single-union eligible voters", cases, "single_union_election_workers", ".0s")}
</div>
<div class="chart">
${drawChart([0, 450000], "Single-union workers in certified units", cases, "single_union_certification_workers", ".0s")}
</div>
`);
```

## Increasing Unit Size

The relatively favorable number of workers is not only due to rising success
rates, but also to the fact that the average size of single-union bargaining
units that win a certification election is also increasing.

```js
display(html`
<div class="chart">
${drawChart([40, 100], "Average unit size for elections", ratios, "single_union_election_unit_size", ".0s")}
</div>
<div class="chart">
${drawChart([40, 100], "Average unit size of certified units", ratios, "single_union_certification_unit_size", ".0s")}
</div>
`);
```

Farber's data also show the same overall pattern of rising average unit size in
elections from 1965 to 2000 and subsequent decline, though our absolute numbers
are larger than the data he reports.

## Data

Data from the [current NLRB case management
system](https://labordata.bunkum.us/nlrb), the [CATS
system](https://labordata.bunkum.us/cats) (1999-2010), and the [CHIPS
system](https://labordata.bunkum.us/chips) (1984-2000), [data on representation
elections from 1965-1998 compiled by the
AFL-CIO](https://labordata.bunkum.us/nlrb_rc_elections_1961_1998) c/o [JP
Ferguson](https://github.com/jpfergongithub/nlrb_old_rcases). The year 1999 is
excluded because of data artifacts due to the transition between data systems.

The number of RC cases filed from 1965-1998 is compiled from [NLRB Annual
reports](https://www.nlrb.gov/reports/agency-performance-reports/historical-reports/annual-reports)
and use a July to June fiscal years; the rest of the data uses a calendar year.

```js
import { DatasetteClient } from "/assets/js/datasette-client.js";
const db = new DatasetteClient("https://duckdb-labordata.bunkum.us/_memory");
const last_year = 2024;
const margin = 33;
```

```js
const early_year_rc_filings = [
  { year: 1965, count: 10255 },
  { year: 1966, count: 10820 },
  { year: 1967, count: 11193 },
  { year: 1968, count: 10449 },
  { year: 1969, count: 10308 },
  { year: 1970, count: 10332 },
  { year: 1971, count: 10904 },
  { year: 1972, count: 11666 },
  { year: 1973, count: 11897 },
  { year: 1974, count: 11891 },
  { year: 1975, count: 11037 },
  { year: 1976, count: 11846 },
  { year: 1977, count: 11578 },
  { year: 1978, count: 10338 },
  { year: 1979, count: 10333 },
  { year: 1980, count: 9828 },
  { year: 1981, count: 9332 },
  { year: 1982, count: 5605 },
  { year: 1983, count: 5410 },
];
```

```js
const cases_raw = await db.query`-- Representation-election outcomes, unioned from four source systems into one
-- row per case-appearance, collapsed to one row per case, then tallied by year.
with -- CATS (election_id, tally_id) groups that had exactly one participant tally.
cats_single_participant as (
  select
    r_case_number
  from
    cats.r_elect_votes_for qualify count(*) over (partition by election_id, tally_id) = 1
),
combined as (
  -- Old NLRB representation data (1961-1998)
  select
    -- canonical case number: 2-digit region, type, 6-digit docket
    printf('%02d-%s-%06d', region, r_type, docket) as case_number,
    r_type as case_type,
    true as election,
    won = 'Won' as certification,
    elig_voter as employees_in_unit,
    incumb_un > 0
    and incumb_un is not null as incumbent,
    sec_union is null as single_union,
    year(coalesce(filed_date, election_date)) as year
  from
    nlrb_rc_elections_1961_1998.nlrb_representation_1961_1998
  union all
    -- CHIPS
  select
    case_number,
    ctype as case_type,
    rc_elect.date_election_held is not null as election,
    try_cast(rc_elect.method as int) = 3 as certification,
    no_elig as employees_in_unit,
    try_cast(incumb_union as int) > 2
    and incumb_union is not null as incumbent,
    -- single-union unless there was both a winning (real, non-8) union and a
    -- losing union. Null when there's no election record, so bool_and() ignores
    -- it rather than forcing the case to non-single.
    case
      when rc_elect.case_number is null then null
      else not (
        (
          union_won_intl_type is not null
          and union_won_intl_type != 8
        )
        and union_lost_intl_1_type is not null
      )
    end as single_union,
    year(file_date) as year
  from
    chips.r_master
    left join chips.rc_elect using (case_number)
  union all
    -- CATS
  select
    -- CATS stores a 5-digit docket; pad it to the canonical 6 digits
    left(r_case.r_case_number, 6) || '0' || right(r_case.r_case_number, 5) as case_number,
    case_type,
    election_id is not null as election,
    certified_bargaining_agent is not null as certification,
    num_employees_eligible as employees_in_unit,
    incumbent_union is not null as incumbent,
    single.r_case_number is not null as single_union,
    year(date_filed) as year
  from
    cats.r_case
    left join cats.r_election_tally using (r_case_number)
    left join cats.r_elect_certification using (election_id)
    left join cats.r_participant on r_case.r_case_number = r_participant.r_case_number
    and incumbent_union = 'Y'
    left join cats_single_participant as single on r_case.r_case_number = single.r_case_number
  union all
    -- Modern NLRB
  select
    filing.case_number as case_number,
    case_type,
    election_id is not null as election,
    union_to_certify is not null as certification,
    unit_size as employees_in_unit,
    false as incumbent,
    ballot_type = 'Single Labor Organization' as single_union,
    year(date_filed) as year
  from
    nlrb.filing
    left join nlrb.voting_unit using (case_number)
    left join nlrb.election using (voting_unit_id)
    left join nlrb.election_result using (election_id)
),
completions as (
  -- One row per case. A case had an election / certification / incumbent if ANY
  -- source says so (bool_or); it is single-union only if every source that has
  -- an opinion agrees (bool_and, which ignores the null "unknown"s above).
  select
    case_number,
    -- case_type is encoded in case_number, so it is constant within the group;
    -- any_value() just takes that one value.
    any_value(case_type) as case_type,
    bool_or(election) as election,
    bool_or(certification) as certification,
    bool_or(incumbent) as incumbent,
    bool_and(single_union) as single_union,
    min(employees_in_unit) as employees_in_unit,
    min(year) as year
  from
    combined
  group by
    case_number
)
select
  year,
  if(year >= 1984, count(*), null) as cases,
  count(*) filter (
    where
      election
  ) as elections,
  count(*) filter (
    where
      certification
  ) as certifications,
  sum(employees_in_unit) filter (
    where
      election
  ) as election_workers,
  sum(employees_in_unit) filter (
    where
      certification
  ) as certification_workers,
  count(*) filter (
    where
      election
      and not incumbent
      and single_union
  ) as single_union_elections,
  count(*) filter (
    where
      certification
      and not incumbent
      and single_union
  ) as single_union_certifications,
  sum(employees_in_unit) filter (
    where
      election
      and not incumbent
      and single_union
  ) as single_union_election_workers,
  sum(employees_in_unit) filter (
    where
      certification
      and not incumbent
      and single_union
  ) as single_union_certification_workers
from
  completions
where
  year between 1965
  and cast(${last_year} as int)
  and year != 1999
  and case_type = 'RC'
group by
  year
order by
  year`;
```

```js
const cases = cases_raw.map((d) => ({
  ...d,
  cases: d.cases
    ? d.cases
    : early_year_rc_filings.find((e) => e.year === d.year)?.count,
}));
```

```js
const ratios = cases.map((row) => ({
  year: row.year,
  election_ratio: row.elections / row.cases,
  election_win_ratio: row.certifications / row.elections,
  win_ratio: row.certifications / row.cases,
  single_union_election_win_ratio:
    row.single_union_certifications / row.single_union_elections,
  single_union_election_unit_size:
    row.single_union_election_workers / row.single_union_elections,
  single_union_certification_unit_size:
    row.single_union_certification_workers / row.single_union_certifications,
}));
```

```js
const cases_start = cases.find((d) => d.year === start_year);
const ratios_start = ratios.find((d) => d.year === start_year);
```

```js
const drawChart = (y_domain, y_label, series, y, tickFormat) => {
  return Plot.plot({
    grid: true,
    width: width < 200 ? width : 200,
    height: width < 200 ? width : 200,
    marginLeft: margin,
    marginRight: margin,
    marginTop: margin,
    marginBottom: margin,
    y: {
      domain: y_domain,
      tickFormat: tickFormat,
      label: y_label,
    },
    x: {
      domain: [1965, last_year],
      tickFormat: "d",
      label: "",
    },
    marks: [Plot.line(series, { x: "year", y: y })],
  });
};
```
