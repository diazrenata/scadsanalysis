#' Sample the feasible set
#'
#' @param dataset SAD df to base on
#' @param nsamples nb samples
#' @param p_table p table
#'
#' @return long dataframe of sim, rank, and abundance
#' @export
#'
#' @importFrom dplyr mutate group_by arrange ungroup row_number bind_rows
#' @importFrom tidyr gather
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
    tidyr::gather(key = "sim", value = "abund") %>%
    dplyr::mutate(sim = as.integer(substr(sim, 2, nchar(sim)))) %>%
    dplyr::group_by(sim) %>%
    dplyr::arrange(abund) %>%
    dplyr::mutate(rank = dplyr::row_number()) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(source = "sampled",
                  dat = dataset$dat[1],
                  site = dataset$site[1],
                  singletons = dataset$singletons[1]) %>%
    dplyr::bind_rows(dataset)

  return(fs_samples)

}

#' Sample fs wrapper
#'
#' @param dataset Full dataset
#' @param site_name Which site within the dataset
#' @param singletonsyn Singletons?
#' @param n_samples nb samples
#' @param p_table P table to pass
#'
#' @return df of samples from fs
#' @export
#'
#' @importFrom dplyr filter
sample_fs_wrapper = function(dataset, site_name, singletonsyn, n_samples, p_table = NULL) {
  dataset <- dataset %>%
    dplyr::filter(site == site_name,
                  singletons == singletonsyn)

  return(sample_fs(dataset, nsamples = n_samples, p_table = p_table))
}
