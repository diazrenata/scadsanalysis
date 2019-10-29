#' Render a report
#'
#' @param report_path file path for report
#' @param dependencies dependencies for drake
#'
#' @return nothing
#' @export
#' @importFrom rmarkdown render
render_report <- function(report_path, dependencies = list()) {
  rm(dependencies)
  rmarkdown::render(report_path, output_format = "github_document")
}
