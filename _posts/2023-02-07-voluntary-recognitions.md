---
title: 2022 Voluntary Recognitions
layout: post
description: Voluntary recognitions and older NLRB data
---

Just got my FOIA back for the voluntary recognitions known to the NLRB
for the [fourth quarter of 2022](https://www.muckrock.com/foi/united-states-of-america-10/voluntary-recognitions-october-1-2022-december-31-2022-138379/), so here's what we can say about voluntary recognitions in 2022.

In 2022, there were [209 voluntary recognitions](https://labordata.bunkum.us/voluntary_recognitions-9901464?sql=select%0D%0A++cast%28%0D%0A++++strftime%28%27%25Y%27%2C+%22Date+VR+Request+Received%22%29+as+int%0D%0A++%29+year%2C%0D%0A++count%28%22VR+Case+Number%22%29%2C%0D%0A++sum%28%22Number+of+Employees%22%29+as+year%0D%0Afrom%0D%0A++voluntary_recognitions%0D%0Awhere%0D%0A++year+%3D+2022%0D%0Agroup+by%0D%0A++year%3B) known to the NLRB covering at least
11,182 workers. The caveat of "known to the NLRB" is important because there is no
requirement that voluntary recognitions be reported to the NLRB, and we have no 
idea about what proportion of voluntary recognitions are ever reported to the NLRB.

That said, in 2022, there were about [1,100 NLRB
elections](https://labordata.bunkum.us/nlrb-ca1e99a?sql=with+distinct_units+as+%28%0D%0A++select%0D%0A++++distinct+cast%28strftime%28%27%25Y%27%2C+date_closed%29+as+int%29+as+year%2C%0D%0A++++voting_unit_id%2C%0D%0A++++unit_size%0D%0A++from%0D%0A++++filing%0D%0A++++inner+join+voting_unit+using+%28case_number%29%0D%0A++++inner+join+election+using+%28voting_unit_id%29%0D%0A++++inner+join+election_result+using+%28election_id%29%0D%0A++where%0D%0A++++case_type+%3D+%27RC%27%0D%0A++++and+year+%3D+2022%0D%0A++++and+reason_closed+%3D+%27Certific.+of+Representative%27%0D%0A++++and+ballot_type+%3D+%27Single+Labor+Organization%27%0D%0A%29%0D%0Aselect%0D%0A++year%2C%0D%0A++count%28voting_unit_id%29%2C%0D%0A++sum%28unit_size%29%0D%0Afrom%0D%0A++distinct_units)
that resulted in certified bargaining representative covering over
55,000 workers.

Understanding organizing activity outside the NLRB process remains a priority. 

The future of this NLRB data is not certain as [the NLRB is
considering returning to the previous voluntary recognition bar
rule](https://www.nlrb.gov/news-outreach/news-story/nlrb-issues-notice-of-proposed-rulemaking-on-fair-choice-and-employee),
which prevents the filing of representation election petition within six
months of a voluntary recognition. In 2020, Trump's NLRB modified the
rule to require a notice to the NLRB for the rule to take effect along
with a 45-day period after the receipt of notice when a petition could
be filed. The notification requirements is what has produced these
records, and it's likely when the requirement is rescinded, the data
will cease.

## CHIPS
With the assistance of [JP Ferguson](https://www.jpferguson.net/),
we've figured out the [codes for many of the fields in
CHIPS](https://github.com/labordata/CHIPS#erd-diagram), the
1984-2000ish NLRB case management system.

It's going to be pretty hard to do much more without more
documentation, than what's [available from the National
Archive](https://catalog.archives.gov/id/627716). If you have any
CHIPS manuals from the late 1990s or early 2000s, please let me know.

## Pre-CHIPS
Also, thanks to [JP Ferguson's
blog](https://www.jpferguson.net/blog/blog-post-title-one-ez8bs-gbmmb),
I learned that there were a number of electronic records for [Unfair
Labor Cases](https://archive.ciser.cornell.edu/studies/239), [Representation Cases](https://archive.ciser.cornell.edu/studies/2103), and [Elections](https://archive.ciser.cornell.edu/studies/237) on deposit at [CISER](https://archive.ciser.cornell.edu/about).

These records go back to the early 1960s and 1970s, which is fabulous. 

They are also a bit of a mystery. The FOIA officer at the NLRB, who is
very good and very knowledgeable about the agency's information
systems knows nothing about these data, but the archivist at the
Cornell Center of Social Sciences confirms that these records came
from the NLRB. If you know anything more about these records, please
let me know.

I'm planning on adding these to the the warehouse.


