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

In ${start_year}, private-sector workers filed ${d3.format(",")(cases_start.cases)} petitions with the NLRB to certify a union as their representative for collective bargaining. Of these petitions, ${d3.format(",")(cases_start.petitions_with_election)} went on to hold an election to certify a union as the workers' representative. When there was an election, there were ${d3.format(",")(cases_start.certifications)} union victories.

Almost ${Intl.NumberFormat(undefined, { maximumSignificantDigits: 1 }).format(cases[cases.length - 1].year - cases_start.year)} years later, certification petitions had fallen by ${d3.format(".0%")((cases_start.cases - cases[cases.length - 1].cases) / cases_start.cases)} to ${d3.format(",")(cases[cases.length - 1].cases)} petitions filed in ${last_year}. However, victorious elections had only fallen by ${d3.format(".0%")((cases_start.certifications - cases[cases.length - 1].certifications) / cases_start.certifications)}.  ${d3.format(",")(cases[cases.length - 1].petitions_with_certification)} petitions filed in ${last_year} have resulted in a successful union certification.

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
Ferguson](https://github.com/jpfergongithub/nlrb_old_rcases).

About 5,000 cases in the 1961-1998 data, mostly closed in 1982, have no filing
date. Since the NLRB assigns docket numbers in order within each region and
case type, I interpolate their filing dates from the nearest dated cases by
docket number.

The number of RC cases filed from 1965-1983 is compiled from [NLRB Annual
reports](https://www.nlrb.gov/reports/agency-performance-reports/historical-reports/annual-reports).
All years are NLRB fiscal years of filing, to match the annual reports: July to
June through 1976, and October to September after. Cases filed in the July to
September 1976 transition quarter are left out.

Single-union elections are elections with only one union on the ballot.
Petitions consolidated into one election count as one election, though each
still counts as a petition. When an election's eligible-voter count is more
than ten times the unit size on the petition, and at least 1,000, I treat it as
a keying error and use the petition's count.

The 1965-1983 elections come from the AFL-CIO file, which only includes
elections that ended in a certification of representative or certification of
results; the later data include every election held. Checked against the
annual reports, the AFL-CIO file has about 95% of single-union elections in
every year, so the earlier years are somewhat understated relative to the
later ones.

```js
import { DatasetteClient } from "/assets/js/datasette-client.js";
const db = new DatasetteClient("https://labordata.bunkum.us/_memory");
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
-- Old NLRB data with each case's nearest dated neighbors by docket number.
-- Dockets are assigned sequentially within a region and case type, so the
-- neighbors bracket when an undated case was filed.
old_r_neighbors as (
  select
    *,
    last_value(if(filed_date is not null, docket, null) ignore nulls) over preceding_cases as prev_docket,
    last_value(filed_date ignore nulls) over preceding_cases as prev_filed_date,
    first_value(if(filed_date is not null, docket, null) ignore nulls) over following_cases as next_docket,
    first_value(filed_date ignore nulls) over following_cases as next_filed_date
  from
    nlrb_rc_elections_1961_1998.nlrb_representation_1961_1998
  window
    preceding_cases as (
      partition by region, r_type
      order by docket
      rows between unbounded preceding and current row
    ),
    following_cases as (
      partition by region, r_type
      order by docket
      rows between current row and unbounded following
    )
),
-- About 5,000 cases, mostly closed in 1982, have no filing date. Interpolate
-- one linearly by docket number between the dated neighbors.
old_r as (
  select
    *,
    coalesce(
      filed_date,
      case
        when prev_docket is not null
        and next_docket is not null
        and next_docket != prev_docket then prev_filed_date + cast(
          round(
            (docket - prev_docket) * datediff('day', prev_filed_date, next_filed_date) / (next_docket - prev_docket)
          ) as int
        )
      end,
      prev_filed_date,
      next_filed_date,
      election_date
    ) as imputed_filed_date
  from
    old_r_neighbors
),
-- Eligible-voter counts more than ten times the unit named on the petition, and
-- at least 1,000, are keying errors (e.g. 92,092 eligible on an 88-person
-- petition); fall back to the petition's count for those.
combined as (
  -- Old NLRB representation data (1961-1998). One record per election, with
  -- consolidated petitions already collapsed.
  select
    -- canonical case number: 2-digit region, type, 6-digit docket
    printf('%02d-%s-%06d', region, r_type, docket) as case_number,
    r_type as case_type,
    true as election,
    won = 'Won' as certification,
    elig_voter as employees_in_unit,
    sec_union is null as single_union,
    election_date,
    -- source-prefixed so min() below prefers a real grouping over the old
    -- file's one-case groups
    'old:' || printf('%02d-%s-%06d', region, r_type, docket) as consolidation_group,
    imputed_filed_date as filed_date
  from
    old_r
  union all
    -- CHIPS
  select
    case_number,
    ctype as case_type,
    rc_elect.date_election_held is not null as election,
    try_cast(rc_elect.method as int) = 3 as certification,
    if(
      no_elig > 10::bigint * number_emp
      and no_elig >= 1000,
      number_emp,
      no_elig
    ) as employees_in_unit,
    -- single-union when exactly one union was on the ballot: the winner (8 is
    -- "No Winner") plus the losers. Null when there's no election record, so
    -- bool_and() ignores it rather than forcing the case to non-single.
    case
      when rc_elect.case_number is null then null
      else (
        coalesce(union_won_intl_type != 8, false)::int + (union_lost_intl_1_type is not null)::int + (union_lost_intl_2_type is not null)::int + (union_lost_intl_3_type is not null)::int + (union_lost_intl_4_type is not null)::int
      ) <= 1
    end as single_union,
    rc_elect.date_election_held as election_date,
    -- consolidated petitions point at their lead case
    'chips:' || coalesce(nullif(consol_case_number, ''), case_number) as consolidation_group,
    file_date as filed_date
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
    if(
      num_employees_eligible > 10::bigint * try_cast(num_employees_requested as int)
      and num_employees_eligible >= 1000,
      try_cast(num_employees_requested as int),
      num_employees_eligible
    ) as employees_in_unit,
    single.r_case_number is not null as single_union,
    r_election.date_election as election_date,
    'cats:' || coalesce(r_case_case_group.r_case_group_id, r_case.r_case_number) as consolidation_group,
    date_filed as filed_date
  from
    cats.r_case
    left join cats.r_election_tally using (r_case_number)
    left join cats.r_election using (election_id)
    left join cats.r_elect_certification using (election_id)
    left join cats_single_participant as single on r_case.r_case_number = single.r_case_number
    left join cats.r_case_case_group on r_case.r_case_number = r_case_case_group.r_case_number
    and r_case_case_group.date_case_removed is null
  union all
    -- Modern NLRB
  select
    filing.case_number as case_number,
    case_type,
    election_id is not null as election,
    union_to_certify is not null as certification,
    if(
      unit_size > 10::bigint * try_cast(number_of_voters_on_petition_or_charge as int)
      and unit_size >= 1000,
      try_cast(number_of_voters_on_petition_or_charge as int),
      unit_size
    ) as employees_in_unit,
    ballot_type = 'Single Labor Organization' as single_union,
    election.date as election_date,
    'nlrb:' || coalesce(filing_group.root_case_number, filing.case_number) as consolidation_group,
    date_filed as filed_date
  from
    nlrb.filing
    left join nlrb.voting_unit using (case_number)
    left join nlrb.election using (voting_unit_id)
    left join nlrb.election_result using (election_id)
    left join nlrb.filing_group on filing.case_number = filing_group.case_number
),
completions as (
  -- One row per case. A case had an election / certification if ANY source
  -- says so (bool_or); it is single-union only if every source that has an
  -- opinion agrees (bool_and, which ignores the null "unknown"s above).
  select
    case_number,
    -- case_type is encoded in case_number, so it is constant within the group;
    -- any_value() just takes that one value.
    any_value(case_type) as case_type,
    bool_or(election) as election,
    bool_or(certification) as certification,
    bool_and(single_union) as single_union,
    min(employees_in_unit) as employees_in_unit,
    min(election_date) as election_date,
    min(consolidation_group) as consolidation_group,
    min(filed_date) as filed_date
  from
    combined
  group by
    case_number
),
-- Tally by NLRB fiscal year of filing, to match the annual reports: July to
-- June through June 1976, then October to September. The July-September 1976
-- transition quarter belongs to no fiscal year and is left out.
fiscal_years as (
  select
    *,
    case
      when filed_date < date '1976-07-01' then year(filed_date + interval 6 month)
      when filed_date < date '1976-10-01' then null
      else year(filed_date + interval 3 month)
    end as year
  from
    completions
),
-- Consolidated petitions often carry a copy of the same election. Count one
-- election per consolidation group, election date, and unit size; every
-- petition still counts toward the petition totals.
distinct_elections as (
  select
    *,
    row_number() over (
      partition by consolidation_group, election_date, employees_in_unit
      order by case_number
    ) = 1 as distinct_election
  from
    fiscal_years
)
select
  year,
  if(year >= 1984, count(*), null) as cases,
  count(*) filter (
    where
      election
  ) as petitions_with_election,
  count(*) filter (
    where
      certification
  ) as petitions_with_certification,
  count(*) filter (
    where
      election
      and distinct_election
  ) as elections,
  count(*) filter (
    where
      certification
      and distinct_election
  ) as certifications,
  sum(employees_in_unit) filter (
    where
      election
      and distinct_election
  ) as election_workers,
  sum(employees_in_unit) filter (
    where
      certification
      and distinct_election
  ) as certification_workers,
  count(*) filter (
    where
      election
      and distinct_election
      and single_union
  ) as single_union_elections,
  count(*) filter (
    where
      certification
      and distinct_election
      and single_union
  ) as single_union_certifications,
  sum(employees_in_unit) filter (
    where
      election
      and distinct_election
      and single_union
  ) as single_union_election_workers,
  sum(employees_in_unit) filter (
    where
      certification
      and distinct_election
      and single_union
  ) as single_union_certification_workers
from
  distinct_elections
where
  year between 1965
  and cast(${last_year} as int)
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
  election_ratio: row.petitions_with_election / row.cases,
  election_win_ratio: row.certifications / row.elections,
  win_ratio: row.petitions_with_certification / row.cases,
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
