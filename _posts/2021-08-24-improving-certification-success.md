---
title: Improving Success of Individual Certification Petitions at the NLRB
layout: post
description: Petitions fell sharply, but the odds a petition yields a certification rose — an explorable view from 1965.
reactive: true
---

```js
const start_year = view(
  Inputs.range([1965, 2002], {
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
figure {
  margin: 0;
}
figcaption {
  font-family: sans-serif;
  font-size: 0.8em;
  color: #555;
}
</style>`);
```

```js
display(md`Despite an overall decline in NLRB petitions and certifications, the chance that an individual certification petition will result in a union being certified as a workers' representative has gotten much better over the past ${cases[cases.length - 1].year - cases_start.year} years.

In ${start_year}, private-sector workers filed ${d3.format(",")(cases_start.cases)} petitions with the NLRB to certify a union as their representative for collective bargaining. Of these petitions, ${d3.format(",")(cases_start.petitions_with_election)} went on to hold an election to certify a union as the workers' representative. When there was an election, there were ${d3.format(",")(cases_start.certifications)} union victories.

${cases[cases.length - 1].year - cases_start.year} years later, certification petitions had fallen by ${d3.format(".0%")((cases_start.cases - cases[cases.length - 1].cases) / cases_start.cases)} to ${d3.format(",")(cases[cases.length - 1].cases)} petitions filed in ${last_year}. However, victorious elections had only fallen by ${d3.format(".0%")((cases_start.certifications - cases[cases.length - 1].certifications) / cases_start.certifications)}.  ${d3.format(",")(cases[cases.length - 1].petitions_with_certification)} petitions filed in ${last_year} have resulted in a successful union certification.

(In this analysis, I am using ${last_year} as the most recent year for comparison because many cases filed in ${last_year + 1} are still in progress.)`);
```

```js
display(html`
<figure>
<div class="chart">
${drawChart([0, 12000], "Certification petitions", cases, "cases", ".0s", annual_reports)}
</div>
<div class="chart">
${drawChart([0, 12000], "Elections", cases, "elections", ".0s", annual_reports)}
</div>
<div class="chart">
${drawChart([0, 12000], "Union certifications", cases, "certifications", ".0s", annual_reports)}
</div>
<figcaption>Solid lines are RC petitions from NLRB case records, by fiscal year filed
(petition counts for 1965-1983 are from the Annual Reports). Dashed lines are the NLRB Annual
Reports' own counts: RC petitions by fiscal year filed, and elections and certifications by fiscal
year a case closed, which include RM cases before FY1964.</figcaption>
</figure>
`);
```

```js
display(md`A ${d3.format(".0%")((cases_start.certifications - cases[cases.length - 1].certifications) / cases_start.certifications)} decline in union certifications is bad, but it is better than the decline in petitions. This relatively positive trend in winning elections is due to large changes in the fate of certification petitions after they are filed.

In ${start_year}, a petition only had a ${d3.format(".0%")(ratios_start.win_ratio)} chance of resulting in an election win. In ${last_year}, it had a ${d3.format(".0%")(ratios[ratios.length - 1].win_ratio)} chance. This ${d3.format(".2")((ratios[ratios.length - 1].win_ratio - ratios_start.win_ratio) * 100)}  point difference is because unions are winning more elections **and** more petitions are leading to elections.

${cases_start.certifications / cases[cases.length - 1].certifications >= 1.1
  ? `Put another way, if unions could preserve their success rates and increased the number of petitions they filed by ${d3.format(".1f")(cases_start.certifications / cases[cases.length - 1].certifications)} times, they would win as many representation certifications as they did ${cases[cases.length - 1].year - cases_start.year} years ago, when the number of petition filings was ${d3.format(".1f")(cases_start.cases / cases[cases.length - 1].cases)} times higher than today.`
  : `Put another way, unions now win ${cases_start.certifications / cases[cases.length - 1].certifications < 0.9 ? "more" : "about as many"} representation certifications ${cases_start.certifications / cases[cases.length - 1].certifications < 0.9 ? "than" : "as"} they did ${cases[cases.length - 1].year - cases_start.year} years ago${cases[cases.length - 1].cases < cases_start.cases ? `, with ${d3.format(".0%")(1 - cases[cases.length - 1].cases / cases_start.cases)} fewer petitions` : ""}.`}`);
```

```js
display(html`
<figure>
<div class="chart">
${drawChart([0, 1], "Petition to elections", ratios, "election_ratio", ".0%", annual_report_ratios)}
</div>
<div class="chart">
${drawChart([0, 1], "Election to certifications", ratios, "election_win_ratio", ".0%", annual_report_ratios)}
</div>
<div class="chart">
${drawChart([0, 1], "Petition to certifications", ratios, "win_ratio", ".0%", annual_report_ratios)}
</div>
<figcaption>For petition to elections and petition to certifications, the dashed lines are a year's
elections or certifications over that year's petitions, not a cohort of petitions.</figcaption>
</figure>
`);
```

```js
display(md`## Single-Union Elections

When we look at single-union elections, the level of organizing of the ${Math.floor(start_year / 10) * 10}s looks even more reachable.

Single-union elections can be a better indicator of newly organized workers as they exclude elections where unions are competing to represent already unionized workers.

From the election petitions filed in ${start_year}, ${d3.format(",")(cases.find((d) => d.year === start_year).single_union_certification_workers)} workers won a certified bargaining unit in a single-union election. From the petitions filed in ${last_year}, ${d3.format(",")(cases[cases.length - 1].single_union_certification_workers)} did.`);
```

```js
display(md`
${cases_start.single_union_certification_workers / cases[cases.length - 1].single_union_certification_workers >= 1.1
  ? `If unions could preserve their success rates and the distribution of unit sizes and increased the number of petitions they filed by only ${d3.format(".1f")(cases_start.single_union_certification_workers / cases[cases.length - 1].single_union_certification_workers)} times, they would cover as many workers in new, single-union elections as they did in ${start_year}, when there were ${d3.format(".1f")(cases_start.cases / cases[cases.length - 1].cases)} times more cases filed.`
  : `Unions already cover ${cases_start.single_union_certification_workers / cases[cases.length - 1].single_union_certification_workers < 0.9 ? "more" : "about as many"} workers in new, single-union elections ${cases_start.single_union_certification_workers / cases[cases.length - 1].single_union_certification_workers < 0.9 ? "than" : "as"} they did in ${start_year}${cases[cases.length - 1].cases < cases_start.cases ? `, with ${d3.format(".0%")(1 - cases[cases.length - 1].cases / cases_start.cases)} fewer petitions` : ""}.`}`);
```

```js
display(html`
<div class="chart">
${drawChart([0, 450000], "Single-union eligible voters", cases, "single_union_election_workers", ".0s", annual_reports)}
</div>
<div class="chart">
${drawChart([0, 450000], "Single-union workers in certified units", cases, "single_union_certification_workers", ".0s", annual_reports)}
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
${drawChart([40, 100], "Average unit size for elections", ratios, "single_union_election_unit_size", ".0s", annual_report_ratios)}
</div>
<div class="chart">
${drawChart([40, 100], "Average unit size of certified units", ratios, "single_union_certification_unit_size", ".0s", annual_report_ratios)}
</div>
`);
```

## Data

Data from the [current NLRB case management
system](https://labordata.bunkum.us/nlrb), the [CATS
system](https://labordata.bunkum.us/cats) (1999-2011), and the [CHIPS
system](https://labordata.bunkum.us/chips) (1984-2000), [data on representation
elections from 1965-1998 compiled by the
AFL-CIO](https://labordata.bunkum.us/nlrb_rc_elections_1961_1998) c/o [JP
Ferguson](https://github.com/jpfergongithub/nlrb_old_rcases). The year 1999 is
excluded because of data artifacts due to the transition between data systems.

About 5,000 cases in the 1961-1998 data, mostly closed in 1982, have no filing
date. Since the NLRB assigns docket numbers in order within each region and
case type, I interpolate their filing dates from the nearest dated cases by
docket number.

The number of RC cases filed from 1965-1983, and the series from 1950-1995
labeled as the annual reports', are compiled from [NLRB Annual
reports](https://www.nlrb.gov/reports/agency-performance-reports/historical-reports/annual-reports).
The case-record series use NLRB fiscal years of filing: July to June through
1976, and October to September after. Cases filed in the July to September 1976
transition quarter are left out. The annual reports count elections by the
fiscal year a case closed, include employer-filed RM cases before 1964, and do
not follow petitions to their outcome, so their petition-to-election and
petition-to-certification ratios divide a year's elections or wins by that
year's petitions.

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

// NLRB Annual Reports, by fiscal year closed (RC from FY1964, RC+RM before;
// petitions filed = RC cases received, Tables 1A/1B). Transcribed in
// labordata/new_organizing, data/annual_reports/.
const annual_reports = [
  { year: 1950, elections: 5619, certifications: 4186, election_workers: 890374, certification_workers: 753598, single_union_elections: 4291, single_union_certifications: 2977, single_union_election_workers: 350138, single_union_certification_workers: 227947, cases: 8206 },
  { year: 1951, elections: 6432, certifications: 4758, election_workers: 666556, certification_workers: 505322, single_union_elections: 5490, single_union_certifications: 3895, single_union_election_workers: 375667, single_union_certification_workers: 233091, cases: 9460 },
  { year: 1952, elections: 6765, certifications: 4933, election_workers: 771346, certification_workers: 584030, single_union_elections: 5427, single_union_certifications: 3719, single_union_election_workers: 376899, single_union_certification_workers: 224808, cases: 9571 },
  { year: 1953, elections: 6050, certifications: 4350, election_workers: 737998, certification_workers: 584450, single_union_elections: 4616, single_union_certifications: 3053, single_union_election_workers: 326087, single_union_certification_workers: 192998, cases: 8241 },
  { year: 1954, elections: 4663, certifications: 3060, election_workers: 511430, certification_workers: 343092, single_union_elections: 3802, single_union_certifications: 2320, single_union_election_workers: 286280, single_union_certification_workers: 143400, cases: 7028 },
  { year: 1955, elections: 4215, certifications: 2849, election_workers: 515995, certification_workers: 378962, single_union_elections: 3330, single_union_certifications: 2031, single_union_election_workers: 256346, single_union_certification_workers: 130908, cases: 6160 },
  { year: 1956, elections: 4946, certifications: 3230, election_workers: 462712, certification_workers: 291292, single_union_elections: 4202, single_union_certifications: 2591, single_union_election_workers: 326519, single_union_certification_workers: 171107, cases: 7121 },
  { year: 1957, elections: 4729, certifications: 2942, election_workers: 458904, certification_workers: 264920, single_union_elections: 4135, single_union_certifications: 2426, single_union_election_workers: 295387, single_union_certification_workers: 121698, cases: 6774 },
  { year: 1958, elections: 4337, certifications: 2636, election_workers: 351217, certification_workers: 196334, single_union_elections: 3756, single_union_certifications: 2144, single_union_election_workers: 262063, single_union_certification_workers: 120469, cases: 6284 },
  { year: 1959, elections: 5428, certifications: 3410, election_workers: 430023, certification_workers: 257028, single_union_elections: 4557, single_union_certifications: 2642, single_union_election_workers: 267284, single_union_certification_workers: 123927, cases: 7959 },
  { year: 1960, elections: 6380, certifications: 3740, election_workers: 483964, certification_workers: 286048, single_union_elections: 5405, single_union_certifications: 2902, single_union_election_workers: 304532, single_union_certification_workers: 126187, cases: 8795 },
  { year: 1961, elections: 6354, certifications: 3563, election_workers: 450930, certification_workers: 229283, single_union_elections: 5383, single_union_certifications: 2760, single_union_election_workers: 295291, single_union_certification_workers: 99137, cases: 9177 },
  { year: 1962, elections: 7355, certifications: 4305, election_workers: 536047, certification_workers: 305976, single_union_elections: 6263, single_union_certifications: 3360, single_union_election_workers: 336673, single_union_certification_workers: 137892, cases: 9704 },
  { year: 1963, elections: 6871, certifications: 4052, election_workers: 489365, certification_workers: 265747, single_union_elections: 5934, single_union_certifications: 3257, single_union_election_workers: 330242, single_union_certification_workers: 133721, cases: 9562 },
  { year: 1964, elections: 6940, certifications: 4062, election_workers: 517661, certification_workers: 278077, single_union_elections: 6101, single_union_certifications: 3369, single_union_election_workers: 370410, single_union_certification_workers: 147977, cases: 10018 },
  { year: 1965, elections: 7176, certifications: 4435, election_workers: 512159, certification_workers: 316075, single_union_elections: 6340, single_union_certifications: 3735, single_union_election_workers: 347715, single_union_certification_workers: 167238, cases: 10255 },
  { year: 1966, elections: 7637, certifications: 4756, election_workers: 551408, certification_workers: 314094, single_union_elections: 6815, single_union_certifications: 4050, single_union_election_workers: 431251, single_union_certification_workers: 209015, cases: 10820 },
  { year: 1967, elections: 7496, certifications: 4552, election_workers: 592309, certification_workers: 339531, single_union_elections: 6686, single_union_certifications: 3877, single_union_election_workers: 399506, single_union_certification_workers: 171767, cases: 11193 },
  { year: 1968, elections: 7241, certifications: 4252, election_workers: 517372, certification_workers: 261028, single_union_elections: 6467, single_union_certifications: 3605, single_union_election_workers: 390236, single_union_certification_workers: 159439, cases: 10449 },
  { year: 1969, elections: 7319, certifications: 4098, election_workers: 552037, certification_workers: 279425, single_union_elections: 6551, single_union_certifications: 3466, single_union_election_workers: 397497, single_union_certification_workers: 151523, cases: 10308 },
  { year: 1970, elections: 7426, certifications: 4214, election_workers: 575464, certification_workers: 300737, single_union_elections: 6706, single_union_certifications: 3616, single_union_election_workers: 415166, single_union_certification_workers: 159932, cases: 10332 },
  { year: 1971, elections: 7543, certifications: 4157, election_workers: 546632, certification_workers: 259682, single_union_elections: 6832, single_union_certifications: 3594, single_union_election_workers: 401854, single_union_certification_workers: 140484, cases: 10904 },
  { year: 1972, elections: 8066, certifications: 4483, election_workers: 556100, certification_workers: 280302, single_union_elections: 7401, single_union_certifications: 3923, single_union_election_workers: 401879, single_union_certification_workers: 144426, cases: 11666 },
  { year: 1973, elections: 8526, certifications: 4501, election_workers: 506289, certification_workers: 216842, single_union_elections: 7946, single_union_certifications: 4047, single_union_election_workers: 436868, single_union_certification_workers: 168952, cases: 11897 },
  { year: 1974, elections: 7994, certifications: 4131, election_workers: 506047, certification_workers: 184447, single_union_elections: 7441, single_union_certifications: 3714, single_union_election_workers: 433982, single_union_certification_workers: 140607, cases: 11891 },
  { year: 1975, elections: 7729, certifications: 3900, election_workers: 533576, certification_workers: 204024, single_union_elections: 7157, single_union_certifications: 3470, single_union_election_workers: 445188, single_union_certification_workers: 138631, cases: 11037 },
  { year: 1976, elections: 7736, certifications: 3906, election_workers: 435171, certification_workers: 155784, single_union_elections: 7211, single_union_certifications: 3533, single_union_election_workers: 380982, single_union_certification_workers: 123635, cases: 11846 },
  { year: 1977, elections: 8308, certifications: 4056, election_workers: 519102, certification_workers: 200705, single_union_elections: 7818, single_union_certifications: 3688, single_union_election_workers: 450806, single_union_certification_workers: 151541, cases: 11578 },
  { year: 1978, elections: 7168, certifications: 3504, election_workers: 424481, certification_workers: 155352, single_union_elections: 6787, single_union_certifications: 3220, single_union_election_workers: 370570, single_union_certification_workers: 122749, cases: 10338 },
  { year: 1979, elections: 7026, certifications: 3363, election_workers: 528798, certification_workers: 190893, single_union_elections: 6672, single_union_certifications: 3092, single_union_election_workers: 454279, single_union_certification_workers: 133614, cases: 10333 },
  { year: 1980, elections: 7021, certifications: 3441, election_workers: 471651, certification_workers: 172788, single_union_elections: 6610, single_union_certifications: 3136, single_union_election_workers: 407539, single_union_certification_workers: 130535, cases: 9828 },
  { year: 1981, elections: 6439, certifications: 2972, election_workers: 395573, certification_workers: 143860, single_union_elections: 6106, single_union_certifications: 2718, single_union_election_workers: 344260, single_union_certification_workers: 106933, cases: 9332 },
  { year: 1982, elections: 4031, certifications: 1808, election_workers: 244292, certification_workers: 82229, single_union_elections: 3806, single_union_certifications: 1642, single_union_election_workers: 214829, single_union_certification_workers: 62145, cases: 5605 },
  { year: 1983, elections: 3241, certifications: 1608, election_workers: 164925, certification_workers: 74389, single_union_elections: 3051, single_union_certifications: 1454, single_union_election_workers: 142519, single_union_certification_workers: 55541, cases: 5410 },
  { year: 1984, elections: 3336, certifications: 1598, election_workers: 205717, certification_workers: 90186, single_union_elections: 3180, single_union_certifications: 1474, single_union_election_workers: 161551, single_union_certification_workers: 53066, cases: 5370 },
  { year: 1985, elections: 3545, certifications: 1702, election_workers: 211161, certification_workers: 75999, single_union_elections: 3313, single_union_certifications: 1511, single_union_election_workers: 188784, single_union_certification_workers: 61063, cases: 5623 },
  { year: 1986, elections: 3495, certifications: 1705, election_workers: 217110, certification_workers: 73516, single_union_elections: 3322, single_union_certifications: 1567, single_union_election_workers: 200216, single_union_certification_workers: 62381, cases: 5131 },
  { year: 1987, elections: 3149, certifications: 1571, election_workers: 198865, certification_workers: 80344, single_union_elections: 2937, single_union_certifications: 1402, single_union_election_workers: 172302, single_union_certification_workers: 60579, cases: 5036 },
  { year: 1988, elections: 3377, certifications: 1700, election_workers: 208394, certification_workers: 84460, single_union_elections: 3226, single_union_certifications: 1578, single_union_election_workers: 191198, single_union_certification_workers: 70851, cases: 5700 },
  { year: 1989, elections: 3670, certifications: 1839, election_workers: 243045, certification_workers: 96771, single_union_elections: 3538, single_union_certifications: 1732, single_union_election_workers: 218572, single_union_certification_workers: 74930, cases: 6376 },
  { year: 1990, elections: 3536, certifications: 1773, election_workers: 229015, certification_workers: 78993, single_union_elections: 3408, single_union_certifications: 1672, single_union_election_workers: 214691, single_union_certification_workers: 68773, cases: 5678 },
  { year: 1991, elections: 3089, certifications: 1465, election_workers: 192257, certification_workers: 74229, single_union_elections: 2948, single_union_certifications: 1348, single_union_election_workers: 177703, single_union_certification_workers: 62490, cases: 4902 },
  { year: 1992, elections: 2927, certifications: 1476, election_workers: 183865, certification_workers: 66984, single_union_elections: 2785, single_union_certifications: 1354, single_union_election_workers: 167005, single_union_certification_workers: 54433, cases: 4697 },
  { year: 1993, elections: 2991, certifications: 1524, election_workers: 203674, certification_workers: 85002, single_union_elections: 2888, single_union_certifications: 1436, single_union_election_workers: 178985, single_union_certification_workers: 67744, cases: 4853 },
  { year: 1994, elections: 3020, certifications: 1481, election_workers: 186339, certification_workers: 73643, single_union_elections: 2891, single_union_certifications: 1370, single_union_election_workers: 173697, single_union_certification_workers: 63699, cases: 4437 },
  { year: 1995, elections: 2860, certifications: 1456, election_workers: 191825, certification_workers: 76363, single_union_elections: 2763, single_union_certifications: 1375, single_union_election_workers: 182802, single_union_certification_workers: 69961, cases: 4320 },
];

// Petition ratios from the reports are a year's elections (or certifications)
// over the same year's petitions, not a cohort of petitions: off when filings
// change fast (FY1982-85), and RM elections are in the numerator before FY1964.
const annual_report_ratios = annual_reports.map((row) => ({
  year: row.year,
  election_ratio: row.cases ? row.elections / row.cases : null,
  win_ratio: row.cases ? row.certifications / row.cases : null,
  election_win_ratio: row.certifications / row.elections,
  single_union_election_unit_size:
    row.single_union_election_workers / row.single_union_elections,
  single_union_certification_unit_size:
    row.single_union_certification_workers / row.single_union_certifications,
}));
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
const drawChart = (y_domain, y_label, series, y, tickFormat, overlay) => {
  return Plot.plot({
    width: width < 200 ? width : 200,
    height: width < 200 ? width : 200,
    marginLeft: tickFormat === ".0%" ? margin + 8 : margin,
    marginRight: margin,
    marginTop: margin,
    marginBottom: margin,
    y: {
      grid: true,
      domain: y_domain,
      tickFormat: tickFormat,
      label: y_label,
    },
    x: {
      domain: [1950, last_year],
      tickFormat: "d",
      label: "",
    },
    marks: [
      // a vertical rule at the start of each decade
      Plot.gridX(d3.range(1950, last_year + 1, 10)),
      Plot.line(series, { x: "year", y: y }),
      overlay
        ? Plot.line(overlay, { x: "year", y: y, strokeDasharray: "3,2", stroke: "#c33" })
        : null,
    ],
  });
};
```
