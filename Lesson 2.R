rm(list = ls())

getwd()
setwd(
  "D:/CEU_MA_EDP/Spring 2025/The Power of Mapping R for Politics and International Relations"
)

pacman::p_load(tidyverse, rnaturalearth, sf)

conflict <- read.csv("africa_acled_may2025.csv")
head(conflict)

africa <- rnaturalearth::ne_countries(continent = "Africa", returnclass = "sf")
print(africa)
names(africa)


plot(africa)
plot(sf::st_geometry(africa))
class(conflict)
class(africa)

# ggplot(data = your_data, aes(x = x_column, y = y_column)) + geom_point()  # or geom_bar(), geom_line(), etc.
# https://r-charts.com/colors/
# https://www.sthda.com/sthda/RDoc/images/points-symbols.png

ggplot(data = conflict, aes(x = longitude, y = latitude)) + 
  geom_point(color = "salmon")

ggplot()+
  geom_sf(data = africa, color = "white", fill = "grey70") +
  geom_point(
    data = subset(conflict), 
    aes(x = longitude, y = latitude),
    color = "purple", alpha = 0.6, shape = 21
  ) + 
  geom_text(data = data.frame(x = 7.4, y= 9.1, label = "Abuja"),
            aes(x = x, y = y, label = label), color = "black", size = 4) +
  labs(
    title = "Conflict Events in Africa (May 2025)",
    x = "Longitude", y = "Latitude", caption = "Author: Nahian | Data: ACLED"
  ) +
  theme_void()


ggplot()+
  geom_sf(data = africa, color = "white", fill = "grey70") +
  geom_point(
    data = subset(conflict, fatalities > 0), aes(x = longitude, y = latitude, size = fatalities),
    color = "purple", alpha = 0.6, shape = 21
  ) + 
  labs(
    title = "Conflict Events in Africa (May 2025)",
    x = "Longitude", y = "Latitude", caption = "Author: Nahian | Data: ACLED"
  ) +
  theme_void()


map <- ggplot()+
  geom_sf(data = africa, color = "white", fill = "grey70") +
  geom_point(
    data = subset(conflict, fatalities > 0), 
    aes(x = longitude, y = latitude, color = fatalities),
  ) + 
  labs(
    title = "Conflict Events in Africa (May 2025)",
    x = "Longitude", y = "Latitude", caption = "Author: Nahian | Data: ACLED"
  ) +
  scale_color_viridis_c(direction = -1, option = "inferno") +
  theme_void()

ggsave("africa_conflict_map.png", width = 10, height = 7)

ggsave(
  filename = "africa_conflicts.png", plot = map, bg = "white"
)


conflict_sf <- sf::st_as_sf(
  conflict, coords = c("longitude", "latitude"),
  crs = 4326
)  # point coordinate

head(conflict)

sf::st_write(obj = africa, "africa.shp")
africa_sf <- sf::st_read("africa.shp")







