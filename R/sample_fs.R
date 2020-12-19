#' Sample the feasible set
#'
#' Draw samples from the feasible set for an SAD.
#'
#' @param dataset dataframe of the SAD for a single site; the result of load_dataset and then filtering to one community
#' @param nsamples how many samples to draw. If the number of samples approaches the total number of elements in the feasible set, the samples may not all be unique. This function will only return unique samples, and so may not return `nsamples` samples if the feasible set is relatively small.
#' @param p_table p table If provided, passes p table to feasiblesads to avoid re-generating it for every site
#'
#' @return long dataframe of simulated SADs in the same format as `dataset`, *and* the original dataset. Sims are distinguished from the observed via the `source` column (observed or sampled), and individual sims are identified with the `sim` column.
#' @export
#'
#' @importFrom dplyr mutate group_by arrange ungroup row_number bind_rows
#' @importFrom reshape2 melt
#' @importFrom feasiblesads fill_ps sample_fs
sample_fs <- function(dataset, nsamples, p_table = NULL) {

  if(is.null(dataset)) {
    return(NA)
  }

  if(nrow(dataset) == 0) {
    return(NA)
  }

  max_s = max(dataset$rank)
  max_n = sum(dataset$abund)

  if(is.null(p_table)) {
    p_table <- feasiblesads::fill_ps(max_s, max_n, storeyn = F)
  }

  p_table <- p_table[1:max_s, 1:(max_n + 1)]

  fs_samples <- feasiblesads::sample_fs(s = max_s, n = max_n, nsamples = nsamples, p_table = p_table) %>%
    unique() %>%
    t() %>%
    as.data.frame() %>%
    reshape2::melt(variable.name = "sim",
                   value.name = "abund") %>%
    dplyr::mutate(sim = as.character(sim)) %>%
    dplyr::mutate(sim = as.integer(substr(sim, 2, nchar(sim)))) %>%
    dplyr::group_by(sim) %>%
    dplyr::arrange(abund) %>%
    dplyr::mutate(rank = dplyr::row_number()) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(source = "sampled",
                  dat = dataset$dat[1],
                  site = dataset$site[1],
                  singletons = dataset$singletons[1]) %>%
    dplyr::bind_rows(dataset) %>%
    dplyr::mutate(s0 = max_s,
                  n0 = max_n,
                  nparts = as.character(count_elements(max_s, max_n, p_table)))

  return(fs_samples)

}

#' Sample fs wrapper
#'
#' Wrapper to sample the feasible set for a single site within a larger dataset; used to interface between the drake plan and `sample_fs`.
#'
#' @param dataset Full dataset - potentially including numerous sites
#' @param site_name Which site within the dataset
#' @param singletonsyn T/F Whether to use the version that has been adjusted for rarefaction
#' @param n_samples How many samples to draw. See `sample_fs`: if the feasible set is small, you may not necessarily get `n_samples` unique samples. These functions will only return unique samples.
#' @param p_table Optionally, pass the p-table to avoid having to regenerate it
#' @param seed pass a seed for reproducibility
#'
#' @return Output of `sample_fs` for the selected site
#' @export
#'
#' @importFrom dplyr filter
sample_fs_wrapper = function(dataset, site_name, singletonsyn, n_samples, p_table = NULL, seed = NULL) {

  if(is.null(dataset)) {
    return(NA)
  }

  if(nrow(dataset) == 0) {
    return(NA)
  }

  if(!is.null(seed)) {
    set.seed(seed)
  }

  dataset <- dataset %>%
    dplyr::filter(site == site_name,
                  singletons == singletonsyn)

  return(sample_fs(dataset, nsamples = n_samples, p_table = p_table))
}
