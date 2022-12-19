#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(httr)
library(pins)

# Connect to Posit Connect
board <- pins::board_rsconnect(server = "https://colorado.posit.co/rsc",
                               key = Sys.getenv("CONNECT_API_KEY"))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
      
        # Pinned Data
        x <- pins::pin_read(board, "ryan/Faithful_Geyser_Data")
        
        # Get vector of bin breaks from API
        bins <- unlist(
          content(
            GET("https://colorado.posit.co/rsc/bin_breaks_API/breaks", 
                query = list(n_bins = input$bins))))
      
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times', freq = TRUE)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
