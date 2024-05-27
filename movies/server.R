# server.R
library(shiny)
library(tidyverse)
library(plotly)
library(viridis)

# Load data
movies <- read_csv("imdb-movies-dataset.csv")

movies <- movies %>%
  select(Year, Rating, Title, Director, Genre)

top5_movies <- movies %>%
  group_by(Year) %>%
  arrange(Year, desc(Rating)) %>%
  slice_head(n = 5) %>%
  ungroup()

# Define function to generate pastel palette
pastel_palette <- viridis_pal(option = "D")(5)
pastel_palette <- adjustcolor(pastel_palette, alpha.f = 0.5)

# Set initial year
initial_year <- unique(top5_movies$Year)[1]

# Define function to create plot
create_plot <- function(selected_year) {
  if (selected_year %in% top5_movies$Year) {
    fig <- top5_movies %>%
      filter(Year == selected_year) %>%
      arrange(desc(Rating)) %>%
      plot_ly(
        y = ~Title,
        x = ~Rating,
        type = 'bar',
        orientation = 'h',
        text = ~Title,
        textposition = 'inside',
        textangle = 0,
        marker = list(color = pastel_palette),
        hoverinfo = 'text',
        hovertext = ~paste("Director:", Director, "<br>Genre:", Genre, "<br>Title:", Title)
      ) %>%
      layout(
        yaxis = list(
          title = 'Movies',
          tickvals = list(),
          ticktext = list()
        ),
        xaxis = list(title = 'Rating', range = c(1, 10)),
        showlegend = FALSE
      )
  } else {
    # If there is no data available for the selected year, display a message
    fig <- plot_ly(x = 0, y = 0, type = "scatter", mode = "markers",
                   marker = list(size = 1),
                   text = "No data available for this year") %>%
      layout(
        title = "No data available for this year",
        xaxis = list(title = "Rating"),
        yaxis = list(title = "Movies"),
        showlegend = FALSE
      )
  }
  return(fig)
}


# Define server function
function(input, output) {
  output$topMoviesPlot <- renderPlotly({
    create_plot(input$year)
  })
}
