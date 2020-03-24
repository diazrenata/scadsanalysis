ROV report
================

Datasets in S and N space
=========================

Here is where our communities fall in S and N space:

![](rov_files/figure-markdown_github/datasets%20in%20s%20and%20n%20space-1.png)

Here is how that translates into the size of the feasible set:

![](rov_files/figure-markdown_github/size%20of%20fs-1.png)![](rov_files/figure-markdown_github/size%20of%20fs-2.png)

Exploring ways we might bin nparts:

![](rov_files/figure-markdown_github/nparts%20distribution-1.png)![](rov_files/figure-markdown_github/nparts%20distribution-2.png)![](rov_files/figure-markdown_github/nparts%20distribution-3.png)

And various metrics of the ROV of the feasible set:

![](rov_files/figure-markdown_github/fs%20rov-1.png)

Here is how ROV corresponds to nparts:

    ## Warning: Removed 24312 rows containing missing values (geom_point).

![](rov_files/figure-markdown_github/rov%20lognparts-1.png)![](rov_files/figure-markdown_github/rov%20lognparts-2.png)![](rov_files/figure-markdown_github/rov%20lognparts-3.png)![](rov_files/figure-markdown_github/rov%20lognparts-4.png)![](rov_files/figure-markdown_github/rov%20lognparts-5.png)

Gentry behaves somewhat strangely in these plots because it has the high proportion of low N/S communities; for these communities, all elements of the FS are squished into being highly even.

![](rov_files/figure-markdown_github/binned%20nparts%20ROV-1.png)![](rov_files/figure-markdown_github/binned%20nparts%20ROV-2.png)![](rov_files/figure-markdown_github/binned%20nparts%20ROV-3.png)![](rov_files/figure-markdown_github/binned%20nparts%20ROV-4.png)![](rov_files/figure-markdown_github/binned%20nparts%20ROV-5.png)

![](rov_files/figure-markdown_github/qbinned%20nparts%20ROV-1.png)![](rov_files/figure-markdown_github/qbinned%20nparts%20ROV-2.png)![](rov_files/figure-markdown_github/qbinned%20nparts%20ROV-3.png)![](rov_files/figure-markdown_github/qbinned%20nparts%20ROV-4.png)

Remove low N/S:

![](rov_files/figure-markdown_github/qbinned%20nparts%20ROV%20high%20n-1.png)![](rov_files/figure-markdown_github/qbinned%20nparts%20ROV%20high%20n-2.png)![](rov_files/figure-markdown_github/qbinned%20nparts%20ROV%20high%20n-3.png)![](rov_files/figure-markdown_github/qbinned%20nparts%20ROV%20high%20n-4.png)

Percentile distributions
------------------------

Overall:

![](rov_files/figure-markdown_github/percentiles%20overall-1.png)![](rov_files/figure-markdown_github/percentiles%20overall-2.png)

Binned:

![](rov_files/figure-markdown_github/binned%20percentiles-1.png)![](rov_files/figure-markdown_github/binned%20percentiles-2.png)

Binned by quantile:

![](rov_files/figure-markdown_github/qbinned%20percentiles-1.png)![](rov_files/figure-markdown_github/qbinned%20percentiles-2.png)

OK, these visualiations are pretty hard with this dataset (not very many small communities). Try after adding FIA?

Against ROV metrics:

![](rov_files/figure-markdown_github/percentile%20v%20rov-1.png)

![](rov_files/figure-markdown_github/bin%20rov-1.png)![](rov_files/figure-markdown_github/bin%20rov-2.png)![](rov_files/figure-markdown_github/bin%20rov-3.png)![](rov_files/figure-markdown_github/bin%20rov-4.png)

    ## [1] 0.06803225

    ## [1] 0.140589

    ## # A tibble: 10 x 3
    ##    qbinned_lognparts high_skew low_simpson
    ##    <ord>                 <dbl>       <dbl>
    ##  1 3.4                 0.00215      0.147 
    ##  2 4.5                 0.00597      0.0871
    ##  3 5.4                 0.0211       0.0882
    ##  4 6.1                 0.0318       0.0731
    ##  5 6.8                 0.0495       0.0769
    ##  6 7.6                 0.0522       0.0874
    ##  7 8.6                 0.0642       0.0948
    ##  8 10.4                0.103        0.146 
    ##  9 39.1                0.174        0.274 
    ## 10 320                 0.175        0.334

    ## [1] 0.03255677

    ## [1] 0.09306989

    ## [1] 0.1497893

    ## [1] 0.2501019

    ## [1] 0.09378085

    ## [1] 0.1873972

![](rov_files/figure-markdown_github/ggplot%20rov%20v%20percentile-1.png) \#\#\# Rarefaction ![](rov_files/figure-markdown_github/rarefaction%20percentiles%20overall-1.png)![](rov_files/figure-markdown_github/rarefaction%20percentiles%20overall-2.png)

![](rov_files/figure-markdown_github/rarefaction%20percentiles%20binned%20by%20nparts-1.png)![](rov_files/figure-markdown_github/rarefaction%20percentiles%20binned%20by%20nparts-2.png)

![](rov_files/figure-markdown_github/rarefaction%20change-1.png)![](rov_files/figure-markdown_github/rarefaction%20change-2.png)![](rov_files/figure-markdown_github/rarefaction%20change-3.png)![](rov_files/figure-markdown_github/rarefaction%20change-4.png)![](rov_files/figure-markdown_github/rarefaction%20change-5.png)

    ## [1] 0.1050687

    ## [1] 0.2021342

    ## # A tibble: 10 x 3
    ##    qbinned_lognparts high_skew low_simpson
    ##    <ord>                 <dbl>       <dbl>
    ##  1 3.7                  0.0103      0.141 
    ##  2 4.9                  0.0429      0.0983
    ##  3 5.7                  0.0476      0.102 
    ##  4 6.5                  0.0622      0.105 
    ##  5 7.3                  0.0932      0.150 
    ##  6 8.1                  0.108       0.163 
    ##  7 9.2                  0.104       0.181 
    ##  8 11.2                 0.158       0.270 
    ##  9 40.1                 0.228       0.404 
    ## 10 331.5                0.195       0.407
