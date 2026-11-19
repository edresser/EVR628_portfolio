################################################################################
# Initial Dive Data Processing 
################################################################################
#
# Emerson Dresser
# ebd63@miami.edu
# 10/1/2026
#
# This script reads in the raw CSV data from my dive log, groups the dive 
# locations into area, region, and site, and cleans the data for analysis.
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

colnames(dive_data) # column names
str(dive_data)       # column structure
dim(dive_data) ## now has 16 columns and 145 rows 

dive_data

# new names are tidy and cleaner to work with, added columns to help with later
# analysis based on current directions of project. 

## Group locations into area, region, and site -------------------------------

unique(dive_data$location)  # 28 spellings in the raw log, many are the same place

dive_data_clean <- dive_data |> 
  mutate(
    area = case_when(        # area: the island or city of the dive. defining by case when true for each. 
      str_detect(location, "STX|Buck") ~ "St. Croix",   # within location detecting STX or Buck, change to St. Croix 
      str_detect(location, "Viti") ~ "Viti Levu",       # within location detecting Viti and assigning area
      str_detect(location, "Taveuni") ~ "Taveuni",      # similar process through Dania   
      str_detect(location, "Bimini") ~ "Bimini",       
      str_detect(location, "Biscayne") ~ "Key Biscayne",
      str_detect(location, "Miami") ~ "Miami",
      str_detect(location, "Dania Beach") ~ "Dania Beach"),
    # creating region from above created area. using same logic. 
    region = case_when(   
      area == "St. Croix" ~ "USVI",    
      area == "Viti Levu" | area == "Taveuni" ~ "Fiji",
      area == "Bimini" ~ "Bahamas",
      area == "Key Biscayne" | area == "Miami" | area == "Dania Beach" ~ "South Florida"),
    # site: specific dive sites, smalledst geographical area. using same case when str_detect methodology 
    site = case_when(
      str_detect(location, "Buck Island") ~ "Buck Island",
      str_detect(location, "F'sted") ~ "Frederiksted Pier",
      str_detect(location, "Cane Bay|North Star") ~ "Cane Bay",
      str_detect(location, "Lang Bank") ~ "Lang Bank",
      str_detect(location, "Point Udall") ~ "Point Udall",
      str_detect(location, "Jack") ~ "Jack and Isaac's Bay",
      area == "St. Croix" ~ str_remove(location, ", STX.*"),  # for all other STX sites drop the "STX" and ending
      TRUE ~ area)) |>                                       # for all other locations, site = area
  select(-location) |>                                       # location dropped since = replaced by area/region/site
  as_tibble()                                               

## Check new tibble to ensure no NAs

sum(is.na(dive_data_clean$area))     
sum(is.na(dive_data_clean$region))   
sum(is.na(dive_data_clean$site))

dive_data_clean |> count(region, area, site)  # inspect counts

colnames(dive_data_clean) 
str(dive_data_clean)
dim(dive_data_clean)              


# EXPORT #######################################################################

write_rds(x = dive_data_clean, 
          file = "data/processed/dive_data_clean.rds")