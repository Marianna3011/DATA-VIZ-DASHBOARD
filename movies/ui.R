library(shiny)
library(shinydashboard)
library(plotly)

# Define UI for the dashboard
ui <- dashboardPage(
  dashboardHeader(title = "All About Movies"),
  dashboardSidebar(),
  dashboardBody(
    includeCSS("styles.css"),  # Link to custom CSS file
    fluidRow(
      box(
        title = "Select Year and View Top Movies",
        numericInput("year", "Select Year:", value = 2024, min = 1929, max = 2025, step = 1),
        plotlyOutput("topMoviesPlot")
      ),
      box(
        title = "Distribution of Movie Durations by Genre",
        plotlyOutput("Duration")
      ),
      width = 10
    )
  )
)

# Export the UI
shinyUI(ui)
