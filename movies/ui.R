library(shiny)
library(shinydashboard)
library(plotly)

#c("#E3E6D8", "#CDABA2", "#E7D5C7", "#D9D9CD", "#B9B2AF")
# Define UI for the dashboard
ui <- dashboardPage(
  dashboardHeader(title = img(src = "PP_logotyp_RGB.png", width=200, align = "right") ),
  dashboardSidebar(
    sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard"),
                   menuItem("About", tabName = "about"))
  ),
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
    ),
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
