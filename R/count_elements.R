#' Count number of elements in the feasible set
#'
#' Finds the number of unique elements in a feasible set given S and N
#'
#' @param s S0
#' @param n N0
#' @param p_table Optionally pass the p table (required by `feasiblesads`) so you don't have to regenerate it
#'
#' @return number of elements in the FS
#' @export
#'
#' @importFrom feasiblesads fill_ps fill_ks
#' @importFrom gmp sum.bigz as.bigz
count_elements <- function(s, n, p_table = NULL) {

  if(s == 1) {
    return("1")
  }

  if(is.null(p_table)) {
    p_table <- feasiblesads::fill_ps(s, n, F)
  } else {
    p_table <- p_table[1:s,0:n+1]
  }

  k_table <- feasiblesads::fill_ks(s, n)


  ns = 1:k_table[s, n+1] # this differs from `feasiblesads` because 0 is NOT an option

  n_parts = p_table[s - 1,
                    n - (s * ns) + 1]
  total_parts = gmp::sum.bigz(gmp::as.bigz(n_parts))

  return((total_parts))
}
