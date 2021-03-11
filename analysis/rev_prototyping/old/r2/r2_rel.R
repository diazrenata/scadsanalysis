
#' Compare r2 over whole dataset
#'
#' @param fs_samples_df fs draws
#' @param ncomps comparisons per focal
#'
#' @return comparisons for all draws
#' @export
#'
#' @importFrom dplyr bind_rows
compare_r2_fs <- function(fs_samples_df, ncomps = 500) {

  r2_comparison <- lapply(unique(fs_samples_df$sim), FUN = compare_r2, fs_df = fs_samples_df, ncomps = ncomps) %>%
    dplyr::bind_rows()

  return(r2_comparison)
}

#' Compare r2 of two sims
#'
#' @param focal_sim index of sim
#' @param fs_df samples from FS
#' @param ncomps how many comparisons
#'
#' @return r2 of focal sim vs ncomparisons sims from fs_df
#' @export
#'
#' @importFrom dplyr filter group_by summarize
compare_r2 <- function(focal_sim, fs_df, ncomps = 100, return_summary = T) {

  fs_df$sim_char = as.character(fs_df$sim)

  if(focal_sim != -99) {
    fs_df <- dplyr::filter(fs_df, sim > 0)
  }

  nsims <- unique(fs_df$sim_char)[ which(unique(fs_df$sim_char) != as.character(focal_sim))]

  if(length(nsims) == 0) {
    return(data.frame(focal_sim = focal_sim, mean_r2 = NA, n_r2_comparisons = NA))
  }

  focal_sad <- dplyr::filter(fs_df, sim == focal_sim)

  compare_sims <- sample(nsims, size = min(length(nsims), ncomps), replace =F)

  compare_sads <- dplyr::filter(fs_df, sim_char %in% compare_sims)

  compare_props <- compare_sads %>%
    dplyr::group_by(sim) %>%
    dplyr::summarize(r2 = fs_r2(t(data.frame(abund, focal_sad$abund)))) %>%
    dplyr::ungroup()

  if(return_summary){
    return(data.frame(focal_sim = focal_sim, mean_r2 = mean(compare_props$r2, na.rm = T), n_r2_comparisons = nrow(compare_props)))
  } else {
      return(compare_props)
    }
}
