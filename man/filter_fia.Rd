% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_handling.R
\name{filter_fia}
\alias{filter_fia}
\title{Filter FIA data}
\usage{
filter_fia(
  storage_path = here::here("working-data", "abund_data"),
  save = TRUE
)
}
\arguments{
\item{storage_path}{where to put it}

\item{save}{save it?}
}
\value{
nothing
}
\description{
Following White et al 2012, filtering FIA data to sites with >= 10 species. This brings it from 103343 sites to 10355.
}
