#' Build net of S and N combinations to sample
#'
#' Covering a range of values present in the datasets
#'
#' @return table of s0, n0, "site name"
#' @export
#'
#' @importFrom dplyr rename filter mutate row_number
build_net <- function() {

  net_s0 <- floor(exp(seq(.5, log(200), by = .3))) %>%
    unique()

  net_n0 <- 1+ floor(exp(seq(.5, 10, by = .75))) %>%
    unique()

  net <- expand.grid(net_s0, net_n0) %>%
    dplyr::rename(rank = Var1, abund = Var2) %>%
    dplyr::filter(abund > rank,
           rank > 1) %>%
    dplyr::mutate(site = paste0("s_", rank, "_n_", abund),
                  singletons = FALSE,
                  dat = "net")
}
