library(tidyverse)
library(plotly)
library(viridis)

movies <- read_csv("imdb-movies-dataset.csv")

movies <- movies %>%
  select(Year, Rating, Metascore, Title, Director, Genre)

movies <- movies %>%
  separate_rows(Genre, sep = ", ") %>%
  mutate(Genre = str_trim(Genre))  # Trim whitespace

top5_movies <- movies %>%
  group_by(Year) %>%
  arrange(Year, desc(Rating)) %>%
  slice_head(n = 5) %>%
  ungroup()

genres <- unique(movies$Genre)
initial_genre <- genres[1]

pastel_palette <- c("#FF9AA2", "#FFB7B2", "#FFDAC1", "#E2F0CB", "#B5EAD7", "#FFB7B2", "#FFDAC1", "#E2F0CB", "#B5EAD7", "#FFB7B2", "#FFDAC1", "#E2F0CB", "#B5EAD7", "#FFB7B2", "#FFDAC1", "#E2F0CB", "#B5EAD7", "#FFB7B2", "#FFDAC1", "#FFB7B2", "#FFB7B2", "#FFDAC1", "#FFB7B2")

genre_steps <- lapply(genres, function(genre) {
  list(
    args = list(
      list(
        x = list(movies$Rating[movies$Genre == genre]),
        name = genre,
        marker = list(color = pastel_palette[which(genres == genre)])
      )
    ),
    label = genre,
    method = "restyle"
  )
})

rating_metascore_steps <- list(
  list(
    args = list(
      list(
        x = list(movies$Rating),
        name = "Rating",
        marker = list(color = pastel_palette[which(genres == initial_genre)])
      )
    ),
    label = "Rating",
    method = "restyle"
  ),
  list(
    args = list(
      list(
        x = list(movies$Metascore),
        name = "Metascore",
        marker = list(color = pastel_palette[which(genres == initial_genre)])
      )
    ),
    label = "Metascore",
    method = "restyle"
  )
)

initial_genre <- genres[1]
initial_variable <- "Rating"
histogram <- plot_ly(data = movies, x = ~Rating, type = "histogram", marker = list(color = pastel_palette[which(genres == initial_genre)])) %>%
  layout(
    title = "Distribution of Movie Ratings",
    xaxis = list(title = "Rating"),
    yaxis = list(title = "Number of Movies"),
    updatemenus = list(
      list(
        active = which(genres == initial_genre),
        buttons = genre_steps,
        direction = "down",
        x = 0.05,
        xanchor = "left",
        y = 1.15,
        yanchor = "top"
      ),
      list(
        buttons = rating_metascore_steps,
        direction = "down",
        x = 0.25,
        xanchor = "left",
        y = 1.15,
        yanchor = "top"
      )
    )
  )

histogram
