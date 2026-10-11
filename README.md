# My repo for EVR 628

## Author

Emerson Dresser


## Description

Portfolio for EVR 628 Data Management and Visualization

## Project

The objective of this project is to clean the data in my personal dive log and use it to understand how I have progressed as a diver, which variables affect my diving
ability, and how my proficiency and efficiency have changed over time. The log starts with the dives from my initial open water certification in 2021 and continues
through advanced open water, NPS Blue Card, AAUS, and current Divemaster training in 2026.

## Repository Structure

-`data/`:

  -`data/raw` contains the `dresser_dive_log.csv` file and `dive_locations.csv` file as imported from my personal computer
  
  -`data/processed` contains a single cleaned version of my data `clean_dive_log.rds`
  
- `scripts/`: R scripts for analysis
  - `scripts/01_processing` contains a single script that reads the raw data from both files, cleans them, and exports the processed data
  - `scripts/02_analyses` contains a script that reads in the cleaned data and conducts exploratory visualization
  - `scripts/03_contents` contains a single script that builds the final plots and figures 
- `results/`: Contains a folder with images of plots from the data visualization and analysis 

  ## About the Data
  - 
