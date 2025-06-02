rm(list = ls())

# https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/IQRYP5

getwd()
setwd(
  "D:/CEU_MA_EDP/Spring 2025/The Power of Mapping R for Politics and International Relations"
)

pacman::p_load(tidyverse, sf, giscoR, readr, tidyr, ggplot2, viridis)

#  country <- giscoR::gisco_get_countries(
#   country = "DE", resolution = "1", epsg = "3035"
#  )

nuts3_de <- giscoR::gisco_get_nuts(
  country = "DE",
  resolution = "3",
  epsg = "3035",
  year = "2016",
  update_cache = TRUE
)

plot(sf::st_geometry(nuts3_de))

votes <- read_csv("eu_ned_ep.csv")
votes_de <- subset(votes, country_code == "DE" &
                     year == 2019 & nutslevel == 3)

votes_df <- votes_de |> 
  dplyr::mutate(vote_share = partyvote / totalvote * 100) |>
  dplyr::mutate(party = party_abbreviation) |>
  dplyr::select(nuts2016, party, vote_share)
  
summary(votes_df$party)
votes_df$party <- as.factor(votes_df$party)
summary(votes_df$party)
levels(votes_df$party)

map_de <- dplyr::left_join(
  nuts3_de, votes_df, by = c("NUTS_ID" = "nuts2016")
)

class(map_de)

# Map 1: AFD share of votes
map_afd <- ggplot() +
  geom_sf(
    data = subset(map_de, party == "AFD"), aes(fill = vote_share),
    color = "white", linewidth = .1
    ) +
  scale_fill_viridis_c(
    option = "viridis", direction = -1,
    name = "%share", na.value = "grey70"
  )+
  labs(title = "Share of AFD votes, 2019 EU Parliament Election") +
  theme_void()

plot(map_afd)

# Map 2: Panel Map
major_parties <- c("CDU", "CSU", "GRUNE", "AFD", "SPD")
map_major_parties <- subset(map_de, party %in% major_parties)

map_major <- ggplot() +
  geom_sf(
    data = map_major_parties, aes(fill = vote_share),
    color = "white", linewidth = .1
  ) +
  scale_fill_viridis_c(
    option = "viridis", direction = -1,
    name = "%share", na.value = "grey70"
  )+
  facet_wrap(~ party, scales = "fixed") +
  labs(title = "Share of Major Party votes, 2019 EU Parliament Election") +
  theme_void()

plot(map_major)


# Map 3: Winner map
map_winners <- map_de |>
  dplyr::group_by(NUTS_ID) |>
  dplyr::slice_max(
    order_by = vote_share, n = 1, with_ties = FALSE
  ) |>
  dplyr::ungroup()

map_winner <- ggplot() +
  geom_sf(
    data = map_winners, aes(fill = party), 
    color = "white", linewidth = .1
  ) +
  scale_fill_manual(
    name = "Party",
    values = c(
      "AFD" = "#ABD9E9", "CDU" = "black",
      "CSU" = "blue", "SPD" = "red", "GRUNE" = "green"
    ), drop = TRUE
  ) +
  labs(title = "2019 EU Parliament Election - Winning Party",
       subtitle = "NUTS-3 regions"
       ) +
  theme_void()

plot(map_winner)

# https://youtu.be/thAB4IzplQA (GDP, Nuts3 level)

# colorblind friendly - https://www.color-blindness.com/coblis-color-blindness-simulator/



