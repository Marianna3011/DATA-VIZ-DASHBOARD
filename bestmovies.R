library(tidyverse)
library(plotly)
library(viridis)

movies <- read_csv("imdb-movies-dataset.csv")

movies <- movies %>%
  select(Year, Rating, Title, Director, Genre)

top5_movies <- movies %>%
  group_by(Year) %>%
  arrange(Year, desc(Rating)) %>%
  slice_head(n = 5) %>%
  ungroup()


pastel_palette <- viridis_pal(option = "D")(5)
pastel_palette <- adjustcolor(pastel_palette, alpha.f = 0.5)

steps <- lapply(unique(top5_movies$Year), function(year) {
  list(
    args = list(
      list(
        y = list(top5_movies$Title[top5_movies$Year == year]),
        x = list(top5_movies$Rating[top5_movies$Year == year]),
        text = list(top5_movies$Title[top5_movies$Year == year]),  # Update text for each step
        marker = list(color = pastel_palette)
      )
    ),
    label = as.character(year),
    method = "restyle"
  )
})

initial_year <- unique(top5_movies$Year)[1]

fig <- top5_movies %>%
  filter(Year == initial_year) %>%
  arrange(desc(Rating)) %>%  # Sort by descending rating
  plot_ly(
    y = ~Title, 
    x = ~Rating, 
    type = 'bar', 
    orientation = 'h',  # Set orientation to horizontal
    text = ~Title,  # Display title on the bar
    textposition = 'inside',  # Position the text inside the bar
    textangle = 0,  # Rotate the text by 0 degrees
    marker = list(color = pastel_palette), 
    hoverinfo = 'text',  # Enable text for hover info
    hovertext = ~paste("Director:", Director, "<br>Genre:", Genre, "<br>Title:", Title)  # Hover text
  ) %>%
  layout(
    title = 'Top 5 Movies Each Year by Rating',
    yaxis = list(
      title = 'Movies',
      tickvals = list(),  # Remove y-axis labels
      ticktext = list()
    ),
    xaxis = list(title = 'Rating', range = c(1, 10)),
    showlegend = FALSE,  
    sliders = list(
      list(
        active = 0,
        currentvalue = list(prefix = "Year: "),
        pad = list(t = 0),
        steps = steps
      )
    )
  )

fig

