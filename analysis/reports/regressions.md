Regressions
================

Filtering to nsamples &gt;= 2000, not singletons.

### Supposed correlates

#### Average abundance (N/S)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](regressions_files/figure-markdown_github/avg%20n-1.png)![](regressions_files/figure-markdown_github/avg%20n-2.png)![](regressions_files/figure-markdown_github/avg%20n-3.png)

![](regressions_files/figure-markdown_github/means%20and%20sds-1.png)![](regressions_files/figure-markdown_github/means%20and%20sds-2.png)![](regressions_files/figure-markdown_github/means%20and%20sds-3.png)![](regressions_files/figure-markdown_github/means%20and%20sds-4.png)![](regressions_files/figure-markdown_github/means%20and%20sds-5.png)![](regressions_files/figure-markdown_github/means%20and%20sds-6.png)

The different datasets are on dramatically different scales of average abundance, although it looks like a lot of that is outliers in misc\_abund.

### Correlation plots

#### Average abundance

![](regressions_files/figure-markdown_github/avg%20n%20vis-1.png)![](regressions_files/figure-markdown_github/avg%20n%20vis-2.png)

#### Mean and sd

![](regressions_files/figure-markdown_github/mean%20sd%20vis-1.png)![](regressions_files/figure-markdown_github/mean%20sd%20vis-2.png)![](regressions_files/figure-markdown_github/mean%20sd%20vis-3.png)![](regressions_files/figure-markdown_github/mean%20sd%20vis-4.png)

### Beta regression

#### Average abundance

    ## 
    ## Call:
    ## betareg(formula = skew_pp ~ avg_n + dat, data = di_summary)
    ## 
    ## Standardized weighted residuals 2:
    ##     Min      1Q  Median      3Q     Max 
    ## -9.4209 -0.6370 -0.1005  0.5073  4.4197 
    ## 
    ## Coefficients (mean model with logit link):
    ##                       Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)          0.4001848  0.0219467  18.234  < 2e-16 ***
    ## avg_n                0.0017673  0.0001802   9.807  < 2e-16 ***
    ## datfia_short        -0.0229506  0.0310126  -0.740   0.4593    
    ## datgentry           -0.1911721  0.0794179  -2.407   0.0161 *  
    ## datmcdb              0.3643957  0.0665708   5.474 4.40e-08 ***
    ## datmisc_abund_short  0.7504063  0.0591304  12.691  < 2e-16 ***
    ## datportal_plants     1.0268300  0.1518021   6.764 1.34e-11 ***
    ## 
    ## Phi coefficients (precision model with identity link):
    ##       Estimate Std. Error z value Pr(>|z|)    
    ## (phi)  1.78147    0.02686   66.31   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
    ## 
    ## Type of estimator: ML (maximum likelihood)
    ## Log-likelihood:  1149 on 8 Df
    ## Pseudo R-squared: 0.08807
    ## Number of iterations: 30 (BFGS) + 1 (Fisher scoring)

![](regressions_files/figure-markdown_github/betareg%20avg%20n-1.png)![](regressions_files/figure-markdown_github/betareg%20avg%20n-2.png)![](regressions_files/figure-markdown_github/betareg%20avg%20n-3.png)![](regressions_files/figure-markdown_github/betareg%20avg%20n-4.png)
