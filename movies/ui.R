library(shiny)
library(shinydashboard)
library(plotly)

# Define UI for the dashboard
ui <- dashboardPage(
  dashboardHeader(title = img(src = "PP_logotyp_RGB.png", width=200, align = "right") ),
  dashboardSidebar(
    sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard"),
                   menuItem("About", tabName = "about"))
  ),
  dashboardBody(  tabItems(
    tabItem(tabName = "dashboard",   
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
            
    ),
    
    tabItem(tabName = "about",
            h2("Widgets tab content")
    )
  )
  
 
  )
)

# Export the UI
shinyUI(ui)
