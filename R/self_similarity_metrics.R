#' KL Divergence of two fs
#'
#' @param two_fs two fs
#' @param log log units? idk if htis matters
#'
#' @return kl div
#' @export
#'
#' @importFrom entropy KL.empirical
fs_div <- function(two_fs, log = F) {
  two_fs <- as.matrix(two_fs)

  if(log) {
    two_fs <- log(two_fs)
  }

  entropy::KL.empirical(two_fs[1,], two_fs[2,])

}

#' R2 for FS
#'
#' R2 as calculated in White et al (2012) and others (I beleive macroecotools)
#'
#' @param two_fs wide dataframe or matrix: 2 rows, nspp columns
#' @param log use log or no? default F
#'
#' @return r2
#' @export
#'
fs_r2 <- function(two_fs, log = F) {
  two_fs <- as.matrix(two_fs)

  focal <- two_fs[1,]
  compare <- two_fs[2,]

  if(log) {

    focal <- log(focal)
    compare <- log(compare)
  }

  focal_mean <- mean(focal)

  numer <- sum((focal - compare) ^ 2)
  denom <- sum((focal - focal_mean) ^ 2)
  1 - (numer/denom)
}

#' Proportion off
#'
#' Prop of individuals allocated differently.
#'
#' @param two_fs wide dataframe or matrix: 2 rows, nspp columns
#'
#' @return prop diff
#' @export
#'
proportion_off <- function(two_fs) {
  two_fs <- as.matrix(two_fs)

  abs_diff <- sum(abs(two_fs[1, ] - two_fs[2, ])) / 2

  abs_diff / sum(two_fs[1, ])

}

#' CD (R2) from lm
#'
#' @param two_fs wide dataframe or matrix: 2 rows, nspp columns
#'
#' @return cd (R2) from lm()
#' @export
#'
fs_cd <- function(two_fs) {
  two_fs <- as.matrix(two_fs)
  fs_lm <- lm(two_fs[1, ]  ~ two_fs[2, ])
  return( summary(fs_lm)$r.squared )
}

#' Distance metrics sampler
#'
#' Randomly draw two elements from FS bank; compute various distance comparisons and return summary.
#'
#' @param fs_set df of samples from FS
#'
#' @return df with cols for dist metrics, sim, s0, n0
#' @export
#' @importFrom dplyr filter select
#' @importFrom tidyr pivot_wider
#'
fs_diff_sampler <- function(fs_set) {
  if(length(unique(fs_set$sim)) < 2) {
    return(data.frame(
      sim1 = NA,
      sim2 = NA,
      r2 = NA,
      r2_log = NA,
      cd = NA,
      prop_off = NA,
      div = NA,
      s0 = max(fs_set$rank),
      n0 = sum(filter(fs_set, sim == unique(fs_set$sim)[1])$abund),
      nparts = fs_set$nparts[1],
      stringsAsFactors = F
    ))
  }

  pair <- sample((unique(fs_set$sim)), size = 2, replace = F)

  two_fs <- dplyr::filter(fs_set, sim %in% pair) %>%
    dplyr::select(abund, sim, rank) %>%
    tidyr::pivot_wider(names_from = rank, values_from = abund) %>%
    dplyr::select(-sim)

  if(pair[1] > pair[2]) {
    two_fs <- two_fs[c(2, 1), ]
  }

  r2 <- fs_r2(two_fs)
  r2_log <- fs_r2(two_fs, log = T)
  cd <- fs_cd(two_fs)
  prop_off <- proportion_off(two_fs)
  div <- fs_div(two_fs)
  return(data.frame(
    sim1 = pair[1],
    sim2 = pair[2],
    r2 = r2,
    r2_log = r2_log,
    cd = cd,
    prop_off = prop_off,
    div = div,
    s0 = ncol(two_fs),
    n0 = sum(two_fs[1, ]),
    nparts = fs_set$nparts[1],
    stringsAsFactors = F
  ))
}

#' Repeatedly sample fs set
#'
#' @param fs_set bank of fs samples
#' @param ndraws how many reps
#'
#' @return df of comparisons
#' @export
#' @importFrom dplyr bind_rows distinct_at
rep_diff_sampler <- function(fs_set, ndraws) {
  diff_df <- dplyr::bind_rows(replicate(n = ndraws, expr = fs_diff_sampler(fs_set), simplify = F))

  diff_df <- diff_df %>%
    dplyr::distinct_at(c("s0", "n0", "sim1", "sim2", "r2", "r2_log", "cd", "prop_off", "div", "nparts"))

  return(diff_df)
}
