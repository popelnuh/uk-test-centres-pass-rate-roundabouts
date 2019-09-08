install.packages(c("dplyr", "readr", "readODS", "cellranger"))

# load libraries
library(readr)
library(dplyr)
library(readODS)
library(cellranger)

# set working directory
setwd("C:/dev/data/roundabouts/raw_data")

# Here we will process the Practical Test Centres and their locations
# Define data frame for the Practical Test Centres
test_centres <- read.csv(file = 'practical.csv', header=TRUE)

# Investigate
head(test_centres)
summary(test_centres) # There are 368 test centres

# Select test centre name and coordinates - this is all we need to map them
test_centres <- test_centres %>%
  select(Name,Lat,Long) %>%
  mutate(Lat = as.numeric(Lat)) %>%
  mutate(Long = as.numeric(Long))

# Investigate
head(test_centres) # Looks good

# Here we will process the Practical Test Centres and their pass rates
# I have opened the .ods file in Office Libre and learnt that the data I need is in sheet 3
# Define data frame for the pass rate for each centre
pass_rate <- read.ods(file = 'dvsa0201.ods', sheet = 3)

# Investigate
head(pass_rate, n = 50) # There are some columns and rows we can drop

# Remove unused rows
pass_rate <- pass_rate[-c(1:6),]

# Remove unused columns
pass_rate <- pass_rate[-c(2:11)]

# Give meaninful names to the fist two columns
colnames(pass_rate) <- c("centre", "pass_rate")

# Investigate
head(pass_rate, n = 20) # We only need the average pass rate information

# Remove raws that contain 2018 or 2019
pass_rate <- pass_rate[ grep("2019|2018", pass_rate$centre, invert = TRUE) , ]

# Investigate
head(pass_rate, n = 20) # We have now removed the monthly stats

# Remove rows with empty records
pass_rate <- pass_rate[!(is.na(pass_rate$pass_rate) | pass_rate$pass_rate==""), ]

# Investigate
head(pass_rate, n = 20) # Looks good!
summary(pass_rate) # There are 350 centres with the pass rate information

# Join test centres location and the test centre pass rates
pass_rate_centre <- left_join(pass_rate, test_centres, by = c("centre" = "Name"))

# Investigate
head(pass_rate_centre, n = 40) # Some values did not get joined

# Remove those with empty Lat, Long
pass_rate_centre <- na.omit(pass_rate_centre)

# Investigate
head(pass_rate_centre, n = 40) # Looks good!
summary(pass_rate_centre) # 258 centres were joined, 110 test centres "lost"

# TODO Investigate why we lost 110 test centres

# Write data into file
write.csv(pass_rate_centre,'pass_rate_cleared.csv')



