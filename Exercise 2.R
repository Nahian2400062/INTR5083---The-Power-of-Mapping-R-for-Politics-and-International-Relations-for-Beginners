#####         
rm(list=ls())


##  Exercise 1
# Load the CSV file
conflict <- read.csv("africa_acled_may2025.csv")

# How many events are in the dataset?
nrow(conflict)

# Which countries have the most events?
table(conflict$country)

# To sort the country counts in descending order:
sort(table(conflict$country), decreasing = TRUE)

# Explore the date range
# First, check the class of the date column
class(conflict$event_date)

# If not already in Date format, convert it
conflict$event_date <- as.Date(conflict$event_date)

# Now get the earliest and latest dates
min(conflict$event_date, na.rm = TRUE)
max(conflict$event_date, na.rm = TRUE)


## Exercise 2
# Filter data to Nigeria
conflict_NG <- subset(conflict, country == "Nigeria")

# Load required libraries
library(ggplot2)
library(maps)

# Base map with Nigeria's coordinates
ggplot() +
  borders("world", regions = "Nigeria", fill = "gray90", color = "black") +
  geom_point(data = conflict_NG,
             aes(x = longitude, y = latitude),
             color = "red", size = 2) +
  coord_quickmap(xlim = c(2, 15), ylim = c(4, 14)) +
  labs(title = "Conflict Events in Nigeria (May 2025)",
       x = "Longitude", y = "Latitude")


## Exercise 3
ggplot() +
  borders("world", regions = "Nigeria", fill = "gray95", color = "black") +
  geom_point(data = conflict_NG,
             aes(x = longitude, y = latitude, color = event_type, shape = event_type),
             size = 2, alpha = 0.6) +
  coord_quickmap(xlim = c(2, 15), ylim = c(4, 14)) +
  labs(title = "Conflict Events in Nigeria by Type (May 2025)",
       x = "Longitude", y = "Latitude",
       color = "Event Type", shape = "Event Type") +
  theme_minimal()


## Exercise 4
ggplot() +
  borders("world", regions = "Nigeria", fill = "gray95", color = "black") +
  geom_point(data = conflict_NG,
             aes(x = longitude, y = latitude),
             color = "darkblue", size = 2, alpha = 0.6) +
  geom_text(data = data.frame(x = 7.4, y = 9.1, label = "Abuja"),
            aes(x = x, y = y, label = label), 
            color = "black", size = 4, fontface = "bold") +
  coord_quickmap(xlim = c(2, 15), ylim = c(4, 14)) +
  labs(title = "Conflict Events in Nigeria with Capital Annotation",
       x = "Longitude", y = "Latitude") +
  theme_minimal()

