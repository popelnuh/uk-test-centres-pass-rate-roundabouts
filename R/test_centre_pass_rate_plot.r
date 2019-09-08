install.packages(c("tidyverse", "ggpubr"))

library(tidyverse)
library(ggpubr)
theme_set(theme_pubr())

# Set working directory
setwd("C:/dev/data/roundabouts")

# Specify data frame
test_centres <- read.csv(file = 'centre_pass_rate_roundabout')

# Investigate
summary(test_centres)

# Plot dependent variable (pass rate) and independent variable (number of roundabouts)
ggplot(test_centres, aes(x = number_roundabouts, y = rate)) + geom_point()

# Normalise the number of roundabouts
ggplot(test_centres, aes(x = number_roundabouts, y = rate)) + geom_point() + scale_x_log10()

# Run Pearson's correlation
correlation <- cor.test(test_centres$rate, test_centres$number_roundabouts, 
                method = "pearson")

# Print the output
correlation

simple.fit = lm(rate~number_roundabouts, data=test_centres)
summary(simple.fit)
