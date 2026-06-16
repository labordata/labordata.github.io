---
title: Labor Union CRM Market Research
layout: post
description: Which CRM / member-management vendors local unions buy, and how much they spend, from LM-2 filings.
reactive: true
---

The market for CRM or member management for local labor unions in the United
States appears to be unconsolidated. SalesForce and UnionWare seem to capture an
outsize portion of spend, but that appears to be driven by a small number of
expensive systems for very large locals.

## Methodology

Labor unions with annual receipts larger than $250,000 are required to fill an
[LM-2
form](https://www.dol.gov/sites/dolgov/files/OLMS/regs/compliance/GPEA_Forms/forms/lm2_form_facsimile_2022.pdf)
and submit it to the Department of Labor's Office of Labor-Management Standards
yearly.

We use this form to find unions that are using a CRM product and how much they
are spending on it.

Here's our procedure. For each local union that files LM-2 forms, we look at the
forms filed starting in 2010 for mentions of the CRM company or product in the
disbursement or purchases schedules (schedules 18 and 4, respectively). If a union
has multiple years in which a CRM company or product were mentioned, we just look
at the most recent form. If more than one company is mentioned, we choose the
company that received more money from the union.

This method definitely under-counts the number of unions that are using a CRM
product and how much they are paying for it, but it is difficult to evaluate the
extent of the error. In June, 2022, UnionWare claimed to serve [158 unions across
three
countries](https://web.archive.org/web/20220626194835/https://www.unionware.com/products).
Our methodology has finds 43. If their number is still accurate, then our estimate
for UnionWare is off by at most 267%.

The CRM companies and products are listed below:

| Company | Product |
|-|-|
| UnionWare | [UnionWare](https://www.unionware.com/) |
| SalesForce | [SalesForce](https://www.salesforce.com/) |
| [Winmill Software](https://www.winmill.com/) | [eMembership](https://emembership.winmill.com) |
|[RCS Union Software](https://www.rcsunionsoftware.com/) |  |
| Aptify | [Aptify](https://www.aptify.com/) |
| union.dev | [union.dev](https://union.dev/) |
| [Advanced Solutions International](https://www.advsol.com) | [iMIS](https://www.imis.com/) |
| UnionTrack | [UnionTrack](https://www.uniontrack.com/) |
| [Paragon Corporation](https://www.paragoncorporation.com) | [MemTrack](https://www.paragoncorporation.com/union) |
| Union Digital | [UN1ON](https://union1software.com/) |
| [INCOM Integrated Computer Systems](https://www.netincom.net/) | [MTP](https://www.membershiptrackingprogram.com/) |
| Union365 | [Union365](https://union365.ca/) |
| [KMR Systems](https://www.kmrsystems.com/) | |
| [Strategic Organizing Systems](https://strategicorganizingsystems.com/salesforce/) | |

Notes:

A number of other vendors do sell CRMs, but their CRMs are much less popular than
their other offerings. Since the LM data typically does not allow us to identify
which product was bought from a vendor, we exclude these vendors: Microsoft,
Oracle, and [RCS Union Software](https://www.rcsunionsoftware.com/).

```js
display(
  Plot.plot({
    title: "Estimated Annual Spend",
    marginBottom: 100,
    y: {
      transform: (d) => d / 1000000,
      label: "↑ Spend (US dollars, millions)",
      grid: 5,
    },
    x: {
      tickRotate: -30,
    },
    marks: [
      Plot.barY(crm_market, {
        x: "company",
        y: "spend",
        sort: { x: "y", reverse: true },
      }),
      Plot.ruleY([0]),
    ],
  }),
);
```

```js
display(
  Plot.plot({
    title: "Estimated Local Union Clients",
    marginBottom: 100,
    x: {
      tickRotate: -30,
      label: "Product",
    },
    y: { label: "↑ Number of locals" },
    marks: [
      Plot.barY(crm_market, {
        x: "company",
        y: "cnt",
        sort: { x: "y", reverse: true },
      }),
      Plot.ruleY([0]),
    ],
  }),
);
```

If we segment the locals by size into three groups (small: 0-999, medium:
1,000-9,999, large: 10,000+), we can see that SalesForce's and UnionWare's spend
is driven by the large locals.

```js
display(
  Plot.plot({
    title: "Estimated Annual Spend, Segmented by Local Size",
    marginBottom: 100,
    marginRight: 50,
    y: {
      transform: (d) => d / 1000000,
      label: "↑ Spend (US dollars, millions)",
      grid: 5,
    },
    fy: { label: null },
    x: {
      tickRotate: -30,
    },
    marks: [
      Plot.barY(crm_market, {
        x: "company",
        y: "spend",
        fy: "size",
        sort: { x: "y", reverse: true },
      }),
      Plot.ruleY([0]),
    ],
  }),
);
```

```js
display(
  Plot.plot({
    title: "Estimated Local Union Clients, Segmented by Local Size",
    marginBottom: 100,
    marginRight: 50,
    x: {
      tickRotate: -30,
      label: "Product",
    },
    fy: { label: null },
    y: { label: "↑ Number of locals" },
    marks: [
      Plot.barY(crm_market, {
        x: "company",
        y: "cnt",
        fy: "size",
        sort: { x: "y", reverse: true },
      }),
      Plot.ruleY([0]),
    ],
  }),
);
```

```js
import { DatasetteClient } from "/assets/js/datasette-client.js";
const db = new DatasetteClient("https://duckdb-labordata.bunkum.us/opdr");
```

```js
const crm_market = await db.query`with crm_expenditures as (
  SELECT
    name,
    purpose,
    coalesce(itemized, 0) + coalesce(non_itemized, 0) as amount,
    ar_payer_payee.rpt_id
  FROM
    ar_payer_payee
    left join ar_disbursements_genrl using (payer_payee_id)
  WHERE
    payer_payee_type = 1002
    and (
      name LIKE '%salesforce%'
      OR name LIKE '%aptify%'
      OR name LIKE '%unionware%'
      OR name LIKE '%winmill%'
      OR name LIKE '%union.dev%'
      OR name LIKE '%advanced solutions%'
      OR name LIKE '%uniontrack%'
      OR name LIKE '%union track%'
      OR name LIKE '%paragon corp%'
      OR name LIKE '%INTEGRATED COMP%'
      OR lower(name) = 'incom'
      OR name LIKE '%kmr system%'
      OR name LIKE '%strategic organizing system%'
      or name like '%john sladkus%'
      OR purpose LIKE '%salesforce%'
      OR purpose LIKE '%unionware%'
      OR purpose LIKE '%aptify%'
      OR (
        purpose like '%IMIS%'
        and purpose not like '%ADIMIS%'
      )
      OR purpose LIKE '%UNIONTRACK%'
    )
  UNION ALL
  SELECT
    description,
    null as purpose,
    cash_paid,
    rpt_id
  FROM
    ar_disbursements_inv_purchases
  WHERE
    (
      description LIKE '%salesforce%'
      OR description LIKE '%aptify%'
      OR description LIKE '%unionware%'
      OR description LIKE '%winmill%'
      OR description LIKE '%union.dev%'
      OR description LIKE '%advanced solutions%'
      OR description LIKE '%uniontrack%'
      OR description LIKE '%union track%'
      OR description LIKE '%paragon corp%'
      OR description LIKE '%INTEGRATED COMP%'
      OR lower(description) = 'incom'
      OR description LIKE '%kmr system%'
      OR description LIKE '%strategic organizing system%'
      or description like '%john sladkus%'
    )
),
ranked as (
  SELECT
    f_num,
    members,
    name,
    purpose,
    amount,
    row_number() OVER (
      PARTITION BY f_num
      ORDER BY
        pd_covered_from DESC,
        amount desc
    ) AS rnk
  from
    crm_expenditures
    inner join lm_data using (rpt_id)
  where
    pd_covered_from >= '2010'
    AND desig_name = 'LU'
)
SELECT
  CASE
    WHEN members < 1000 THEN 'small'
    WHEN members < 10000 THEN 'medium'
    WHEN members >= 10000 THEN 'large'
  END as size,
  CASE
    WHEN purpose like '%salesforce%'
    OR name LIKE '%salesforce%' THEN 'SalesForce'
    WHEN purpose like '%unionware%'
    OR name LIKE '%unionware%' THEN 'UnionWare'
    WHEN name LIKE '%winmill%' THEN 'eMembership'
    WHEN name LIKE '%union.dev%' THEN 'union.dev'
    WHEN purpose like '%IMIS%'
    OR name LIKE '%advanced solutions%' THEN 'iMIS'
    WHEN purpose like '%uniontrack%'
    OR name LIKE '%uniontrack%'
    OR name LIKE '%union track%' THEN 'UnionTrack'
    WHEN name LIKE '%paragon corp%' THEN 'MemTrack'
    WHEN name LIKE '%INTEGRATED COMP%'
    OR lower(name) = 'incom' THEN 'MTP'
    WHEN name LIKE '%kmr system%' THEN 'KMR Systems'
    WHEN name LIKE '%strategic organizing system%'
    or name like '%john sladkus%' THEN 'Strategic Organizing System'
    WHEN purpose like '%aptify%'
    OR name LIKE '%aptify%' THEN 'Aptify'
    ELSE NULL
  END AS company,
  count(*) as cnt,
  sum(amount) as spend
FROM
  ranked
WHERE
  rnk = 1
GROUP BY
  size,
  company`;
```
