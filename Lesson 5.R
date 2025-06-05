rm(list=ls())

pacman::p_load(tidyverse, sf, geodata, terra)

getwd()
setwd(
  "D:/CEU_MA_EDP/Spring 2025/The Power of Mapping R for Politics and International Relations"
)
list.files()

unzip("povmap-grdi-v1-grdiv1-geotiff.zip")

grdi_raster <- terra::rast("povmap-grdi-v1.tif")
print(grdi_raster)
terra::summary(grdi_raster)
terra::plot(grdi_raster)

boundaries <- geodata::gadm(
  country = "TUR", level = 1,
  path = tempdir()
) |>
  sf::st_as_sf()

plot(sf::st_geometry(boundaries))

grdi_turkey <- terra::crop(grdi_raster, boundaries, mask = TRUE)
terra::plot(grdi_turkey)

print(grdi_turkey)

grdi_agg <- terra::aggregate(grdi_turkey, fact = 2)
terra::plot(grdi_agg)

grdi_reproj <- terra::project(grdi_turkey, terra::crs(boundaries))

grdi_10 <- terra::ifel(grdi_turkey > 10, 10, grdi_turkey)
terra::summary(grdi_10)

grdi_10 <- terra::ifel(is.na(grdi_turkey), 0, grdi_turkey)
terra::summary(grdi_10)

grdi_df <- as.data.frame(grdi_turkey, xy = TRUE)
head(grdi_df)
names(grdi_df)[3] <- "grdi"


ggplot() +
  geom_raster(data = grdi_df, aes(x = x, y = y, fill = grdi)) +
  geom_sf(data = boundaries, fill = NA, color = "grey10", linewidth = .5) +
  scale_fill_viridis_c(
    option = "inferno", direction = -1, name = "GRDI"
  ) +
  coord_sf() +
  labs(
    title = "Global Gridded Relative Deprivation Index (GRDI), Version 1",
      subtitle = "30 arc-second (~1 km x 1 km) "
  ) + 
  theme_void()

# Zonal Statistics
boundaries_v <- terra::vect(boundaries)
grdi_mean_df <- terra::extract(
  x = grdi_turkey, y = boundaries_v, fun = mean,
  na.rm = TRUE, ID = FALSE
)

# exactextractr::exact_extract()

head(grdi_mean_df)
names(grdi_mean_df)[1] <- "grdi_mean"

boundaries$grdi_mean <- grdi_mean_df$grdi_mean

ggplot() +
  geom_sf(
    data = boundaries, aes(fill = grdi_mean),
    color = "white", linewidth = .1) +
  scale_fill_viridis_c(
    option = "inferno", direction = -1, name = "Average GRDI"
  ) +
  coord_sf() +
  labs(
    title = "Average GRDI",
    subtitle = "Province-level, means, Turkey",
    caption = "Source: NASA/SEDAC Global Gridded Relative Deprivation Index (GRDI), Version 1 "
  ) + 
  theme_void()

## https://earth.gov/data-catalog/grdi-v1





