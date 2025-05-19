rm(list=ls())

setwd("D:/CEU_MA_EDP/Spring 2025/The Power of Mapping R for Politics and International Relations")
getwd

## Exercise 1: Simple Arithmetic and Variables
# -------------------

# Simple arithmetic operations
7^2           # This computes 7 squared = 49
sqrt(49)      # This computes the square root of 49 = 7

# Create variables
x <- 5        # You can choose any value for x
y <- 3        # You can choose any value for y

# Multiply x and y to create z
z <- x * y

# Print z to check the result
print(z)      # This should print 15 (if x = 5 and y = 3)



## Exercise 2: Working with Vectors 
# ----------------------

# Step 1: Create a numeric vector for years
years <- c(2018, 2019, 2020)

# Step 2: Create another numeric vector for GDP (made-up values)
gdp <- c(50000, 52000, 54000)

# Step 3: Combine the vectors into a data frame
economic_data <- data.frame(years, gdp)

# Step 4: Use summary() to get basic statistics
summary(economic_data)



## Exercise 3: Loading a Provided Dataset 
# -------------------------

# Step 1: Load the dataset from a CSV file
data <- read.csv("D:/CEU_MA_EDP/Spring 2025/The Power of Mapping R for Politics and International Relations/africa_acled_may2025.csv")

# Step 2: View the first few rows
head(data)

# Step 3: Get summary statistics
summary(data)



## Exercise 4: Install and load a package on your own
# ----------------------------

# Option 1
# Step 1: Install the package (only do this once)
install.packages("sf")
# Step 2: Load the package into your session
library(sf)

# Option 2
# Step 1: Install pacman if not already installed
install.packages("pacman")
# Step 2: Use pacman to install AND load sf
pacman::p_load(sf)


# Check if the package is loaded
search()  # Look for "package:sf" in the output
# Or try a function from sf
sf::st_point(c(1, 2))
