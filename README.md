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

- `data/`:
  - `data/raw` contains the `dresser_dive_log.csv` file and `dive_locations.csv` file as imported from my personal computer
  - `data/processed` contains a single cleaned version of my data `clean_dive_log.rds`
  
- `scripts/`: R scripts for analysis
  - `scripts/01_processing` contains a single script that reads the raw data from both files, cleans them, and exports the processed data
  - `scripts/02_analyses` contains a script that reads in the cleaned data and conducts exploratory visualization
  - `scripts/03_contents` contains a single script that builds the final plots and figures

- `results/`: Contains a folder with images of plots from the data visualization and analysis

  -`results/img/dive_hours.png` shows a line graph of my cumulative dive time to date 
  -`results/img/count_per_region.png` shows a bar plot of total dives per region
  -`results/img/depth_by_site.png` shows a histogram of max depths by site
  -`results/img/air_v_depth.png` shows a scatter plot of Air Consumed by Dive Time and Depth

  ## About the Data
- `data/processed/dive_data_clean.rds` contains 145 rows and 17 columns:

  - `dive_number` - Integer - Sequential number of each dive in the log
  - `date` - Date - Date of the dive
  - `dive_min` - Numeric - Length of the dive in minutes
  - `total_dive_hours` - Numeric - Running total of hours underwater through that dive
  - `max_depth` - Numeric - Maximum depth in feet
  - `surface_temp` - Numeric - Surface water temperature, in degrees Fahrenheit (`NA` if not recorded)
  - `bottom_temp` - Numeric - Bottom water temperature, in degrees Fahrenheit (`NA` if not recorded)
  - `air_in` - Integer - Tank pressure at the start of the dive, in PSI (`NA` if not recorded)
  - `air_out` - Integer - Tank pressure at the end of the dive, in PSI (`NA` if not recorded)
  - `weight` - Numeric - Weight worn, in pounds (`0` means no weight)
  - `wetsuit_type` - Character - Exposure protection worn: `"none"`, `"4/3mm"`, or `"5mm"`
  - `o2_fraction` - Numeric - Fraction of oxygen in the breathing gas (`0.21` for air, anything above `0.21` is nitrox)
  - `air_consumed` - Integer - Air used during the dive in PSI (`air_in` - `air_out`)
  - `psi_per_min` - Numeric - Air used per minute in PSI (`air_consumed` / `dive_min`)
  - `temp_diff` - Numeric - Surface minus bottom temperature in degrees Fahrenheit (`surface_temp` - `bottom_temp`)
  - `area` - Character - Where the dive took place: `"St. Croix"`, `"Viti Levu"`, `"Taveuni"`, `"Bimini"`, `"Miami"`, or `"Dania Beach"`
  - `region` - Character - Larger grouping of `area` to encompass countries, states, territories: `"USVI"`, `"Fiji"`, `"Bahamas"`, or `"Florida"`
