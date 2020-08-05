Synthesis report
================

Datasets in S and N space
=========================

Here is where our communities fall in S and N space:

![](synthesis_files/figure-markdown_github/datasets%20in%20s%20and%20n%20space-1.png)

Here is how that translates into the size of the feasible set:

![](synthesis_files/figure-markdown_github/size%20of%20fs-1.png)

Note that the color scale is log transformed, so the largest communities have e^331.5401042, or 9.683621310^{143}, elements in the feasible set!

Here is how the size of the feasible set maps on to N/S. It increases with n0/s0 and s0.

![](synthesis_files/figure-markdown_github/nparts%20vs%20avgn-1.png)

Number of samples
=================

Here is how many samples we are achieving:

![](synthesis_files/figure-markdown_github/nsamples-1.png)

Only in small communities do we get appreciably fewer than 4000 samples.

Here is how the number of samples we're getting compares to the size of the feasible set:

![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-1.png)![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-2.png)![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-3.png)![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-4.png)

For about 30.3874915% of sites, we found all the elements of the FS. The *vast majority* of this is FIA - here is what happens if we take out FIA:

![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-1.png)![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-2.png)![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-3.png)![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-4.png)

Without FIA, we find all the samples about 10.1262916% of the time.

Distribution of percentile values
=================================

Skewness
--------

Here is the overall distribution of skewness, and if we split based on whether we found all the samples: ![](synthesis_files/figure-markdown_github/skew%20percentiles-1.png)![](synthesis_files/figure-markdown_github/skew%20percentiles-2.png)

When we found all the samples, the percentiles are more evenly distributed. I do not read much into the spike at 0 for those communities, because skewness is bizarre for very small communities.

Here is how skewness maps with S and N: ![](synthesis_files/figure-markdown_github/skew%20v%20s%20and%20n-1.png)

The very low skewness values are down in the very small and very weird communities. There may be variation along S and N elsewhere, but it is hard to parse.

Simpson
-------

Here is the overall evenness distribution, and split by whether we found 'em all:

![](synthesis_files/figure-markdown_github/simpson%20percentiles-1.png)![](synthesis_files/figure-markdown_github/simpson%20percentiles-2.png)

Simpson is less evenly distributed than skewness. Again, where we found them all, we don't see the disproportionately common low percentile values.

Here is how Simpson behaves in S and N space:

![](synthesis_files/figure-markdown_github/even%20v%20s%20and%20n-1.png)

There is unusual behavior where S is large and N/S is relatively small (log N/S &lt;= 1.5), where evenness is unusually *high*.

For both skew and evenness, we do not see non-extreme percentile values in large communities:

![](synthesis_files/figure-markdown_github/non%20extremes-1.png)![](synthesis_files/figure-markdown_github/non%20extremes-2.png)

Singletons
----------

Here is how singletons change percentiles, broken out by whether or not we found all the samples:

![](synthesis_files/figure-markdown_github/singletons%20overall-1.png)![](synthesis_files/figure-markdown_github/singletons%20overall-2.png)

The rarefaction-inflated datasets are strongly // the raw vectors. They have more extreme skewness and evenness values, relative to their feasible sets, than the raw vectors. This is almost always true for evenness, with a little more noise in the skewness signal. But either way, very strong.

Manipulations
=============

MACD
====

![](synthesis_files/figure-markdown_github/load%20macd-1.png)![](synthesis_files/figure-markdown_github/load%20macd-2.png)

Here are the distributions of skew and evenness, overall.

![](synthesis_files/figure-markdown_github/macd%20overall-1.png)![](synthesis_files/figure-markdown_github/macd%20overall-2.png)

Here is how manipulation affects things:

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](synthesis_files/figure-markdown_github/macd%20ctrlcomp-1.png)

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](synthesis_files/figure-markdown_github/macd%20ctrlcomp-2.png)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 2 rows containing non-finite values (stat_bin).

![](synthesis_files/figure-markdown_github/macd%20ctrlcomp-3.png)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 2 rows containing non-finite values (stat_bin).

![](synthesis_files/figure-markdown_github/macd%20ctrlcomp-4.png)

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](synthesis_files/figure-markdown_github/macd%20ctrlcomp-5.png)

    ## Warning: Removed 2 rows containing missing values (geom_point).

![](synthesis_files/figure-markdown_github/macd%20ctrlcomp-6.png)

    ## 
    ##  Paired t-test
    ## 
    ## data:  all_di_macd_manip$skew_percentile and all_di_macd_manip$ctrl_skew_percentile
    ## t = 2.1644, df = 119, p-value = 0.03243
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##   0.5271239 11.8517311
    ## sample estimates:
    ## mean of the differences 
    ##                6.189428

    ## 
    ##  Paired t-test
    ## 
    ## data:  all_di_macd_manip$simpson_percentile and all_di_macd_manip$ctrl_simpson_percentile
    ## t = -1.447, df = 119, p-value = 0.1505
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -8.033839  1.249765
    ## sample estimates:
    ## mean of the differences 
    ##               -3.392037

    ## 
    ##  Wilcoxon signed rank test with continuity correction
    ## 
    ## data:  all_di_macd_manip$skew_percentile and all_di_macd_manip$ctrl_skew_percentile
    ## V = 3993, p-value = 0.06652
    ## alternative hypothesis: true location shift is not equal to 0

    ## 
    ##  Wilcoxon signed rank test with continuity correction
    ## 
    ## data:  all_di_macd_manip$simpson_percentile and all_di_macd_manip$ctrl_simpson_percentile
    ## V = 2680, p-value = 0.2672
    ## alternative hypothesis: true location shift is not equal to 0

Change is going to be bounded at 100 and 0: you can't go up or down from there. (Another argument for increasing the number of samples?)

Portal plant manips
===================

Nsamples, singletons

![](synthesis_files/figure-markdown_github/pp%20overall-1.png)![](synthesis_files/figure-markdown_github/pp%20overall-2.png)

By treatment, season

![](synthesis_files/figure-markdown_github/portal%20trtmt-1.png)![](synthesis_files/figure-markdown_github/portal%20trtmt-2.png)![](synthesis_files/figure-markdown_github/portal%20trtmt-3.png)![](synthesis_files/figure-markdown_github/portal%20trtmt-4.png)

<!-- By year -->
<!-- ```{r plants year, fig.height = 25, fig.width = 5} -->
<!-- ggplot(data = filter(all_di_p, singletons == F), aes(x = treatment, y = skew_percentile)) + -->
<!--   geom_boxplot() + -->
<!--   theme_bw() + -->
<!--   facet_grid(rows = vars(year), cols = vars(season), scales = "free_y") -->
<!-- ggplot(data = filter(all_di_p, singletons == F), aes(x = treatment, y = simpson_percentile)) + -->
<!--   geom_boxplot() + -->
<!--   theme_bw() + -->
<!--   facet_grid(rows = vars(year), cols = vars(season), scales = "free_y") -->
<!-- ``` -->
Median

    ## Warning: Removed 9 rows containing missing values (geom_point).

    ## Warning: Removed 9 rows containing missing values (geom_point).

![](synthesis_files/figure-markdown_github/pp%20median-1.png)

    ## Warning: Removed 6 rows containing missing values (geom_point).

    ## Warning: Removed 7 rows containing missing values (geom_point).

![](synthesis_files/figure-markdown_github/pp%20median-2.png)
