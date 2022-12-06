---
title: Parsing Labor Union Names / UNICORE
layout: post
description: Name parsing and a few other pieces.
---

## Parsing Local Union Names, Probabilistically
In order to link up data about unions between and within data sets,
I'm starting to build a tool to link local unions to their entries in the [in
the LM
data](https://labordata.bunkum.us/opdr?sql=select+f_num%2C+union_name%2C+aff_abbr%2C+desig_name%2C+desiq_pre%2C+desig_num%2C+desig_suf+from+lm_data+group+by+rpt_id%3B+). To
help with the linking, it's useful to try to parse the parts of a
local union name.

For example, "JNESO District Council 1-111" could be broken down into
the following parts:

| Token | Type |
|-|-|
| JNESO    | AffiliationAbbreviation |
| District | LevelType               |
| Council  | LevelType               |
| 1        | DistrictIdentifier      |
| 111      | LocalIdentifier         |
{:class="table table-bordered"}

I have a good start:
[`localunionparser`](https://github.com/labordata/localunionparser). So
far it's only trained on [FMCS F-7
data](https://github.com/labordata/fmcs-f7), but it will get more
robust over time with more training data from the FMCS and other sources.

Anyway, this tool might be useful to some of you now, and when it is
integrated into a lookup tool, it should be useful to more of you.

The parser uses a [linear-chain conditional random
field](https://en.wikipedia.org/wiki/Conditional_random_field), which
was state of the art before the deep learning revolution. I'd love to
see an approach with a recurrent neural network, but I still haven't
really dug into that technology yet.

## UNICORE

Today, I learned that the AFL-CIO has a database called UNICORE that
tracks worksites, parent companies, and unionization status. I'd love to 
learn more about the system, but there is very little information about it
on the internet.

In particular, I'm curious if the UNICORE data has identifiers for firms
and establishments that could be used by outside researchers. 

I'm going to be doing more and more linking of employers, and when I
do that, I'd like to use existing identifiers for firms and
establishments so that folks can easily link my work to other
datasets. Right now, there is not really a public dataset of employer
identifiers. 

We need one.

