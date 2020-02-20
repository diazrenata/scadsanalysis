Synthesis report
================

Datasets in S and N space
=========================

Here is where our communities fall in S and N space:

![](synthesis_files/figure-markdown_github/datasets%20in%20s%20and%20n%20space-1.png)

Here is how that translates into the size of the feasible set:

![](synthesis_files/figure-markdown_github/size%20of%20fs-1.png)

Note that the color scale is log transformed, so the largest communities have e^331.5401042, or 9.683621310^{143}, elements in the feasible set!

Here is how the size of the feasible set maps on to N/S. It increases with n0/s0 and s0.

![](synthesis_files/figure-markdown_github/nparts%20vs%20avgn-1.png)

Number of samples
=================

Here is how many samples we are achieving:

![](synthesis_files/figure-markdown_github/nsamples-1.png)

Only in small communities do we get appreciably fewer than 4000 samples.

Here is how the number of samples we're getting compares to the size of the feasible set:

![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-1.png)![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-2.png)![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-3.png)![](synthesis_files/figure-markdown_github/nsamples%20vs%20nparts-4.png)

For about 30.3874915% of sites, we found all the elements of the FS. The *vast majority* of this is FIA - here is what happens if we take out FIA:

![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-1.png)![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-2.png)![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-3.png)![](synthesis_files/figure-markdown_github/prop%20found%20no%20fia-4.png)

Without FIA, we find all the samples about 10.1262916% of the time.

Distribution of percentile values
=================================

Skewness
--------

Here is the overall distribution of skewness, and if we split based on whether we found all the samples: ![](synthesis_files/figure-markdown_github/skew%20percentiles-1.png)![](synthesis_files/figure-markdown_github/skew%20percentiles-2.png)

When we found all the samples, the percentiles are more evenly distributed. I do not read much into the spike at 0 for those communities, because skewness is bizarre for very small communities.

Here is how skewness maps with S and N: ![](synthesis_files/figure-markdown_github/skew%20v%20s%20and%20n-1.png)

The very low skewness values are down in the very small and very weird communities. There may be variation along S and N elsewhere, but it is hard to parse.

Simpson
-------

![](synthesis_files/figure-markdown_github/simpson%20percentiles-1.png)![](synthesis_files/figure-markdown_github/simpson%20percentiles-2.png)![](synthesis_files/figure-markdown_github/simpson%20percentiles-3.png)![](synthesis_files/figure-markdown_github/simpson%20percentiles-4.png)![](synthesis_files/figure-markdown_github/simpson%20percentiles-5.png)
