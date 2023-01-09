---
title: How to build a corporate registry?
layout: post
description: What would it take to build a registry of US corporate entiteis
---

# Registry of Corporate Firms and Establishments

In 2023, I’m going to be working on organizing data about employers that will be useful to the labor movement. That means things like identifying the employers that repeatedly violate labor law, or employers that have many but not all units organized.

This is going to take a lot of [record linkage](https://en.wikipedia.org/wiki/Record_linkage) within and across datasets. That’s a pain, but I have spent a long time building [good record linkage technology](https://docs.dedupe.io/en/latest/), so I think we can do it.

Unfortunately, it’s also going to mean I’ll have to create unique identifiers for business firms and establishments.

I would really, really like to not be in the business of minting unique identifiers. Ideally, there would be an existing registry of coporate filings and establishment, that I could match against and use that registry's identifiers. If that existed, then my work could be linked easily against datasets created by other folks who used the same set of identifiers. 

Without that registry, the identifiers I will mint will be of very limited use for connecting my data to others outside the labordata project. To link other datasets to mine, it will be yet another record linkage problem.

But, in 2023 we don’t have an open registry of firms or establishments that is anywhere near comprehensive, so I will proceed without one. Alack. 

Of course, an open dataset of corporate identifiers could be useful for a ton of goals beyond my own. It’s one of those constant frustrations which, if solved to some satisfaction, could save a lot of people a lot of time. With that in mind, I reached out to [Jeremy Singer-Vine](https://www.jsvine.com/) of the [Data Liberation](https://www.data-liberation-project.org/)  and we’ve been talking about how we would go about it, if we were foolish to build such a registry.

I’m writing this in the [spirit of being wrong on the internet](https://meta.wikimedia.org/wiki/Cunningham%27s_Law), with hope you, my dear reader, will let me know about how wrong I am.

## What this registry would contain
* Establishment names
* Establishment addresses
* Official government identifiers (EINs, state IDs, etc.)
* Unofficial identifiers (e.g., DUNS numbers)

##  Datasets we can’t use.
* Dunn and Bradstreet. Very expensive and highly restrictive on re-use
* OpenCorporates: Still very expensive and highly restrictive on re-use
* IRS data: Not available for for-profit data without very restrictive access controls. Academic researcher can get access, but the process is difficult and no data republishing is allowed
* FinCen’s [registry of beneficial ownership](https://www.fincen.gov/news/news-releases/fincen-issues-notice-proposed-rulemaking-regarding-access-beneficial-ownership). No public access.
* UNICORE. The AFL-CIO has a database of establishments, firms, and unionization status. I have heard different things about its data quality and whether it is actively maintained. No public access

So, that’s what’s walled off. If we were to try to build a registry from open, public data, these are the data sources we would use.

## Partial datasets that we can use to knit something together.
* [SEC Filings](https://www.sec.gov/edgar/sec-api-documentation): All publicly-traded companies
* [IRS 990 data](https://www.irs.gov/charities-non-profits/tax-exempt-organization-search-bulk-data-downloads): Nearly all tax-exempt organizations
* [All the Places](https://www.alltheplaces.xyz/): A OpenStreetMap affiliated project to collect retail establishments.
* [State level corporate registrations](https://opencorporates.com/registers)
* Filings and registrations to regulators for federally regulated industries

Please let us know if we are missing something important other datasets or initiatives! If you are interested in helping on something like this, then let us know.

