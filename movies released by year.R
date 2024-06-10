library(tidyverse)
library(plotly)

# Assuming movies dataset is already loaded and processed as before

# Separate the genres into individual rows
movies_separated <- movies %>%
  separate_rows(Genre, sep = ",\\s*")

# Aggregate data to count the number of movies per year for each genre
movies_per_year_genre <- movies_separated %>%
  group_by(Year, Genre) %>%
  summarise(Number_of_Movies = n()) %>%
  ungroup()

# Aggregate data to count the total number of movies per year
movies_per_year_all <- movies %>%
  group_by(Year) %>%
  summarise(Number_of_Movies = n()) %>%
  mutate(Genre = "All Movies") %>%
  ungroup()

# Combine both data frames
movies_per_year_combined <- bind_rows(movies_per_year_genre, movies_per_year_all)

# Create initial plot
initial_genre <- "All Movies"
line_graph <- plot_ly(data = movies_per_year_combined %>% filter(Genre == initial_genre),
                      x = ~Year, y = ~Number_of_Movies, type = 'scatter', mode = 'lines+markers',
                      name = initial_genre) %>%
  layout(
    title = "Number of Movies Released Each Year",
    xaxis = list(title = "Year"),
    yaxis = list(title = "Number of Movies"),
    updatemenus = list(
      list(
        active = 0,
        buttons = lapply(c("All Movies", unique(movies_separated$Genre)), function(genre) {
          list(
            args = list(list(y = list(movies_per_year_combined$Number_of_Movies[movies_per_year_combined$Genre == genre]),
                             x = list(movies_per_year_combined$Year[movies_per_year_combined$Genre == genre])),
                        list(title = paste("Number of Movies Released Each Year -", genre))),
            label = genre,
            method = "restyle"
          )
        }),
        direction = "down",
        x = 0.05,
        xanchor = "left",
        y = 1.15,
        yanchor = "top"
      )
    )
  )

line_graph
