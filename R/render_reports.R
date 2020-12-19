#' #' Render a report
#' #'
#' #' @param report_path file path for report
#' #' @param dependencies dependencies for drake
#' #' @param is_template is this a template?
#' #' @param dat_name if this is a template, need to pass the dataset name to customize the report
#' #'
#' #' @return nothing
#' #' @export
#' #' @importFrom rmarkdown render
#' #'
#' render_report <- function(report_path, dependencies = list(), is_template = FALSE, dat_name = NULL) {
#'   rm(dependencies)
#'   if(!is_template) {
#'     rmarkdown::render(report_path, output_format = "github_document")
#'   } else {
#'     if(is.null(dat_name)) {
#'       return("Need to provide dat name")
#'     } else {
#'       rmarkdown::render(report_path, output_format = "github_document",
#'                         output_file = paste0(dat_name, "_report.md"), params = list(dataset_name = dat_name))
#'     }
#'   }
#' }
