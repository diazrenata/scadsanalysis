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
            sliderInput("min_skew_interval",
                        "Minimum 95 interval: skew",
                        min = 0,
                        max = 1,
                        value = .01,
                        step = .001),
            sliderInput("max_skew_interval",
                        "Maximum 95 interval: skew",
                        min = 0,
                        max = 1,
                        value = .99,
                        step = .001),
            sliderInput("min_even_interval",
                        "Minimum 95 interval: even",
                        min = 0,
                        max = 1,
                        value = .01,
                        step = .001),
            sliderInput("max_even_interval",
                        "Maximum 95 interval: even",
                        min = 0,
                        max = 1,
                        value = .99,
                        step = .001)
        ),

        # Show a plot of the generated distribution
        mainPanel(plotOutput("skew_intervalPlot", width = 400, height = 200),
                  plotOutput("skew_intervalHist", width = 400, height = 200),
                  plotOutput("skew_snPlot", width = 400, height = 200),
                  plotOutput("skewPlot", width = 400, height = 200),
                  tableOutput("skewResults"),
                  plotOutput("even_intervalPlot", width = 400, height = 200),
                  plotOutput("even_intervalHist", width = 400, height = 200),

                  plotOutput("even_snPlot", width = 400, height = 200),
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

    output$skew_intervalPlot <- renderPlot({

        skew_di <- filter(all_di, skew_95_ratio_1t > input$min_skew_interval,
                          skew_95_ratio_1t < input$max_skew_interval, s0 >2)

        ggplot(all_di, aes(x = log_nparts, y = skew_95_ratio_1t)) +
            geom_point(color = "grey") +
            theme_bw() +
            geom_point(data = skew_di)
    })
    output$even_intervalPlot <- renderPlot({

        even_di <- filter(all_di, simpson_95_ratio_1t > input$min_even_interval,
                          simpson_95_ratio_1t < input$max_even_interval)

        ggplot(all_di, aes(x = log_nparts, y = simpson_95_ratio_1t)) +
            geom_point(color = "grey") +
            theme_bw() +
            geom_point(data = even_di)
    })
    output$skew_intervalHist <- renderPlot({

        skew_di <- filter(all_di, skew_95_ratio_1t > input$min_skew_interval,
                          skew_95_ratio_1t < input$max_skew_interval, s0 >2)

        ggplot(skew_di, aes(x = skew_95_ratio_1t)) +
            geom_histogram() +
            theme_bw()+
            xlim(0, 1)
    })
    output$even_intervalHist <- renderPlot({

        even_di <- filter(all_di, simpson_95_ratio_1t > input$min_even_interval,
                          simpson_95_ratio_1t < input$max_even_interval)


        ggplot(even_di, aes(x = simpson_95_ratio_1t)) +
            geom_histogram() +
            theme_bw()+
            xlim(0, 1)
    })

    output$skew_snPlot <- renderPlot({

        skew_di <- filter(all_di, skew_95_ratio_1t > input$min_skew_interval,
                          skew_95_ratio_1t < input$max_skew_interval, s0 >2)

        ggplot(all_di, aes(x = log(s0), y = log(n0))) +
            geom_point(color = "grey") +
            theme_bw() +
            geom_point(data = skew_di)
    })
    output$even_snPlot <- renderPlot({

        even_di <- filter(all_di, simpson_95_ratio_1t > input$min_even_interval,
                          simpson_95_ratio_1t < input$max_even_interval)
        ggplot(all_di, aes(x = log(s0), y = log(n0))) +
            geom_point(color = "grey") +
            theme_bw() +
            geom_point(data = even_di)
    })



    output$skewPlot <- renderPlot({

        skew_di <- filter(all_di, skew_95_ratio_1t > input$min_skew_interval,
                          skew_95_ratio_1t < input$max_skew_interval, s0 >2)
        ggplot(skew_di, aes(skew_percentile_excl)) +
            geom_histogram(bins = 100) +
            theme_bw()
    })


    output$evenPlot <- renderPlot({

        even_di <- filter(all_di, simpson_95_ratio_1t > input$min_even_interval,
                          simpson_95_ratio_1t < input$max_even_interval)

        ggplot(even_di, aes(simpson_percentile)) +
            geom_histogram(bins = 100) +
            theme_bw()
    })

    output$skewResults <- renderTable({

        skew_di <- filter(all_di, skew_95_ratio_1t > input$min_skew_interval,
                          skew_95_ratio_1t < input$max_skew_interval, s0 >2)
        skew_di %>%
            summarize(prop_skew_high = mean(skew_percentile_excl > 95),
                      nskew_sites = dplyr::n())
    })

    output$evenResults <- renderTable({

        even_di <- filter(all_di, simpson_95_ratio_1t > input$min_even_interval,
                          simpson_95_ratio_1t < input$max_even_interval)

        even_di %>%
            summarize(prop_even_low = mean(simpson_percentile < 5),
                      neven_sites = dplyr::n())
    })
}

# Run the application
shinyApp(ui = ui, server = server)
