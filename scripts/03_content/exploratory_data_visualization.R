################################################################################
# Data exploration and visualization
################################################################################
#
# Emerson Dresser
# ebd63@miami.edu
# 10/11/2026
#
# Script contains initial visualization of data uisng basic ggplots 
#
################################################################################


# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)

## Load data -------------------------------------------------------------------

dive_data <- read_rds( file = "data/processed/dive_data_clean.rds")

# VISUALIZE ####################################################################

## Build a plot ----------------------------------------------------------------

######### Looking at experience over time and dive locations #######
dive_hours <- ggplot(dive_data,
                     aes(x = date, 
                         y = total_dive_hours))+
                       geom_line(na.rm = TRUE, 
                                 linewidth = 1.05) + 
  labs(x = "Date",
       y = " Total Dive Hours",
       title = "Cumulative Dive Time",
       caption = "dresser_dive_log.csv")+
  theme_bw()

dive_hours



count_per_site <- ggplot(dive_data,
       aes(x = region, 
           fill = region))+
         geom_bar()+
  labs(x = "Dive Area",
       y = "Number of Dives",
       title = "Dives per Site",
       fill = "Dive Location",
       caption = "dresser_dive_log.csv")+
  theme_bw()

count_per_site

### Depth ### 


depth_per_site <- 
    ggplot(dive_data, aes(x = max_depth, fill = region)) +
  geom_histogram(binwidth = 10) +
  facet_wrap(~region, scales = "free_y") + 
  labs( x = "Max Depth",
        y = "Number of Dives",
        title = "Depth by Site",
        caption = "dresser_dive_log.csv")+
  theme_bw()

depth_per_site


### Air Consumption ###
air_v_depth <- ggplot(dive_data, 
                      aes(x = dive_min, 
                          y = air_consumed, 
                          color = max_depth)) +
  geom_point(size = 2, na.rm = TRUE)+
  scale_color_viridis_c(option = "mako", 
                        direction = -1, 
                        name = "Max Depth (ft)") +
  labs(x = "Dive Time (min)",
       y = "Air Consumed (PSI)",
       title = "Air Consumed by Dive Depth and Time",
       caption = "dresser_dive_log.csv")+
  theme_bw()

air_v_depth  


# EXPORT #######################################################################

## Export Cumulative Dive Time to Date ------------------------------------------
ggsave(plot = dive_hours,
       filename = "results/img/dive_hours.png",
       width = 10,
       height = 8)


## Export the Dive per Site Plot ----------------------------------------------

ggsave(plot = count_per_site,
       filename = "results/img/count_per_site.png",
       width = 10,
       height = 8)


## Export the Depth by Site Plot ----------------------------------------------

ggsave(plot = depth_per_site,
       filename = "results/img/depth_per_site.png",
       width = 10,
       height = 8)

## Export the Air consumed by Depth and Time Plot ------------------------------

ggsave(plot = air_v_depth,
       filename = "results/img/air_v_depth.png",
       width = 10,
       height = 8)

