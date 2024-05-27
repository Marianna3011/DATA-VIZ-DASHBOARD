library(shiny)
library(plotly)

# Define UI for application that draws a histogram
fluidPage(
  
  # Application title
  titlePanel(
    div(
      h1("ALL ABOUT MOVIES", align = "center"),
      style = "background-color: pink; padding: 10px; border-radius: 10px; margin-bottom: 20px;"
    )
  ),
  
  # Define custom CSS styles for the UI
  tags$head(
    tags$style(HTML("
            body {
                background-color: #EEE5E6;
                color: #4B4156;
                font-family: 'Prompt', sans-serif;
            }
            .navbar {
                background-color: #BFD8ED;
            }
            h1, h2, h3, h4, h5, h6 {
                font-family: 'Sen', sans-serif;
            }
            code {
                font-family: 'JetBrains Mono', monospace;
            }
        "))
  ),
  
 # Slider input for year selection
  sidebarLayout(
    sidebarPanel(
      numericInput("year", "Select Year:", 
                               value = 2024, min = 1929, max = 2025, step = 1)
    ),
    
    # Main panel for the plot
    mainPanel(
      plotlyOutput("topMoviesPlot")
    )
  )
)