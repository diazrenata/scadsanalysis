Synthesis report
================

# Datasets in S and N space

Here is where our communities fall in S and N space:

![](95_interval_portal_files/figure-gfm/datasets%20in%20s%20and%20n%20space-1.png)<!-- -->

Here is how that translates into the size of the feasible set:

![](95_interval_portal_files/figure-gfm/size%20of%20fs-1.png)<!-- -->![](95_interval_portal_files/figure-gfm/size%20of%20fs-2.png)<!-- -->![](95_interval_portal_files/figure-gfm/size%20of%20fs-3.png)<!-- -->

The small datasets are basically all FIA.

Note that the color scale is log transformed, so the largest communities
have e^331.5401042, or 9.683621310^{143}, elements in the feasible set\!

# 95 interval vs nparts

![](95_interval_portal_files/figure-gfm/95%20interval-1.png)<!-- -->![](95_interval_portal_files/figure-gfm/95%20interval-2.png)<!-- -->![](95_interval_portal_files/figure-gfm/95%20interval-3.png)<!-- -->![](95_interval_portal_files/figure-gfm/95%20interval-4.png)<!-- -->

    ## Warning: Removed 11 rows containing missing values (geom_point).

![](95_interval_portal_files/figure-gfm/95%20interval-5.png)<!-- -->

    ## Warning: Removed 15 rows containing missing values (geom_point).

![](95_interval_portal_files/figure-gfm/95%20interval-6.png)<!-- -->

# Binned by ranked nparts and ranked 95 intervals

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](95_interval_portal_files/figure-gfm/binned%20skew-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](95_interval_portal_files/figure-gfm/binned%20skew-2.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](95_interval_portal_files/figure-gfm/binned%20skew-3.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](95_interval_portal_files/figure-gfm/binned%20simpson-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](95_interval_portal_files/figure-gfm/binned%20simpson-2.png)<!-- -->

# Small mcdb

    ## Warning: Removed 100 rows containing missing values (geom_point).

![](95_interval_portal_files/figure-gfm/small%20mcdb-1.png)<!-- -->

    ##   sim   source  dat site singletons s0  n0   nparts     skew  shannon   simpson
    ## 1 -99 observed mcdb 1724       TRUE 24 118 67867303 2.414811 1.990816 0.7806665
    ##   skew_percentile shannon_percentile simpson_percentile skew_range
    ## 1         77.6194           0.100025            0.60015   4.463304
    ##   simpson_range nsamples   skew_sd skew_mean simpson_sd simpson_mean  skew_2p5
    ## 1     0.3047975     3999 0.7545883  1.856245 0.03081419    0.9025698 0.5497199
    ##   skew_97p5  skew_95   skew_min simpson_max simpson_2p5 simpson_5 simpson_97p5
    ## 1  3.522572 3.218997 -0.2232043   0.9515944   0.8208489 0.8452743    0.9418271
    ##   skew_95_ratio_2t simpson_95_ratio_2t skew_95_ratio_1t simpson_95_ratio_1t
    ## 1        0.6660653           0.3969133        0.7712226           0.3488219
    ##   log_nparts log_nsamples log150_nparts   prop_found found_all
    ## 1   18.03306       8.2938      3.598958 5.892381e-05     FALSE

![](95_interval_portal_files/figure-gfm/load%20one%20site-1.png)<!-- -->![](95_interval_portal_files/figure-gfm/load%20one%20site-2.png)<!-- -->

    ## Warning: Removed 1 rows containing non-finite values (stat_density).

![](95_interval_portal_files/figure-gfm/load%20one%20site-3.png)<!-- -->
