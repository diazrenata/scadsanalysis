% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metrics.R
\name{pull_di}
\alias{pull_di}
\title{Summarize observed vs. samples}
\usage{
pull_di(di_df)
}
\arguments{
\item{di_df}{result of di_wrapper}
}
\value{
di_df for observed + n samples
}
\description{
Extracts the percentile rank for the shape metric value for the observed SAD relative to the samples from its FS, as well as summary information about the distribution of shape metric values from the samples from the FS:
}
\details{
\itemize{
\item Number of unique samples found from the FS
\item Range, mean, standard deviation, min, max, .25, .95, and .975 quantiles for the distributions of skewness and evenness from the samples
\item Ratio of the width of two-tailed and one-tailed 95\% intervals to the full range for both skewness and evenness. For skewness, the one-tailed interval is from 0-.95; for evenness, the one-tailed interval is from .05-1. The two-tailed intervals are from .025 to .975.
}
}
