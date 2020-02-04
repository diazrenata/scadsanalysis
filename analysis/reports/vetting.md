Shaking out the idiosyncracies
================

Number of draws in feasible set
-------------------------------

For low values of S and N, we expect to get considerably fewer than 2500 unique draws from the feasible set. Small feasible sets present a couple of problems for this percentile approach:

-   In the limit of only one or a handful of possible forms, it's absurd to try and draw meaning from the form of the SAD. In a community of 10 species and 11 individuals, the important thing to understand is not why the SAD is 2-1-1-1-1-1 but why the community has 10 species and 11 individuals.
-   Even when there are a few more possible forms, if there isn't much variation, the %ile statistic will be pretty coarse.
-   I expect the central tendency/dominance by a particular *form* to be weaker when there are fewer possible forms, period.
-   This one isn't necessarily a bug (and it applies to other aspects of S x N space), but I expect combinations of S and N that produce samples to have unusual feasible sets compared to most of S and N space. These are going to be communities with either very low S and N, period, or *very few* individuals relative to S. They will be forced to be more even than ones with more individuals.

It's not clear a priori what actual values of S and N will push us into small-community problems. Again, beyond the really small communities, it really depends on the ratio. Early on I just filtered out anything that gave fewer than 2000 unique draws. This has the advantage that we only end up comparing %ile values with reasonably comparable precision, but it might artificially exclude an important region on S\*N space.

![](vetting_files/figure-markdown_github/draws%20v%20sn%20plots-1.png)![](vetting_files/figure-markdown_github/draws%20v%20sn%20plots-2.png)

In these plots, the grey region is nsamples &gt;= 2000. It looks like removing communities with nsamples &lt; 2000 is basically filtering out N &lt; about 100-150. For more nuance we could dip down into lower n for intermediate S (S between 5 and 50), and still be getting pretty good sampling?

Leaving it be for now.

Percentile value vs. range of variation of FS
---------------------------------------------

This is really hard to get traction on. S and N affect everything.

![](vetting_files/figure-markdown_github/percent%20v%20rov-1.png)![](vetting_files/figure-markdown_github/percent%20v%20rov-2.png)

Where the datasets fall
-----------------------

![](vetting_files/figure-markdown_github/dataset%20space-1.png)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](vetting_files/figure-markdown_github/dataset%20space-2.png)

The datasets overlap but do occupy broadly different regions of S\*N space.

FIA, dramatically more than any other dataset, struggles to get even 2000 samples.

Overall percentile results
--------------------------

![](vetting_files/figure-markdown_github/overall-1.png)![](vetting_files/figure-markdown_github/overall-2.png)

Effect of singletons

![](vetting_files/figure-markdown_github/singletons%20overall-1.png)![](vetting_files/figure-markdown_github/singletons%20overall-2.png)

Adding singletons makes skewness more skewed and simpson less even.

Broken out by dataset
---------------------

![](vetting_files/figure-markdown_github/dataset-1.png)![](vetting_files/figure-markdown_github/dataset-2.png)

Effect of singletons

![](vetting_files/figure-markdown_github/singletons%20dataset-1.png)![](vetting_files/figure-markdown_github/singletons%20dataset-2.png)

MACD
====

Nsamples

![](vetting_files/figure-markdown_github/macd%20overall-1.png)![](vetting_files/figure-markdown_github/macd%20overall-2.png)![](vetting_files/figure-markdown_github/macd%20overall-3.png)

By treatment - overall

![](vetting_files/figure-markdown_github/macd%20trtmt%20overall-1.png)![](vetting_files/figure-markdown_github/macd%20trtmt%20overall-2.png)

\*\* I AM REALLY NOT CONFIDENT IN THE DATA HANDLING HERE, NEED TO REVISIT WHEN SHARPER \*\*

    ## Warning: Removed 4 rows containing missing values (geom_point).

![](vetting_files/figure-markdown_github/macd%20ctrlcomp-1.png)

    ## Warning: Removed 4 rows containing missing values (geom_point).

![](vetting_files/figure-markdown_github/macd%20ctrlcomp-2.png)
