Synthesis report - found all samples
================

There is some weird behavior where, for datasets where all samples were found, we do not see the disproportionately common extreme %ile values. I see a couple of reasons for this: - very small communities are naturally bizarre and not super meaningful - there's something squirrely with %ile

Distribution of percentile values
=================================

Skewness
--------

Here is the overall distribution of skewness, and if we split based on whether we found all the samples: ![](found_all_files/figure-markdown_github/skew%20percentiles-1.png)![](found_all_files/figure-markdown_github/skew%20percentiles-2.png)

When we found all the samples, the percentiles are more evenly distributed. I do not read much into the spike at 0 for those communities, because skewness is bizarre for very small communities.

Here is how skewness maps with S and N, *filtered to communities where we found all samples*: ![](found_all_files/figure-markdown_github/skew%20v%20s%20and%20n-1.png)

Here is how the histogram changes as we bin the lognparts into 2s:

![](found_all_files/figure-markdown_github/binned%20nparts-1.png)

Simpson
-------

Here is the overall evenness distribution, and split by whether we found 'em all:

![](found_all_files/figure-markdown_github/simpson%20percentiles-1.png)![](found_all_files/figure-markdown_github/simpson%20percentiles-2.png)

Simpson is less evenly distributed than skewness. Again, where we found them all, we don't see the disproportionately common low percentile values.

Here is how Simpson behaves in S and N space where we found them all:

![](found_all_files/figure-markdown_github/even%20v%20s%20and%20n-1.png)

Here is how the histogram changes as we bin the lognparts into 5s:

![](found_all_files/figure-markdown_github/binned%20nparts%20even-1.png)

!!!!! OK SO!!!!!

It is NOT ABOUT whether we found all the samples. It is that the %iles look pretty UNIFORMLY DISTRIBUTED for communities with up to somewhere from 2.202646610^{4} to 3.269017410^{6} elements in the feasible set. Then the extremes emerge: high for skew and low for Simpson.

We expect issues of small N, but not for communities even so large. So if there are even 150 elements in the FS, we expect to be able to identify some kind of central tendency.

![](found_all_files/figure-markdown_github/nparts%20classification-1.png)

Communities with more than 2.202646610^{4} parts in the FS account for about 21.4649939% of communities.

![](found_all_files/figure-markdown_github/nparts%20by%20dat-1.png)

    ## # A tibble: 7 x 3
    ##   dat              prop_more_than_10 nsites
    ##   <chr>                        <dbl>  <int>
    ## 1 bbs                         0.999    2773
    ## 2 fia_short                   0.115   10355
    ## 3 fia_small                   0.0341  10000
    ## 4 gentry                      0.987     223
    ## 5 mcdb                        0.467     613
    ## 6 misc_abund_short            0.799     542
    ## 7 portal_plants               0.951      61

![](found_all_files/figure-markdown_github/nparts%20and%20dat-1.png)![](found_all_files/figure-markdown_github/nparts%20and%20dat-2.png)

    ## Warning: Removed 2638 rows containing missing values (geom_point).

![](found_all_files/figure-markdown_github/nparts%20variability-1.png)

    ## Warning: Removed 53 rows containing missing values (geom_point).

![](found_all_files/figure-markdown_github/nparts%20variability-2.png)

![](found_all_files/figure-markdown_github/mean%20v%20sd-1.png)![](found_all_files/figure-markdown_github/mean%20v%20sd-2.png)![](found_all_files/figure-markdown_github/mean%20v%20sd-3.png)

Mean and sd are correlated.

![](found_all_files/figure-markdown_github/cv%20in%20space-1.png)![](found_all_files/figure-markdown_github/cv%20in%20space-2.png)

Coefficients of variation for skewness and evenness follow clear S and N gradients.

    ## Warning: Removed 194 rows containing missing values (geom_point).

![](found_all_files/figure-markdown_github/cv%20v%20nparts-1.png)

    ## Warning: Removed 194 rows containing missing values (geom_point).

![](found_all_files/figure-markdown_github/cv%20v%20nparts-2.png)

The CV scans with nparts and drops off suspiciously right around the same place where the threshold shows up for percentile.

![](found_all_files/figure-markdown_github/cv%20v%20percentile-1.png)![](found_all_files/figure-markdown_github/cv%20v%20percentile-2.png)
