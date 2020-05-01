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

![](95_interval_portal_files/figure-gfm/95%20interval-1.png)<!-- -->![](95_interval_portal_files/figure-gfm/95%20interval-2.png)<!-- -->

    ## Warning: Removed 11 rows containing missing values (geom_point).

![](95_interval_portal_files/figure-gfm/95%20interval-3.png)<!-- -->

    ## Warning: Removed 15 rows containing missing values (geom_point).

![](95_interval_portal_files/figure-gfm/95%20interval-4.png)<!-- -->

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

    ##   sim   source  dat site singletons s0 n0 nparts     skew  shannon   simpson
    ## 1 -99 observed mcdb 1879       TRUE 14 41   2738 2.902913 1.615595 0.6115407
    ##   skew_percentile shannon_percentile simpson_percentile skew_range
    ## 1        99.03939          0.1440922          0.1440922   5.956108
    ##   simpson_range nsamples   skew_sd skew_mean simpson_sd simpson_mean  skew_2p5
    ## 1     0.4021416     2082 0.7163278  1.445342 0.04671035    0.8598034 0.1013209
    ##   skew_97p5 simpson_2p5 simpson_97p5 skew_95_ratio simpson_95_ratio log_nparts
    ## 1  2.792307   0.7376859    0.9161214     0.4518028         0.443713   7.914983
    ##   log_nsamples log150_nparts prop_found found_all
    ## 1     7.641084      1.579637  0.7604091     FALSE

![](95_interval_portal_files/figure-gfm/load%20one%20site-1.png)<!-- -->![](95_interval_portal_files/figure-gfm/load%20one%20site-2.png)<!-- -->

    ## Warning: Removed 1 rows containing non-finite values (stat_density).

![](95_interval_portal_files/figure-gfm/load%20one%20site-3.png)<!-- -->
