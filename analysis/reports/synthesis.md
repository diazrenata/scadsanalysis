Synthesis report
================

Datasets in S and N space
=========================

Here is where our communities fall in S and N space:

![](synthesis_files/figure-markdown_github/datasets%20in%20s%20and%20n%20space-1.png)

Here is how that translates into the size of the feasible set:

![](synthesis_files/figure-markdown_github/size%20of%20fs-1.png)

Note that the color scale is log transformed, so the largest communities have e^331.5401042, or 9.683621310^{143}, elements in the feasible set!

Here is how the size of the feasible set maps on to N/S:

![](synthesis_files/figure-markdown_github/nparts%20vs%20avgn-1.png)

Number of samples
=================

Here is how many samples we are achieving:

![](synthesis_files/figure-markdown_github/nsamples-1.png)![](synthesis_files/figure-markdown_github/nsamples-2.png)

Only in the very smallest communities do we get appreciably fewer than 4000 samples.

Here is how the number of samples we're getting compares to the size of the feasible set:

![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-1.png)![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-2.png)

The vertical lines are the 10% and 95% marks, from left to right. When we got relatively few samples (2), we had found 100% of that feasible set. And there's a clear negative relationship between the proportion of the FS that we've found and the number of samples we got, once we start getting about 10% of the feasible set. This makes sense; at that point we have a 1 in 10 chance of drawing one we've already seen. But for almost all cases, we're sampling only a miniscule proportion of the feasible set - median of 0.7252563! - and get no duplicates.

The vastness of the FS poses a limit on our capacity to detect how unlikely a value is. We could conservatively round up: scoring in the 100th percentile, when we had 4000 samples, means a maximum of (1 / 4000 + tiny error) chance of getting that score?

Distribution of percentile values
=================================

Skewness
--------

![](synthesis_files/figure-markdown_github/skew%20percentiles-1.png)![](synthesis_files/figure-markdown_github/skew%20percentiles-2.png)![](synthesis_files/figure-markdown_github/skew%20percentiles-3.png)![](synthesis_files/figure-markdown_github/skew%20percentiles-4.png)![](synthesis_files/figure-markdown_github/skew%20percentiles-5.png)

Simpson
-------

![](synthesis_files/figure-markdown_github/simpson%20percentiles-1.png)![](synthesis_files/figure-markdown_github/simpson%20percentiles-2.png)![](synthesis_files/figure-markdown_github/simpson%20percentiles-3.png)![](synthesis_files/figure-markdown_github/simpson%20percentiles-4.png)![](synthesis_files/figure-markdown_github/simpson%20percentiles-5.png)

Do S and N predict percentile?
