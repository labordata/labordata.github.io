---
title: Introduction to Notes on Labor Data
layout: post
description: What are we doing here?
---

Hello, my name is Forest Gregg. 

I've experimenting with how
information technology can be of service to a more just, 
democratic, and joyful society for over a decade. 

Mainly, I've done this
as DataMade, where I am a partner. [DataMade](https://datamade.us) is
a data and web consultancy for civil society. We support our partners
in working toward democracy, justice, and equity. Our clients are
mainly in journalism, non-profits, and local government.

Over the past couple of years, we've been very lucky to work with more
people in the labor movement. We've helped extract (or tried to help
extract) data from LM10s for academic researchers. We've also
worked with researchers at a large international union to gather data
on the anti-consumer pricing strategies of a target industry.

Outside of those professional engagements, I've worked with an union
local in Chicago to develop indicators to help prioritize work sites
for organizing efforts.

Perhaps of greatest interest for this venue, I've been
building a publicly accessible data warehouse of public records
related to the labor movement:
[labordata.bunkum.us](https://labordata.bunkum.us)

Using NLRB data as an example, I have written a [web scraper that
fetches information about NLRB cases and election results from the
NLRB website](https://github.com/labordata/nlrb-cases). This scraper
[runs nightly](https://github.com/labordata/nlrb-data), and the data
gets formatted into a set of [normalized relational database
tables](https://labordata.bunkum.us/nlrb). Users can query the dataset
on the website, download the full NRLB database, or download
individual tables as CSV files.

I have similar scrapers running nightly for 
* [FMCS F-7 intent to bargain notices](https://labordata.bunkum.us/f7)
* [LM-2, 3, 4, 5](https://labordata.bunkum.us/opdr-e1b0dc0), [20, and 21](https://labordata.bunkum.us/lm20-ac414f3) filings from the OLMS

In addition to the scrapers, at the end every quarter [I file a public
records request with the NLRB for notifications of voluntary
recognitions that the Board has received in that
quarter](https://github.com/labordata/nlrb-voluntary-recognitions). These
are also [added to the data
warehouse](https://labordata.bunkum.us/voluntary_recognitions).

Finally, the warehouse includes some dataset that are not updated, but very useful:
* Data from the two [previous](https://labordata.bunkum.us/old_nlrb-e3173b5) NLRB [case management systems](https://labordata.bunkum.us/chips)
* The [work stoppage data](https://labordata.bunkum.us/work_stoppages) that the FMCS published on their website through the end of 2020

All these data are instantly available, and the underlying scraper and code to transform the data are open source and publicly available on GitHub.

It is my hope that this effort will make using public records on labor data much easier, and I have been gratified to see that it has already been used by a number of researchers and union activists. 

I'm planning on continuing to improve this resource by adding additional data sources and by creating crosswalks to link the unions and firms within and across these datasets.

In this blog and newsletter, I'll be posting updates on updates and
changes to the data and analyses of those data.
