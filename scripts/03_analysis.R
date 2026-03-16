# Correlation and Regression Analysis between Rent Costs and Homelessness

# Load necessary packages
library(ggplot2)

# Load the dataset
# Note: Replace this with the path to your dataset
# data <- read.csv('path_to_your_data.csv')

# Example dataset
rent_costs <- c(800, 1200, 1500, 1700, 2500)
homelessness_rate <- c(5, 10, 15, 20, 25)

data <- data.frame(rent_costs, homelessness_rate)

# Correlation analysis
correlation <- cor(data$rent_costs, data$homelessness_rate)
cat('Correlation between Rent Costs and Homelessness Rate: ', correlation, '\n')

# Simple linear regression analysis
model <- lm(homelessness_rate ~ rent_costs, data = data)
summary(model)

# Visualizing the relationship
ggplot(data, aes(x=rent_costs, y=homelessness_rate)) + 
  geom_point() +  
  geom_smooth(method='lm', color='blue') + 
  labs(title='Rent Costs vs Homelessness Rate',
       x='Rent Costs',
       y='Homelessness Rate')