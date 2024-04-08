---
title: Counties for CHIPS and FMCS Deadend
layout: post
description: Thanks, Sean!
---

Couple of quick updates.

## Transcribed County Table for CHIPS dataset

[Sean Brailey](https://www.linkedin.com/in/sean-brailey-a4ab49284), Contract Data Engineer, [Labor Education and Research Center](https://lerc.uoregon.edu/), transcribed the [`l_county`](https://labordata.bunkum.us/chips-11c5680/l_county) table from the [codebook](https://s3.amazonaws.com/NARAprodstorage/opastorage/live/1/8902/890201/content/arcmedia/electronic-records/rg-025/chips/113.1CL.pdf) for the CHIPS dataset.

The CHIPS dataset contains information about NLRB cases from
1984-2000, and with Sean's work we can now quickly see the [top five
counties for RC cases in those sixteen years](https://labordata.bunkum.us/chips-11c5680?sql=select%0D%0A++county_name+as+county%2C%0D%0A++alpha_state_code+as+state%2C%0D%0A++count%28*%29+as+rc_cases%0D%0Afrom%0D%0A++r_master%0D%0A++inner+join+l_county+on+county+%3D+county_number%0D%0A++and+state+%3D+numeric_state_code%0D%0A++and+ctype+%3D+%27RC%27%0D%0Agroup+by%0D%0A++county_number%2C%0D%0A++numeric_state_code%0D%0Aorder+by%0D%0A++count%28*%29+desc): Cook, IL; Los Angeles, CA; New York; NY; Wayne, MI.

Previously, we had the [address of cases](https://labordata.bunkum.us/chips-11c5680/r_address), so this type of analysis was
possible before, but with much more effort.

## FMCS FOIA deadend

It looks like our long effort to try to get more unique identifiers for unions and
employers for the F7 Intent to Bargain notices has run its course. According the the
FOIA officer, the fields we want from their case management system are not used
even though they are present in their database schema.

So, back to record linkage. 
