library(tidyverse)
library(plotly)
library(viridis)

# Load the dataset
movies <- read_csv("imdb-movies-dataset.csv")

# Select relevant columns
movies <- movies %>%
  select(Year, Rating, Metascore, Title, Director, Genre, `Duration (min)`)

# Separate rows based on Genre
movies <- movies %>%
  separate_rows(Genre, sep = ",\\s*")

# Create a unique list of genres
genres <- unique(movies$Genre)

# Define a pastel pink color for the violins
pastel_pink_color <- "#FFB6C1"

# Determine the overall min and max duration for consistent scaling
min_duration <- min(movies$`Duration (min)`, na.rm = TRUE)
max_duration <- max(movies$`Duration (min)`, na.rm = TRUE)

# Generate a list of steps for the update menu
steps <- lapply(seq_along(genres), function(i) {
  genre <- genres[i]
  list(
    args = list(
      list(
        x = list(movies$`Duration (min)`[movies$Genre == genre])
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
      x = list(movies$`Duration (min)`)
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
violin_plot <- plot_ly(data = movies, 
                       x = ~`Duration (min)`, 
                       type = "violin",
                       color = I("#FFB6C1"),
                       marker = list(color = pastel_pink_color),  # Set pastel pink color here
                       hoverinfo = "none",  # Disable hoverinfo
                       points = FALSE,
                       showlegend = FALSE) %>%
  layout(

    xaxis = list(title = "Duration (min)", range = c(min_duration, max_duration)),
    yaxis = list(title = "", showticklabels = FALSE), # Empty string to remove the y-axis tick labels
    updatemenus = list(
      list(
        active = 0,
        buttons = steps,
        direction = "down",
        x = 0.05,
        xanchor = "left",
        y = 1.15,
        yanchor = "top"
      )
    )
  )

violin_plot
