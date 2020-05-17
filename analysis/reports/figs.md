Synthesis report
================

# Datasets in S and N space

Here is where our communities fall in S and N space:

![](figs_files/figure-gfm/datasets%20in%20s%20and%20n%20space-1.png)<!-- -->

Here is how that translates into the size of the feasible set:

![](figs_files/figure-gfm/size%20of%20fs-1.png)<!-- -->![](figs_files/figure-gfm/size%20of%20fs-2.png)<!-- -->![](figs_files/figure-gfm/size%20of%20fs-3.png)<!-- -->

The small datasets are basically all FIA.

Note that the color scale is log transformed, so the largest communities
have e^331.5401042, or 9.683621310^{143}, elements in the feasible set\!

# 95 interval (one tailed) vs nparts

![](figs_files/figure-gfm/95%20interval-1.png)<!-- -->

# Overall percentile values

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](figs_files/figure-gfm/overall-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](figs_files/figure-gfm/overall-2.png)<!-- -->

# Within the FIA size range

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](figs_files/figure-gfm/within%20FIA%20size%20range-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 228 rows containing non-finite values (stat_bin).

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

    ## Warning: Removed 228 rows containing non-finite values (stat_bin).

![](figs_files/figure-gfm/95%20hists-1.png)<!-- -->

# Rarefaction

    ## Joining, by = c("dat", "site")

![](figs_files/figure-gfm/rarefaction%20change-1.png)<!-- -->

    ## # A tibble: 2 x 2
    ##   is_fia high_skew
    ##   <chr>      <dbl>
    ## 1 fia       0.0905
    ## 2 other     0.184

    ## # A tibble: 2 x 2
    ##   is_fia low_even
    ##   <chr>     <dbl>
    ## 1 fia       0.173
    ## 2 other     0.380
