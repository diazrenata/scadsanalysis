#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Results"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("minparts",
                        "Minimum number of parts:",
                        min = 0,
                        max = 17,
                        value = 4.6,
                        step = .001),
            sliderInput("maxparts",
                        "Maximum number of parts:",
                        min = 0,
                        max = 17,
                        value = 6.9,
                        step = .001)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tableOutput("sizeRange"),
            plotOutput("snPlot", width = 400, height = 200),
            plotOutput("windowPlot", width = 400, height = 200),
            plotOutput("skewPlot", width = 400, height = 200),
            tableOutput("skewResults"),
            plotOutput("evenPlot", width = 400, height = 200),
            tableOutput("evenResults")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    all_di <- read.csv(here::here("analysis", "reports", "all_di.csv"), stringsAsFactors = F)

    all_di <- all_di %>%
        mutate(log_nparts = log(gmp:::as.double.bigz(nparts)),
               log_nsamples = log(nsamples),
               log_s0 = log(s0),
               log_n0 = log(n0)) %>%
        filter(n0 > s0,
               !singletons,
               dat %in% c("bbs", "fia_short", "fia_small", "gentry", "mcdb", "misc_abund_short")) %>%
        mutate(dat = ifelse(grepl(dat, pattern = "fia"), "fia", dat),
               dat = ifelse(dat == "misc_abund_short", "misc_abund", dat))


    fia_max_s = max(filter(all_di, dat == "fia")$s0)
    fia_max_n = max(filter(all_di, dat == "fia")$n0)

    fia = filter(all_di, dat == "fia")

    small_di <- all_di %>%
        filter(s0 <= fia_max_s,
               n0 <= fia_max_n) %>%
        mutate(fia_yn = ifelse(dat == "fia", "fia", "other datasets"),
               right_corner = FALSE)

    for(i in 1:nrow(small_di)) {
        if(small_di$dat[i] != "fia") {
            fia_match_s0 = filter(fia, s0 >= small_di$s0[i])

            max_n0_for_this_s0 = max(fia_match_s0$n0)

            small_di$right_corner[i] = small_di$n0[i] > max_n0_for_this_s0

        }
    }


    small_di <- small_di %>%
        filter(!right_corner)


    output$snPlot <- renderPlot({
        this_di <- small_di %>%
            filter(log_nparts > input$minparts,
                   log_nparts < input$maxparts)

        ggplot(small_di, aes(x = (s0), y = (n0))) +
            geom_point() +
            geom_point(data = this_di, color = "blue") +
            theme_bw() +
            facet_wrap(vars(fia_yn))
    })

    output$windowPlot <- renderPlot({

        ggplot(small_di, aes(log_nparts)) +
            geom_histogram(bins = 30) +
            theme_bw() +
            facet_wrap(vars(fia_yn), scales = "free_y") +
            geom_vline(xintercept = c(input$minparts,
                                      input$maxparts), color = "red")
    })



    output$sizeRange <- renderTable({
        data.frame(min_nparts_log = input$minparts,
                   min_nparts = exp(input$minparts),
                   max_nparts_log = input$maxparts,
                   max_nparts = exp(input$maxparts))
    })
    output$skewPlot <- renderPlot({
        this_di <- small_di %>%
            filter(log_nparts > input$minparts,
                   log_nparts < input$maxparts,
                   s0 > 2)

        ggplot(this_di, aes(skew_percentile_excl)) +
            geom_histogram(bins = 100) +
            theme_bw() +
            facet_wrap(vars(fia_yn), scales = "free_y")
    })


    output$evenPlot <- renderPlot({
        this_di <- small_di %>%
            filter(log_nparts > (input$minparts),
                   log_nparts < (input$maxparts))

        ggplot(this_di, aes(simpson_percentile)) +
            geom_histogram(bins = 100) +
            theme_bw() +
            facet_wrap(vars(fia_yn), scales = "free_y")
    })

    output$skewResults <- renderTable({
        small_di %>%
            filter(log_nparts > (input$minparts),
                   log_nparts < (input$maxparts),
                   s0 > 2) %>%
            group_by(fia_yn) %>%
            summarize(prop_skew_high = mean(skew_percentile_excl > 95),
                      nskew_sites = dplyr::n())
    })

    output$evenResults <- renderTable({
        small_di %>%
            filter(log_nparts > (input$minparts),
                   log_nparts < (input$maxparts)) %>%
            group_by(fia_yn) %>%
            summarize(prop_even_low = mean(simpson_percentile < 5),
                      neven_sites = dplyr::n())
    })
}

# Run the application
shinyApp(ui = ui, server = server)
