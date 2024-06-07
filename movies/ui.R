library(shiny)
library(shinydashboard)
library(plotly)
library(slickR)

# Define UI for the dashboard
ui <- dashboardPage(
  dashboardHeader(title = img(src = "PP_logotyp_RGB.png", width=200, align = "right") ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "about"),
      menuItem("Dashboard", tabName = "dashboard"),
      menuItem("Genres", tabName = "genres"))
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",   
              fluidRow(tags$style(
                HTML(
                  "
          .slick-slide img {
            width: 100px; /* Set the width */
            height: 100px; /* Set the height */
          }
          "
                )
              ),
              box(
                title = "Select Year and View Top Movies",
                numericInput("year", "Select Year:", value = 2024, min = 1929, max = 2025, step = 1),
                plotlyOutput("topMoviesPlot")
              ),
              
              width=20
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
      ),tabItem(tabName = "genres",fluidRow(
        box(
          title = "Distribution of Movie Durations by Genre",
          plotlyOutput("Duration")
        ),
        box(
          title = "Number of Movies Released Each Year",
          plotlyOutput("Releases")
        ),width = 10
      )
      
      )
    ),
    includeCSS("styles.css"),  # Link to custom CSS file
    tags$head(tags$style(HTML('
                                /* logo */
                                .skin-blue .main-header .logo {
                                background-color: #CDABA2;
                                }
                                
                                /* logo when hovered */
                                .skin-blue .main-header .logo:hover {
                                background-color: #CDABA2;
                                }
                                
                                /* navbar (rest of the header) */
                                .skin-blue .main-header .navbar {
                                background-color: #CDABA2;
                                }
                                
                                /* main sidebar */
                                .skin-blue .main-sidebar {
                                background-color: #CDABA2;
                                }
                                
                                /* active selected tab in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                                background-color: #C0A0A2;
                                }
                                
                                /* other links in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                                background-color: #C0A0A2;
                                color: #000000;
                                }
                                
                                /* other links in the sidebarmenu when hovered */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                                background-color: #E0D0C7;
                                }
                                /* toggle button when hovered  */
                                .skin-blue .main-header .navbar .sidebar-toggle:hover{
                                background-color: #E0D0C7;
                                }

                                /* body */
                                .content-wrapper, .right-side {
                                background-color: #E7D5C7;
                                }
                                
                                ')))
  )
)


# Export the UI
shinyUI(ui)