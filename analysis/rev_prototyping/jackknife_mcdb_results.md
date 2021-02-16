Jackknife
================
Renata Diaz
2021-02-15

## actual

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->

    ## Joining, by = c("dat", "site_source")

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-3-3.png)<!-- -->

    ## [1] 0.1726784

    ## [1] 0.1189563

    ## [1] 0.4098235

    ## [1] 0.2977744

    ## [1] 0.3737529

    ## [1] 0.2547966

<div class="kable-table">

| even\_change         |   n |
| :------------------- | --: |
| actualFALSE\_jkFALSE | 816 |
| actualTRUE\_jkFALSE  | 155 |
| actualTRUE\_jkTRUE   | 332 |

</div>

![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-3-4.png)<!-- -->![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-3-5.png)<!-- -->![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-3-6.png)<!-- -->![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-3-7.png)<!-- -->![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-3-8.png)<!-- -->

So for these 50 communities, resampling does not change the outcome for
the 6-10 largest communities. It changes it for a handful of smaller
communities. RMD suspects this is because the jacknifed samples, with
60% as many individuals, count as “small” in a way that the observed
sample does not. However, it could also be that in drawing a smaller
number of individuals you have more error, as in you aren’t doing as
good a job replicating the larger distribution?

    ## Joining, by = "site"

![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->![](jackknife_mcdb_results_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

I want to wait until I get results back from a larger sample of the
MCDB. At the moment it seems pretty cool that a) it doesn’t change much
for high N communities but b) it super does for the small ones.

One interesting question is, whether it’s the **tininess of the new
sample** doing a poor job replicating the original shape, or whether
it’s the tininess of the new sample getting down to a fuzzy FS space.
I’m not sure if you can take these apart, but it’s fun to think about.
