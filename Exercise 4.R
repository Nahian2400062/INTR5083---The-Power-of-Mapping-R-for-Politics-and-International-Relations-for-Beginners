rm(list = ls())

pacman::p_load(tidyverse, sf, giscoR, readr, tidyr, ggplot2, viridis)


setwd("D:/CEU_MA_EDP/Spring 2025/The Power of Mapping R for Politics and International Relations")

votes <- read_csv("eu_ned_ep.csv")

# Task 1: Switch Country (from DE to PL)
nuts3_pl <- giscoR::gisco_get_nuts(
  country = "PL",
  resolution = "3",
  epsg = "3035",
  year = "2016",
  update_cache = TRUE
)

votes_pl <- votes |>
  filter(country_code == "PL", year == 2019, nutslevel == 3)

votes_df <- votes_pl |>
  mutate(
    vote_share = partyvote / totalvote * 100,
    turnout_pct = totalvote / electorate * 100,
    party = party_abbreviation
  ) |>
  select(nuts2016, party, vote_share, turnout_pct)

map_pl <- left_join(nuts3_pl, votes_df, by = c("NUTS_ID" = "nuts2016"))


# Task 2: Map Turnout Rate
turnout_df <- map_pl |>
  st_drop_geometry() |>  # remove spatial part for grouping
  group_by(NUTS_ID) |>
  summarise(turnout_pct = mean(turnout_pct, na.rm = TRUE))

map_turnout <- left_join(nuts3_pl, turnout_df, by = "NUTS_ID")

ggplot(map_turnout) +
  geom_sf(aes(fill = turnout_pct), color = "white", linewidth = .1) +
  scale_fill_viridis_c(name = "Turnout %", option = "viridis", direction = -1) +
  labs(title = "Turnout Rate - 2019 EU Parliament Election (Poland)") +
  theme_void()


# Task 3: Multi-party Split Map (Runner-Up Map)

# Top 3 Parties by Region 
top3_df <- votes_df |>
  group_by(nuts2016) |>
  arrange(desc(vote_share)) |>
  mutate(rank = row_number()) |>
  filter(rank <= 3) |>
  ungroup() |>
  mutate(rank = paste0("Rank_", rank))  # e.g., "Rank_1", "Rank_2", "Rank_3"

map_top3 <- left_join(nuts3_pl, top3_df, by = c("NUTS_ID" = "nuts2016"))

ggplot(map_top3) +
  geom_sf(aes(fill = party), color = "white", linewidth = .1) +
  facet_wrap(~rank) +
  scale_fill_brewer(palette = "Set3", na.value = "grey80") +
  labs(
    title = "Top 3 Parties by Region (NUTS-3)",
    subtitle = "2019 EU Parliament Election - Poland",
    fill = "Party"
  ) +
  theme_void()

# Rank parties per region by vote share and extract runner-up
map_runnerup <- votes_df |>
  group_by(nuts2016) |>
  arrange(desc(vote_share)) |>
  mutate(rank = row_number()) |>
  filter(rank == 2) |>
  select(nuts2016, party)

runnerup_map <- left_join(nuts3_pl, map_runnerup, by = c("NUTS_ID" = "nuts2016"))

ggplot(runnerup_map) +
  geom_sf(aes(fill = party), color = "white", linewidth = .1) +
  scale_fill_brewer(palette = "Set2", na.value = "grey80") +
  labs(title = "Runner-Up Party by Region - 2019 EU Election (Poland)") +
  theme_void()
