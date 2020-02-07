Comparing within overlapping s0-n0 space
================

Where the datasets fall
-----------------------

![](overlap_files/figure-markdown_github/dataset%20space-1.png)

    ## Warning: Removed 14530 rows containing missing values (geom_point).

![](overlap_files/figure-markdown_github/dataset%20space-2.png)

    ## Warning: Removed 14530 rows containing missing values (geom_point).

![](overlap_files/figure-markdown_github/dataset%20space-3.png)

    ## # A tibble: 6 x 3
    ##   dat              count    prop
    ##   <chr>            <int>   <dbl>
    ## 1 bbs                 98 0.544  
    ## 2 fia_short            1 0.00556
    ## 3 gentry              22 0.122  
    ## 4 mcdb                 8 0.0444 
    ## 5 misc_abund_short    50 0.278  
    ## 6 portal_plants        1 0.00556

The datasets overlap but do occupy broadly different regions of S\*N space. The arm - which is the weirdest region of the percentile values - is, unfortunately, 100% one dataset (Gentry).

For the vast majority of S\*N space here, I don't think we can really use dataset as a predictor of percentile, because of the way they occupy different parts of what we know to be a very important range of variation.

We *could* narrow in on the region of maximum overlap/minimum variation and make comparison based on the sites only within that.

I think there's a plausible comparison between bbs and misc\_abund in the subset depicted above. You could find other regions of pairwise intersection between the other datasets, but I don't love going down that road (of maximum comparisons).

![](overlap_files/figure-markdown_github/overlap%20plots-1.png)![](overlap_files/figure-markdown_github/overlap%20plots-2.png)![](overlap_files/figure-markdown_github/overlap%20plots-3.png)![](overlap_files/figure-markdown_github/overlap%20plots-4.png)![](overlap_files/figure-markdown_github/overlap%20plots-5.png)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](overlap_files/figure-markdown_github/overlap%20plots-6.png)![](overlap_files/figure-markdown_github/overlap%20plots-7.png)![](overlap_files/figure-markdown_github/overlap%20plots-8.png)

This is a rough comparison all around, but I am not seeing a pronounced difference in behavior between the datasets.
