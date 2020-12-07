Figures and results for main manuscript
================
Renata Diaz
2020-12-07

# Final dataset in S and N space

![](manuscript_main_files/figure-gfm/final%20dataset%20s%20and%20n%20space-1.png)<!-- -->![](manuscript_main_files/figure-gfm/final%20dataset%20s%20and%20n%20space-2.png)<!-- -->

# Illustrations of 95% interval

To show the 95% interval, we need to load the distribution of shape
metric values from the samples from the feasible set for a few
communities. See rov\_metric.md.

# Skewness and evenness histograms by dataset

![](manuscript_main_files/figure-gfm/first%20hists-1.png)<!-- -->![](manuscript_main_files/figure-gfm/first%20hists-2.png)<!-- -->

# Proportion of sites with highly skewed or uneven SADs

    ## `summarise()` ungrouping output (override with `.groups` argument)
    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## Joining, by = "Dataset"

<div class="kable-table">

| Dataset                       | Proportion of communities with skewness above 95th percentile | Number of communities analyzed for skewness | Proportion of communities with evenness below 5th percentile | Number of communities analyzed for evenness |
| :---------------------------- | ------------------------------------------------------------: | ------------------------------------------: | -----------------------------------------------------------: | ------------------------------------------: |
| Breeding Bird Survey          |                                                     0.1301839 |                                        2773 |                                                    0.2596466 |                                        2773 |
| Forest Inventory and Analysis |                                                     0.0542077 |                                       18300 |                                                    0.0939657 |                                       18113 |
| Gentry                        |                                                     0.1883408 |                                         223 |                                                    0.1517857 |                                         224 |
| Mammal Community DB           |                                                     0.1582868 |                                         537 |                                                    0.3542435 |                                         542 |
| Miscellaneous Abundance DB    |                                                     0.3455285 |                                         492 |                                                    0.5959184 |                                         490 |

</div>

    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## Joining, by = "Dataset"

<div class="kable-table">

| Dataset                       | Proportion of communities with skewness above 95th percentile | Number of communities analyzed for skewness | Proportion of communities with evenness below 5th percentile | Number of communities analyzed for evenness |
| :---------------------------- | ------------------------------------------------------------: | ------------------------------------------: | -----------------------------------------------------------: | ------------------------------------------: |
| Forest Inventory and Analysis |                                                     0.0542077 |                                       18300 |                                                    0.0939657 |                                       18113 |
| Other datasets                |                                                     0.1634783 |                                        4025 |                                                    0.3072723 |                                        4029 |

</div>

# 95 intervals by size of FS

    ## Warning: Removed 30 rows containing missing values (geom_point).

![](manuscript_main_files/figure-gfm/95%20intervals-1.png)<!-- -->

    ## Warning: Removed 30 rows containing missing values (geom_point).

![](manuscript_main_files/figure-gfm/95%20intervals-2.png)<!-- -->

# 95 intervals by dataset

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](manuscript_main_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](manuscript_main_files/figure-gfm/unnamed-chunk-1-2.png)<!-- -->
