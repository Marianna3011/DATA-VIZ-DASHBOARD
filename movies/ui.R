library(shiny)
library(shinydashboard)
library(plotly)

# Define UI for the dashboard
ui <- dashboardPage(
  dashboardHeader(title = img(src = "PP_logotyp_RGB.png", width=200, align = "right") ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "about"),
      menuItem("Dashboard", tabName = "dashboard"),
      menuItem("Genres", tabName = "genres"))
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
              box(
                title = "Movie Releases by Year",
                plotlyOutput("Releases")
              ),
              width = 10
            )
            
    ),
    
    tabItem(tabName = "about",
            h2("About This Dashboard"),
            p("Welcome to our Movie Dashboard, your one-stop destination for exploring comprehensive data visualizations about movies! Dive into an array of insightful charts and graphs that showcase various aspects of the cinematic world."),
            p("Key Features:"),
            tags$ul(
              tags$li("Movie Lengths: Discover trends and patterns in the lengths of movies across different genres and years. See how the duration of films has evolved over time."),
              tags$li("Top Movies: Explore lists of the best movies from different years and genres. Our curated data highlights critically acclaimed and popular films that have left a mark on audiences and critics alike."),
              tags$li("Genre Analysis: Gain insights into various movie genres. Compare and contrast their popularity, average ratings, and box office performance."),
              tags$li("Yearly Trends: Understand how the film industry has changed over the years. Look at the number of movies released annually, their average ratings, and other key metrics."),
              tags$li("Interactive Visualizations: Engage with interactive charts that allow you to filter and drill down into specific data points. Customize your view to focus on the information that interests you most.")
            )
    )
  )
  )
)


# Export the UI
shinyUI(ui)
