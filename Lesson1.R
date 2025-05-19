rm(list = ls())
"abcd"
'abcd'

2 + 2 - 2
5 * (9 / 5)
5 > 3


NA
NULL

x <- 5 * (9 / 5)
x <- 3
print(x)
class(x) # to find out what x is

z = 0
y <- x - z


country <- c("Country A", "Country B", "Country C")
population <- c(1000, 2000, 5000)
country <- c("a", "b", "c")
dataset <- data.frame(country, population)
head(dataset)
tail(dataset)
dataset$year <- 2023:2025
dataset$year <- NULL
dataset <- dataset[-1]
country_b <- subset(dataset, country == "b" & population == 2000)
print(country_b)

summary(dataset)


getwd()
setwd("D:/CEU_MA_EDP/Spring 2025/The Power of Mapping R for Politics and International Relations")

ACLED_Data <- read.csv("africa_acled_may2025.csv")
head(ACLED_Data)
nrow(ACLED_Data)
ncol(ACLED_Data)
dim(ACLED_Data)
summary(ACLED_Data)
summary(ACLED_Data$inter2)
write.csv(x=ACLED_Data, file = "Africa")
readr::read_csv("Africa")

install.packages("sf")
library(sf)
install.packages("pacman")
library(pacman)
pacman::p_load(tidyverse)

