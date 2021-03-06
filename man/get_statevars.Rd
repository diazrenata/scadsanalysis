% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_handling.R
\name{get_statevars}
\alias{get_statevars}
\title{Retrieve statevars}
\usage{
get_statevars(a_dataset)
}
\arguments{
\item{a_dataset}{with columns site, dat, singletons, sim, source, abund}
}
\value{
the dataset summarzied to s0 and n0 for each site
}
\description{
Calculate the total abundance (N0) and species richness (S0) for each of the sites in a dataset
}
