################################################################################
# Initial Dive Data Processing 
################################################################################
#
# Emerson Dresser
# ebd63@miami.edu
# 10/1/2026
#
# This script reads in the raw CSV data from my dive log and the locations of
# the dives, then cleans and joins them for analysis. 
#
################################################################################

# SET UP #######################################################################

## Load Packages ---------------------------------------------------------------

library(tidyverse)
library(janitor)

## Load Data -------------------------------------------------------------------

dive_data <- read.csv("data/raw/dresser_dive_log.csv") |> 
  select(-"Comments") |> 
  clean_names()

# Get to know data 

dive_data |> colnames()  # check column names
dive_data |> str()       # check structure
dive_data |> dim()      # check dimensions 

# Processing ##################################################################

# Data contains 145 rows and 13 columns 

## Modify columns names --------------------------------------------------------

dive_data <- dive_data |> 
  rename(dive_number = number,          ## changing names to streamline later processing / analysis
         dive_min = total_time_this_dive,
         total_dive_hours = total_water_hours_to_date,
         max_depth = max_depth_ft,
         surface_temp = surface_temp_f,
         bottom_temp = bottom_temp_f,
         air_in = air_in_psi) |>  
  mutate(date = mdy(date),            ## adding additional columns based on data in csv
         dive_min = period_to_seconds(hm(dive_min))/60, # convert dive time from "h:mm" text to minutes (numeric)
         weight = parse_number(weight),     # dropping the # in value (cell)
         air_consumed = (air_in-air_out),   # calculating air consumed on dive
         psi_per_min = (air_consumed / dive_min),  # air per minute on each dive
         temp_diff = (surface_temp - bottom_temp))  # temp dif. between surface and bottom 

## Inspect new dataframe

colnames(dive_data) # colum names
str(dive_data)       # column structure
dim(dive_data) ## now has 16 columns and 145 rows 

dive_data

# new names are tidy and cleaner to work with, added columns to help with later
# analysis based on current directions of project. 

## viewing location inputs to change and import cleaner version

unique(dive_data$location) ## 28 locations due to inconsistency 
## original 28 used to create condensed csv 

dive_locations <- read_csv("data/raw/dive_locations.csv")

dive_data_clean <- dive_data |> 
  left_join(dive_locations, by = "location") |> 
  select(-location)

view(dive_data_clean)   # viewing new tibble
colnames(dive_data_clean) # checking names
str(dive_data_clean)      # checking structure 
dive_data_clean          # overview


# EXPORT #######################################################################

write_rds(x = dive_data_clean, 
          file = "data/processed/dive_data_clean.rds")