setwd("C:/Users/Admin/Documents/Uni/Sem4/DV/HW4")


library(plotly)
library(ggplot2)
library(dplyr)
library(scales)

imdb <- read.csv("imdb-movies-dataset.csv")

movies_data <- na.omit(imdb)

colnames(movies_data)



### Top 10 Directors Based on Total and Avarage Ratings

top_directors_total <- movies_data %>%
  group_by(Director) %>%
  summarise(Total_Rating = sum(Rating, na.rm = TRUE)) %>%
  arrange(desc(Total_Rating)) %>%
  slice_head(n = 10)

top_directors_average <- movies_data %>%
  group_by(Director) %>%
  summarise(Average_Rating = mean(Rating, na.rm = TRUE)) %>%
  arrange(desc(Average_Rating)) %>%
  slice_head(n = 10)

custom_colors <- c("#FF9AA2", "#FFB7B2", "#FFDAC1", "#E2F0CB", "#B5EAD7", "#FFB7B2", "#FFDAC1", "#E2F0CB", "#B5EAD7", "#FFB7B2", "#FFDAC1", "#E2F0CB", "#B5EAD7", "#FFB7B2", "#FFDAC1", "#E2F0CB", "#B5EAD7", "#FFB7B2", "#FFDAC1", "#FFB7B2", "#FFB7B2", "#FFDAC1", "#FFB7B2")

p <- plot_ly() %>%
  add_bars(data = top_directors_total, x = ~Director, y = ~Total_Rating,
           name = 'Total Ratings', marker = list(color = custom_colors)) %>%
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
p



### Average Movie Ratings by Year

yearly_avg_ratings <- movies_data %>%
  group_by(Year, Decade = floor(Year / 10) * 10) %>%
  summarise(Average_Rating = mean(Rating, na.rm = TRUE)) %>%
  arrange(Year)

decade_avg_ratings <- movies_data %>%
  group_by(Decade = floor(Year / 10) * 10) %>%
  summarise(Average_Rating = mean(Rating, na.rm = TRUE)) %>%
  arrange(Decade)

unique_decades <- sort(unique(yearly_avg_ratings$Decade))

palette_length <- length(unique_decades)
decade_colors <- colorRampPalette(c("#FF9AA2", "#FFB7B2", "#FFDAC1", "#E2F0CB", "#B5EAD7"))(palette_length)

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
p



### Percentage of Movies Produced Each Decade by Genre (Top Genres)
movies_data <- movies_data %>%
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
  scale_fill_manual(values = custom_colors) +
  labs(title = "Percentage of Movies Produced Each Decade by Genre (Top Genres)",
       x = "Decade",
       y = "Percentage of Total Movies",
       fill = "Genre") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

interactive_plot <- ggplotly(p)

interactive_plot