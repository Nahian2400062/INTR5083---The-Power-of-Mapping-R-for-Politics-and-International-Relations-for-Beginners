rm(list=ls())

# Install packages if needed
# install.packages(c("WDI", "dplyr", "ggplot2", "sf", "rnaturalearth", "rnaturalearthdata", "ggrepel"))

pacman::p_load(tidyverse,WDI,dplyr,ggplot2,sf,rnaturalearth,rnaturalearthdata,ggrepel)


##  Exercise 1: Map Life Expectancy

# Download life expectancy data (indicator: SP.DYN.LE00.IN)
life_exp <- WDI(indicator = "SP.DYN.LE00.IN", start = 2020, end = 2020, extra = TRUE)

# Clean and select relevant columns
life_exp_clean <- life_exp %>%
  select(iso_a3 = iso3c, country, life_expectancy = SP.DYN.LE00.IN) %>%
  filter(!is.na(iso_a3))

# Load world map
world <- ne_countries(scale = "medium", returnclass = "sf")

# Merge world map with life expectancy data
world_life <- left_join(world, life_exp_clean, by = "iso_a3")

# Step 5: Plot life expectancy
p1 <- ggplot(world_life) +
  geom_sf(aes(fill = life_expectancy), color = "white", size = 0.1) +
  scale_fill_viridis_c(option = "plasma", na.value = "lightgray") +
  labs(title = "Life Expectancy at Birth (2020)",
       fill = "Years",
       caption = "Source: World Bank (WDI)") +
  theme_minimal()

# Display plot
print(p1)


## Exercise 2: Focus on Africa

# Option A: Zoom into Africa
p2 <- ggplot(world_life) +
  geom_sf(aes(fill = life_expectancy), color = "white", size = 0.1) +
  scale_fill_viridis_c(option = "plasma", na.value = "lightgray") +
  labs(title = "Life Expectancy in Africa (Zoomed In)",
       fill = "Years",
       caption = "Source: World Bank (WDI)") +
  theme_minimal()

print(p2)

# Option B: Filter to Africa only
africa <- world_life %>% filter(continent == "Africa")

p3 <- ggplot(africa) +
  geom_sf(aes(fill = life_expectancy), color = "white", size = 0.1) +
  scale_fill_viridis_c(option = "plasma", na.value = "lightgray") +
  labs(title = "Life Expectancy in Africa (Filtered)",
       fill = "Years",
       caption = "Source: World Bank (WDI)") +
  theme_minimal()

print(p3)


## Exercise 3: Label Highest and Lowest Life Expectancy Countries

# Remove rows with missing life expectancy
world_life_complete <- world_life[!is.na(world_life$life_expectancy), ]

# Compute centroids and extract x (longitude) and y (latitude)
centroids <- st_centroid(world_life_complete$geometry)
coords <- st_coordinates(centroids)

# Add coordinates to your data
world_life_complete <- world_life_complete %>%
  mutate(x = coords[, 1],
         y = coords[, 2])

# Get country with max and min life expectancy
max_country <- world_life_complete[which.max(world_life_complete$life_expectancy), ]
min_country <- world_life_complete[which.min(world_life_complete$life_expectancy), ]

# Plot with labels
p4 <- ggplot(world_life_complete) +
  geom_sf(aes(fill = life_expectancy), color = "white", size = 0.1) +
  geom_text_repel(data = max_country, aes(x = x, y = y, label = name), color = "black", size = 3) +
  geom_text_repel(data = min_country, aes(x = x, y = y, label = name), color = "black", size = 3) +
  scale_fill_viridis_c(option = "plasma", na.value = "lightgray") +
  labs(
    title = "Life Expectancy (2020)",
    fill = "Years",
    caption = "Source: World Bank (WDI)"
  ) +
  theme_minimal()

print(p4)



## Exercise 4: Temporal Comparison (2000 vs 2020)

# Download for both years
life_exp_00_20 <- WDI(indicator = "SP.DYN.LE00.IN", start = 2000, end = 2020, extra = TRUE)

# Clean and keep only 2000 & 2020
life_exp_wide <- life_exp_00_20 %>%
  filter(year %in% c(2000, 2020)) %>%
  select(iso_a3 = iso3c, country, year, life_expectancy = SP.DYN.LE00.IN) %>%
  pivot_wider(names_from = year, values_from = life_expectancy, names_prefix = "yr_")

# Merge with map
world_change <- left_join(world, life_exp_wide, by = "iso_a3") %>%
  mutate(change = yr_2020 - yr_2000)

# Plot change
p5 <- ggplot(world_change) +
  geom_sf(aes(fill = change), color = "white", size = 0.1) +
  scale_fill_distiller(palette = "PuBuGn", direction = 1, na.value = "lightgray") +
  labs(title = "Change in Life Expectancy (2000–2020)",
       fill = "Years Gained",
       caption = "Source: World Bank (WDI)") +
  theme_minimal()

print(p5)

ggsave("life_expectancy_map.png", plot = p1, width = 10, height = 6, dpi = 300)

