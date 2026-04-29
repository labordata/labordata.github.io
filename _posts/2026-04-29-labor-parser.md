---
title: Local union predictor
layout: post
description: What local is this?
---

One of the difficulties of working with data about the labor movement is that it
is often difficult to know which labor organization you are dealing with.

[labor-union-parser](https://github.com/labordata/labor-union-parse/) is a new
Python package to lookup the a local union's Office of Management and Labor
Standards (OLMS) filing number from short texts like "United Automobile,
Aerospace and Agricultural Implement Workers of America, UAW Local 1803" and
"LOCAL 6, NEW YORK HOTEL & MOTEL TRADES COUNCIL, UNITE HERE."

Most labor organizations representing private sector workers are
[required to file an annual financial report with the Department of Labor's Office of Management and Labor Standards](https://www.dol.gov/agencies/olms/reports/forms/lm-1-lm-2-lm-3-lm-4).
The Office maintains a more or less consistent filing number for unions across
the filings, and so office's data is the closest we have to a comprehensive
gazette for private-sector-representing labor unions.

This tool uses a probabilistic model to do the lookup, and it's pretty accurate.
It predicts three things, is a text referring to a union, what is the union
affiliation of the local; what is the filing number of the union.

| Metric                                | Score             |
| ------------------------------------- | ----------------- |
| End-to-End Accuracy                   | 97.8%             |
| is union accuracy                     | 99.2% (4402/4437) |
| filing number accuracy                | 98.3% (3804/3868) |
| union name accuracy                   | 97.8% (4665/4771) |
| Wrong match (union, wrong filing num) | 64                |
| False negatives (union missed)        | 8                 |
| False positives (non-union matched)   | 27                |

In our test set, for the records we were able to identify as referring to
particular filing number we get 98.3% accuracy. As we'll see the performance is
often better than that.

## Practical example

I have this wired up into labordata.bunkum.us, where it runs every night against
any column in any table that refers to unions. Here's
[a query of the number of distinct election petition cases that unions participated in the last quarter of 2025](<https://labordata.bunkum.us/_memory?sql=SELECT%0D%0A++CASE%0D%0A++++WHEN+pred_is_union_score+%3C+0.5+THEN+'UNCERTAIN'%0D%0A++++WHEN+pred_union_name_score+%3C+0.5+THEN+'UNCERTAIN'%0D%0A++++ELSE+pred_union_name%0D%0A++END+AS+union_label%2C%0D%0A++COUNT(DISTINCT+case_number)+AS+cnt%0D%0AFROM%0D%0A++[nlrb].filing%0D%0A++INNER+JOIN+[nlrb].participant+USING+(case_number)%0D%0A++INNER+JOIN+[union_names_crosswalk].union_names_crosswalk+ON+[union_names_crosswalk].union_names_crosswalk.union_name+%3D+participant.participant%0D%0AWHERE%0D%0A++date_filed+%3E%3D+'2025-10-01'%0D%0A++AND+date_filed+%3C+'2026'%0D%0A++AND+case_type+%3D+'RC'%0D%0A++AND+subtype+%3D+'Union'%0D%0AGROUP+BY%0D%0A++union_label%0D%0AORDER+BY%0D%0A++union_label+%3D+'UNCERTAIN'%2C%0D%0A++cnt+DESC%3B>).

Across the 288 variations of the texts for participants, there is only one
error, and an instructive one. The California State University Employees Union
is mislabeled as belonging to "Field Representatives Union,"
[the staff union of the California Federation of Teachers](https://labordata.bunkum.us/opdr-b532245/lm_data?_sort=rpt_id&f_num__exact=517392).

To this point the California State University Employees Union has been a
public-sector union, and have never filed with the OLMS. This tool will go badly
wrong if the texts include public sector unions. If you have ideas for a good
data source for public sector locals, please let me know.

## Training data

In the repo, I have put together a training corpus of over 150,000 examples.

The accuracy of this model is the best I've been able to achieve, but much
smarter folks than me read these notes. Please use the data to make a better
model.
