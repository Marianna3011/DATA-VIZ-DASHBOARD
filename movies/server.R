library(shiny)
library(tidyverse)
library(plotly)
library(viridis)

# Load data
movies <- read_csv("imdb-movies-dataset.csv")
movies2 <- movies %>%
  select(Year, Rating, Metascore, Title, Director, Genre, `Duration (min)`)
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
        text = "No data available for this year",
        showlegend = FALSE
      )
  }
  return(fig)
}
create_plot_Durations <- function() {
  
  
  # Separate rows based on Genre
  movies2 <- movies2 %>%
    separate_rows(Genre, sep = ",\\s*")
  
  # Create a unique list of genres
  genres <- unique(movies2$Genre)
  
  # Define a pastel pink color for the violins
  pastel_pink_color <- "#FFB6C1"
  
  # Determine the overall min and max duration for consistent scaling
  min_duration <- min(movies2$`Duration (min)`, na.rm = TRUE)
  max_duration <- max(movies2$`Duration (min)`, na.rm = TRUE)
  
  # Generate a list of steps for the update menu
  steps <- lapply(seq_along(genres), function(i) {
    genre <- genres[i]
    list(
      args = list(
        list(
          x = list(movies2$`Duration (min)`[movies2$Genre == genre])
        ),
        list(
          marker = list(color = pastel_pink_color)
        )
      ),
      label = genre,
      method = "restyle"
    )
  })
  
  # Add an "All Movies" option
  all_movies_step <- list(
    args = list(
      list(
        x = list(movies2$`Duration (min)`)
      ),
      list(
        marker = list(color = pastel_pink_color)  # Using pastel pink color for "All Movies"
      )
    ),
    label = "All Movies",
    method = "restyle"
  )
  
  steps <- append(list(all_movies_step), steps)
  
  # Create the initial violin plot for "All Movies"
  violin_plot <- plot_ly(data = movies2, 
                         x = ~`Duration (min)`, 
                         type = "violin",
                         color = I("#FFB6C1"),
                         marker = list(color = pastel_pink_color),  # Set pastel pink color here
                         hoverinfo = "none",  # Disable hoverinfo
                         points = FALSE,
                         showlegend = FALSE) %>%
    layout(
      title = "Distribution of Movie Durations by Genre",
      xaxis = list(title = "Duration (min)", range = c(min_duration, max_duration)),
      yaxis = list(title = "", showticklabels = FALSE), # Empty string to remove the y-axis tick labels
      updatemenus = list(
        list(
          active = 0,
          direction = "down",
          x = 0.05,
          xanchor = "left",
          y = 1.15,
          yanchor = "top",
          buttons = steps
        )
      )
    )
  return(violin_plot)
}

# Define server function
shinyServer(function(input, output) {
  output$topMoviesPlot <- renderPlotly({
    create_plot(input$year)
  })
  output$Duration <-renderPlotly({create_plot_Durations()})
})
