% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metrics.R
\name{add_dis}
\alias{add_dis}
\title{Summarize sampled and observed SADs}
\usage{
add_dis(fs_samples_df, sim_props_off = NULL, props_comparison = NULL)
}
\arguments{
\item{fs_samples_df}{df of all samples - observed and sampled - with column for abundance, \emph{for a single site}. Output of \code{sample_fs} or \code{sample_fs_wrapper}}

\item{sim_props_off}{Not used but kept in function definition so as not to invalidate drake targets}

\item{props_comparison}{result of running compare_props_off on fs_samples_df.}
}
\value{
data frame with summary statistic values and percentile scores for each metric, for every sampled and observed SAD
}
\description{
Given a dataframe of sampled and observed SAD vectors,
\itemize{
\item summarizes each vector with skewness, Shannon diversity, and Simpson evenness
\item calculates the percentile rank for each diversity metric for every sample. The observed percentile rank is calculated against the distribution of sampled values for each metric.
}
}
