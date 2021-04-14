#' Add singletons
#'
#' Modifies an SAD to add rare species that may have been missed during sampling. Takes the difference between the number of species estimated by the bias-corrected Chao and ACE estimators (as implemented in vegan::estimateR) and the observed number of species. Adds the average of these two differences to the observed dataframe, with each added species getting one individual each. `use_max` is an option to use a high estimate (estimated mean + estimated standard error) from the estimators before calculating the mean difference. Returns the original SAD with added records for the estimated rare species.
#'
#' @param dat dataframe with columns `rank`, `abund`, `site`, `dat`, `singletons`, `sim`, and `source`. This is the format you will get if you use `load_dataset` and filter to a single site
#' @param use_max use estimated richness + standard error? Defaults F, but T is used in pipelines.
#'
#' @return dataframe with additional records for estimated rare species
#' @export
#'
#' @importFrom dplyr select bind_rows mutate arrange row_number group_by n summarise filter
#' @importFrom vegan estimateR
add_singletons <- function(dat, use_max =F) {
  freq = dat %>%
    dplyr::select(abund) %>%
    as.matrix() %>%
    t()

  # Observed richness and total abundance
  s0 <- ncol(freq)
  n0 <- sum(freq)


  est <- vegan::estimateR(freq)

  # Calculate differences between estimates and observed richness
  chao_est <- est[2] - s0
  ace_est <- est[4] - s0

  # Optioanlly use the high-end estimate for the estimated differences (estimate + se of estimate)
  if(use_max) {
    chao_est <- chao_est + est[3]
    ace_est <- ace_est + est[5]

    if(is.nan(ace_est)) {
      ace_est <- est[4]
    }
  }

  ests <- data.frame(est = c(chao_est, ace_est)) %>%
    dplyr::filter(!is.na(est),
           !is.nan(est),
           !is.infinite(est),
           est >= 0)

  if(nrow(ests) == 0) {
    return(NA)
  }

  # Choose how many species to add: mean of the estimates, rounded up to nearest integer
  est_nspp <- ceiling(mean(ests$est))

  # If estimates do not add species, you can return the original dataframe
  if(est_nspp == 0) {
    dat <- dat %>%
      dplyr::mutate(singletons = TRUE)
    return(dat)
  }

  # Otherwise add records for estimated missing species
  newdat <- data.frame(
    abund = rep(1, times = est_nspp)
  )

  dat <- dat %>%
    dplyr::select(-rank) %>%
    dplyr::bind_rows(newdat) %>%
    dplyr::mutate(
      sim = sim[1],
      source = source[1],
      site = site[1],
      dat = dat[1]
    ) %>%
    dplyr::arrange(abund) %>%
    dplyr::mutate(
      rank = dplyr::row_number(),
      singletons = TRUE
    )

  return(dat)

}
