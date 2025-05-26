rm(list=ls())

pacman::p_load(tidyverse,WDI,dplyr,ggplot2,sf,rnaturalearth,rnaturalearthdata,ggrepel)

dataset_list <- WDI::WDIsearch(string = "GDP per Capita")

gdp_data <- WDI::WDI(
  country= "all",
  indicator = "NY.GDP.PCAP.KD",
  start = 2023,
  end = 2023
)

gdp_data <- dplyr::mutate(gdp_data, gdp_pc = NY.GDP.PCAP.KD)
names(gdp_data)
names(gdp_data)[5] <- "gdp_pc"


world <- rnaturalearth::ne_countries(
  scale = "medium", returnclass = "sf"
)

plot(sf::st_geometry(world))
world_new <- subset(world, name != "Antarctica")
plot(sf::st_geometry(world_new))


world_gdp <- dplyr::left_join(
  world_new, gdp_data, by = c("iso_a3" = "iso3c")
)
names(world_gdp)

summary(world_gdp$gdp_pc)
min <- min(world_gdp$gdp_pc, na.rm = TRUE)
max <- max(world_gdp$gdp_pc, na.rm = TRUE)


ggplot() +
  geom_sf(
    data = world_gdp, aes(fill = gdp_pc),
    color = "white", size = 0.1
    ) +
    scale_fill_viridis_c(
    option = "plasma", 
    na.value = "lightgrey",
    breaks = c(500, 1000, 5000, 10000, 50000, 100000, 200000),
    ) +
    labs(title = "GDP per Capita (2023)",
    fill = "Constant 2015 USD",
    caption = "Source: World Bank (WDI)"
    ) +
    theme_void()
  

ggplot() +
   geom_sf(
      data = world_gdp, aes(fill = gdp_pc),
      color = "white", size = 0.1
      ) +
      scale_fill_viridis_c(
      option = "plasma", 
      na.value = "lightgrey",
      breaks = c(1000, 5000, 10000, 25000, 50000, 100000),
      labels = c("1K", "5K", "10K", "25K", "50K", "100K"),
      trans = "log"
      ) +
      labs(title = "GDP per Capita (2023)",
         fill = "Constant 2015 USD",
         caption = "Source: World Bank (WDI)"
      ) +
      theme_void() 


