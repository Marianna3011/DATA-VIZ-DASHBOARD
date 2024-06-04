library(shiny)
library(shinydashboard)
library(plotly)

#c("#FF9AA2", "#FFB7B2", "#FFDAC1", "#E2F0CB", "#B5EAD7")
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
                                background-color: #E2F0CB;
                                }
                                
                                /* logo when hovered */
                                .skin-blue .main-header .logo:hover {
                                background-color: #E2F0CB;
                                }
                                
                                /* navbar (rest of the header) */
                                .skin-blue .main-header .navbar {
                                background-color: #E2F0CB;
                                }
                                
                                /* main sidebar */
                                .skin-blue .main-sidebar {
                                background-color: #E2F0CB;
                                }
                                
                                /* active selected tab in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                                background-color: #FFB7B2;
                                }
                                
                                /* other links in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                                background-color: #FFB7B2;
                                color: #000000;
                                }
                                
                                /* other links in the sidebarmenu when hovered */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                                background-color: #FFB7B2;
                                }
                                /* toggle button when hovered  */
                                .skin-blue .main-header .navbar .sidebar-toggle:hover{
                                background-color: #FFB7B2;
                                }

                                /* body */
                                .content-wrapper, .right-side {
                                background-color: #B5EAD7;
                                }
                                
                                ')))
  )
)


# Export the UI
shinyUI(ui)
