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
movies_separated <- movies %>%
  separate_rows(Genre, sep = ",\\s*")

top5_movies <- movies %>%
  group_by(Year) %>%
  arrange(Year, desc(Rating)) %>%
  slice_head(n = 5) %>%
  ungroup()

# Define function to generate pastel palette
pastel_palette <- c("#E3E6D8", "#CDABA2", "#E7D5C7", "#D9D9CD", "#B9B2AF", "#E3E6D8", "#CDABA2", "#E7D5C7", "#D9D9CD", "#B9B2AF", "#E3E6D8", "#CDABA2", "#E7D5C7", "#D9D9CD", "#B9B2AF", "#E3E6D8", "#CDABA2", "#E7D5C7", "#D9D9CD", "#B9B2AF")

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
  pastel_pink_color <- "#B9B2AF"
  
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
                         color = I("#B9B2AF"),
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




create_realeases_by_year <- function() {
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
                        name = initial_genre,
                        line = list(color = '#B9B2AF'), # Set the color of the line
                        marker = list(color = '#B9B2AF')) %>% # Set the color of the markers
    layout(
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
              method = "restyle",
              args2 = list(
                list(line = list(color = '#B9B2AF'), # Update the line color dynamically
                     marker = list(color = '#B9B2AF')) # Update marker color dynamically
              )
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
  return(line_graph)
}




create_plot_Directors <- function() {
  top_directors_total <- movies %>%
    group_by(Director) %>%
    summarise(Total_Rating = sum(Rating, na.rm = TRUE)) %>%
    arrange(desc(Total_Rating)) %>%
    slice_head(n = 10)
  
  top_directors_average <- movies %>%
    group_by(Director) %>%
    summarise(Average_Rating = mean(Rating, na.rm = TRUE)) %>%
    arrange(desc(Average_Rating)) %>%
    slice_head(n = 10)
  
  p <- plot_ly() %>%
    add_bars(data = top_directors_total, x = ~Director, y = ~Total_Rating,
             name = 'Total Ratings', marker = list(color = pastel_palette)) %>%
    layout(title = "Top 10 Directors by Total Ratings",
           xaxis = list(title = "Director", type = 'category'),
           yaxis = list(title = "Ratings"),
           barmode = 'group',
           updatemenus = list(
             list(
               type = "dropdown",
               active = 0,
               buttons = list(
                 list(method = "update",
                      args = list(list(y = list(top_directors_total$Total_Rating),
                                       x = list(top_directors_total$Director)),
                                  list(title = "Top 10 Directors by Total Ratings")),
                      label = "Total Ratings"),
                 list(method = "update",
                      args = list(list(y = list(top_directors_average$Average_Rating),
                                       x = list(top_directors_average$Director)),
                                  list(title = "Top 10 Directors by Average Ratings")),
                      label = "Average Ratings")
               ),
               x = 0.05,
               xanchor = "left",
               y = 1.15,
               yanchor = "top"
             )
           ))
  return(p)
}

create_plot_Average <- function() {
  yearly_avg_ratings <- movies %>%
    group_by(Year, Decade = floor(Year / 10) * 10) %>%
    summarise(Average_Rating = mean(Rating, na.rm = TRUE)) %>%
    arrange(Year)
  
  decade_avg_ratings <- movies %>%
    group_by(Decade = floor(Year / 10) * 10) %>%
    summarise(Average_Rating = mean(Rating, na.rm = TRUE)) %>%
    arrange(Decade)
  
  unique_decades <- sort(unique(yearly_avg_ratings$Decade))
  
  palette_length <- length(unique_decades)
  decade_colors <- colorRampPalette(c("#E3E6D8", "#CDABA2", "#E7D5C7", "#D9D9CD", "#B9B2AF"))(palette_length)
  
  colors_mapped <- setNames(decade_colors, unique_decades)
  
  p <- plot_ly() %>%
    add_bars(data = yearly_avg_ratings, x = ~Year, y = ~Average_Rating,
             name = 'Average Rating', marker = list(color = ~colors_mapped[as.character(Decade)])) %>%
    layout(title = "Average Movie Ratings by Year/Decade",
           xaxis = list(title = "Year/Decade"),
           yaxis = list(title = "Average Rating"),
           barmode = 'group',
           updatemenus = list(
             list(
               type = "dropdown",
               active = 0,
               buttons = list(
                 list(method = "restyle",
                      args = list(list(y = list(yearly_avg_ratings$Average_Rating),
                                       x = list(yearly_avg_ratings$Year))),
                      label = "By Year"),
                 list(method = "restyle",
                      args = list(list(y = list(decade_avg_ratings$Average_Rating[decade_avg_ratings$Decade == decade_avg_ratings$Decade]),
                                       x = list(decade_avg_ratings$Decade))),
                      label = "By Decade")
               ),
               x = 0.05,
               xanchor = "left",
               y = 1.15,
               yanchor = "top"
             )
           ))
  return(p)
}

create_plot_Percentage <- function() {
  movies_data <- movies %>%
    mutate(Decade = floor(Year / 10) * 10) %>%
    separate_rows(Genre, sep = ",\\s*")  
  
  top_genres <- movies_data %>%
    group_by(Genre) %>%
    summarise(Total = n()) %>%
    top_n(5, Total) %>%  
    pull(Genre)
  
  decade_genre_counts <- movies_data %>%
    mutate(Genre = ifelse(Genre %in% top_genres, Genre, "Other")) %>%
    group_by(Decade, Genre) %>%
    summarise(Movie_Count = n(), .groups = 'drop') %>%
    arrange(Decade)
  
  total_movies_per_decade <- decade_genre_counts %>%
    group_by(Decade) %>%
    summarise(Total_Movies = sum(Movie_Count), .groups = 'drop')
  
  decade_genre_counts <- decade_genre_counts %>%
    left_join(total_movies_per_decade, by = "Decade") %>%
    mutate(Percentage = (Movie_Count / Total_Movies) * 100)
  
  p <- ggplot(decade_genre_counts, aes(x = as.factor(Decade), y = Percentage, fill = Genre)) +
    geom_bar(stat = "identity", position = "fill") +
    scale_fill_manual(values = pastel_palette) +
    labs(title = "Percentage of Movies Produced Each Decade by Genre (Top Genres)",
         x = "Decade",
         y = "Percentage of Total Movies",
         fill = "Genre") +
    scale_y_continuous(labels = scales::percent_format()) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Convert ggplot object to a plotly object
  interactive_plot <- ggplotly(p)
  
  return(interactive_plot)
}

# Define server function
shinyServer(function(input, output) {
  output$topMoviesPlot <- renderPlotly({
    create_plot(input$year)
  })

  output$Duration <-renderPlotly({create_plot_Durations()})
  output$Releases <-renderPlotly({create_realeases_by_year()})
  output$menu <- renderMenu({
    sidebarMenu(
      menuItem("Menu item", icon = icon("calendar"))
    )
  })
  output$Percentage <- renderPlotly({create_plot_Percentage()})
  output$Average <- renderPlotly({create_plot_Average()})
  output$Directors <- renderPlotly({create_plot_Directors()})
})
