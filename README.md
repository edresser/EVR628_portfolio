# A Personal Dive Log Analysis

## Emerson Dresser

This project uses my personal dive log data to analyze and visualize trends over the past five years. The objective is to clean the data I have logged over time and then use it to understand how I have progressed. The log starts in 2021, with the beginning of my dive career and ends in 2026 after receiving an AAUS authorization. 

## Data Sources

#### Raw Datasets:
### `data/raw/dresser_dive_log.csv` 
- **Title of the dataset:** E Dresser Dive Log
- **Source:** Directly downloaded from my personal computer 

## Repository Structure and Contents

- `data`: Contains the raw and processed data:
  - `data/raw/dresser_dive_log.csv`: Raw personal dive log data
  - `data/processed/dive_data_clean.rds` clean dive log data
  
- `scripts`: R scripts for analysis
  - `scripts/01_processing/data_processeing.R`: This file reads the raw data, cleans and standardizes columns names, groups the dive locations into area, region, and site, and exports the processed data as `dive_data_clean.rds 
  - `scripts/03_content/exploratory_data_visualization.R`: This file reads `dive_data_clean.rds` builds four plots and exports them to `results/img` as `dive_hours.png`, `count_per_region.png`, `depth_per_region.png`, and `air_v_cepth.png.
  - `scripts/03_content/spatial_data_visualizaton.R`: This file reads `dive_data_clean.rds` and builds two maps exported in `results/img` as `florida_bimini_dive_sites.png` and `st_croix_dive_sites.png`

- `results`: Contains a folder with images of plots from the data visualization and analysis

  - `results/img/dive_hours.png` shows a line graph of my cumulative dive time to date produced by `exploratory_data_visualization.R`
  - `results/img/count_per_region.png` shows a barplot of total dives per region produced by `exploratory_data_visualization.R`
  - `results/img/depth_per_region.png` shows a histogram of max depths by region produced by `exploratory_data_visualization.R`
  - `results/img/air_v_depth.png` shows a scatter plot of Air Consumed by Dive Time and Depth produced by `exploratory_data_visualization.R` 
  -  `results/img/st_croix_dive_sites.png` shows a map of my St. Croix dives with circles sized by number of dives produced by `spatial_data_visualizaton.R`
  -  `results/img/florida_bimini_dive_sites.png` shows a map of my dives in South Florida and Bimini produced by `spatial_data_visualizaton.R`

  ## About the Data
- `data/processed/dive_data_clean.rds` contains 145 rows and 18 columns:

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
  - `area` - Character - Where the dive took place: `"St. Croix"`, `"Viti Levu"`, `"Taveuni"`, `"Bimini"`, `"Miami"`, `"Key Biscayne"` or `"Dania Beach"`
  - `region` - Character - Larger grouping of `area` to encompass countries, states, territories: `"USVI"`, `"Fiji"`, `"Bahamas"`, or `"South Florida"`
  - `site` - Character - Specific dive site, e.g. "Buck Island", "Cane Bay", or "Frederiksted Pier". For areas outside St. Croix the site is the same as area
