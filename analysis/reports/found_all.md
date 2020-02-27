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

So I'm pretty sure the spike at 0 is the communities with 1 or 2 species, for which we shouldn't be calculating skewness anyway.

Here is how the histogram changes as we bin the lognparts into 5s:

![](found_all_files/figure-markdown_github/binned%20nparts-1.png)

Simpson
-------

Here is the overall evenness distribution, and split by whether we found 'em all:

![](found_all_files/figure-markdown_github/simpson%20percentiles-1.png)![](found_all_files/figure-markdown_github/simpson%20percentiles-2.png)

Simpson is less evenly distributed than skewness. Again, where we found them all, we don't see the disproportionately common low percentile values.

Here is how Simpson behaves in S and N space where we found them all:

![](found_all_files/figure-markdown_github/even%20v%20s%20and%20n-1.png)

There is nothing to learn when s0 = 1 or really 2.

Here is how the histogram changes as we bin the lognparts into 5s:

![](found_all_files/figure-markdown_github/binned%20nparts%20even-1.png)

!!!!! OK SO!!!!!

It is NOT ABOUT whether we found all the samples. It is that the %iles look pretty UNIFORMLY DISTRIBUTED for communities with up to somewhere from 2.202646610^{4} to 3.269017410^{6} elements in the feasible set. Then the extremes emerge: high for skew and low for Simpson.

We expect issues of small N, but not for communities even so large. So if there are even 150 elements in the FS, we expect to be able to identify some kind of central tendency.

![](found_all_files/figure-markdown_github/nparts%20classification-1.png)

Communities with more than 2.202646610^{4} parts in the FS account for about 33.7389531% of communities.

![](found_all_files/figure-markdown_github/nparts%20by%20dat-1.png)

    ## # A tibble: 6 x 3
    ##   dat              prop_more_than_10 nsites
    ##   <chr>                        <dbl>  <int>
    ## 1 bbs                          0.999   2773
    ## 2 fia_short                    0.115  10355
    ## 3 gentry                       0.987    223
    ## 4 mcdb                         0.467    613
    ## 5 misc_abund_short             0.799    542
    ## 6 portal_plants                0.951     61
