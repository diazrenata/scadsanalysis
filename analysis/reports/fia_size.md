Synthesis report
================

# Datasets in S and N space

Here is where our communities fall in S and N space:

![](fia_size_files/figure-gfm/datasets%20in%20s%20and%20n%20space-1.png)<!-- -->

Here is how that translates into the size of the feasible set:

![](fia_size_files/figure-gfm/size%20of%20fs-1.png)<!-- -->![](fia_size_files/figure-gfm/size%20of%20fs-2.png)<!-- -->![](fia_size_files/figure-gfm/size%20of%20fs-3.png)<!-- -->

## All sites all sizes

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/percentiles%20overall-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/percentiles%20overall-2.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/percentiles%20overall-3.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/percentiles%20overall-4.png)<!-- -->

## Resrict to sizes found in FIA

![](fia_size_files/figure-gfm/fia%20limits-1.png)<!-- -->![](fia_size_files/figure-gfm/fia%20limits-2.png)<!-- -->

    ## [1] 0.965004

    ## [1] 0.9653369

96.5% of the datasets with state variables comparable to the FIA ranges
are FIA.

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/fia%20sized%20hists-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/fia%20sized%20hists-2.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/fia%20sized%20hists-3.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/fia%20sized%20hists-4.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/fia%20sized%20hists-5.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/fia%20sized%20hists-6.png)<!-- -->

![](fia_size_files/figure-gfm/on%20map-1.png)<!-- -->![](fia_size_files/figure-gfm/on%20map-2.png)<!-- -->

Does skew behave differently if n0 \<0 33.115452? Just from looking at
the map.

    ## # A tibble: 2 x 2
    ##   small_n prop_fia
    ##   <lgl>      <dbl>
    ## 1 FALSE      0.957
    ## 2 TRUE       0.972

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/skew%20small%20n-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/skew%20small%20n-2.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/skew%20small%20n-3.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/skew%20small%20n-4.png)<!-- -->

# simpson

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/simpson-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/simpson-2.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/simpson-3.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/simpson-4.png)<!-- -->

# Remove small N from all (not just fia sized)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/full-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/full-2.png)<!-- -->

# Remove fia sized from all

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/remove%20fia%20sized-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/remove%20fia%20sized-2.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/remove%20fia%20sized-3.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](fia_size_files/figure-gfm/remove%20fia%20sized-4.png)<!-- -->
