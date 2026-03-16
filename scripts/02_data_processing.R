# R Code for Cleaning and Processing Housing and Homelessness Data

# Load necessary libraries
library(dplyr)
library(tidyr)
library(readr)

# Function to clean the data
clean_data <- function(data) {
  data %>% 
    # Remove duplicates
    distinct() %>% 
    # Handle missing values
    replace_na(list(
      column1 = 0,  # replace NAs in column1 with 0
      column2 = 'Unknown'  # replace NAs in column2 with 'Unknown'
    )) %>% 
    # Filter out irrelevant data
    filter(column3 != 'Irrelevant')
}

# Function to process data
process_data <- function(data) {
  cleaned_data <- clean_data(data)
  processed_data <- cleaned_data %>% 
    group_by(column2) %>%  # Group by column2
    summarize(count = n()) %>%  # Count number of occurrences
    arrange(desc(count))  # Sort by count
  return(processed_data)
}

# Example Usage
# data <- read_csv('path/to/housing_homelessness_data.csv')
# cleaned_and_processed_data <- process_data(data)