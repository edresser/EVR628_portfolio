################################################################################
# Spatial Visualization
################################################################################
#
# Emerson Dresser
# ebd63@miami.edu
# 11/15/2026
#
# Using Dive log data and approximate dive locations/areas to create a general heat 
# map of dives by general site within each area and region. Fiji left out due to small
# number of dives and geographic distance from the other dives.
#
################################################################################


# SET UP #######################################################################

## Load packages ---------------------------------------------------------------

library(tidyverse)       
library(sf)              
library(rnaturalearth)   
library(tigris)         
library(ggspatial)       

## Load data -------------------------------------------------------------------

dive_data_clean <- read_rds("data/processed/dive_data_clean.rds")

# PROCESSING ###################################################################


## Count Dives per site  -------------------------------------------------------

site_counts <- dive_data_clean |> 
  group_by(area, region, site) |>     # one row per site
  summarize(n_dives = n(),            # number of dives at each site
            .groups = "drop") |> 
  arrange(desc(n_dives))            # Descending order


## Site coordinates ------------------------------------------------------------

# Approximate locations in decimal degrees using google maps

site_coordinates <- tibble(
  site = c("Buck Island", 
           "Frederiksted Pier",
           "Cane Bay",
           "Salt River",
           "Lang Bank",
           "Point Udall",
           "Jack and Isaac's Bay",
           "Butler Bay",
           "Carambola Beach Resort",
           "South Shore",
           "Armageddon",
           "Key Biscayne",
           "Miami",
           "Dania Beach",
           "Bimini",
           "Taveuni",
           "Viti Levu"),
  lon = c(-64.610314, 
          -64.885447, 
          -64.812385, 
          -64.755004, 
          -64.454480, 
          -64.565932, 
          -64.576075, 
          -64.891858, 
          -64.832808, 
          -64.598159, 
          -64.90311, 
          -80.160661, 
          -80.130715, 
          -80.166567, 
          -79.270934, 
          179.925255, 
          178.026296),
  lat = c(17.787491, 
          17.714185, 
          17.7741528, 
          17.786110, 
          17.820305, 
          17.760372, 
          17.744718, 
          17.750118, 
          17.763103, 
          17.742091, 
          17.75534, 
          25.731828, 
          25.761035, 
          26.059663, 
          25.691532, 
          -16.784769, 
          -18.297031))

## Join coords and count by site into one object -----------------------------

dive_data_coord <- site_counts |> 
  left_join(site_coordinates, by = "site") |> 
  st_as_sf(coords = c("lon", "lat"), crs = 4326)   # creating SF obj and defining CRS


## Split data into 2 primary regions for mapping -------------------------------
# Fiji (6 dives) are not mapped. 

stx_sites <- dive_data_coord |> 
  filter(region == "USVI")

fl_bim_sites <- dive_data_coord |> 
  filter(region =="South Florida" | region == "Bahamas")

## Creating base layers for two maps -------------------------------------------

## using U.S. census data from tigris package to map USVI and FL due to higher level of detail 

stx_land <- counties(state = "VI", cb = TRUE) |> ## cb = TRUE defines scale in tigris::counties
  st_transform(4326)   # same CRS as dive sites 

fl_land <- states(cb = TRUE) |> 
  filter(NAME == "Florida") |> 
  st_transform(4326)

# Natural Earth package for Bahamas mapping informaiton 
bahamas_land <- ne_countries(scale = "large") |> # scale for highest level of detail
  filter(name == "Bahamas")     

## STX Map ---------------------------------------------------------------------

stx_map <- ggplot() +
  geom_sf(data = stx_land, fill = "gray85", color = "gray40") +    # Add St. Croix land base layer
  geom_sf(data = arrange(stx_sites, desc(n_dives)),             # Add dive sites as circles sized by number of dives
          aes(size = n_dives),
          shape = 21, fill = "steelblue", alpha = 0.7) +
  geom_sf_text(data = filter(stx_sites, n_dives >= 4),               # Labeling site with more than 4 dives 
               aes(label = site), nudge_x = -0.01, nudge_y = 0.025, size = 4) +
  geom_sf_text(data = filter(stx_land, NAME == "St. Croix"),                           # Labeling island
               aes(label = NAME), fontface = "italic", size = 3, color = "gray30") +
  scale_size_area(max_size = 12,                                                      # Set bubble sizes/steps. keeping minimally busy legend.
                  breaks = c(1, 10, 30, max(stx_sites$n_dives)),
                  name = "Number of Dives") +
  annotation_north_arrow(location = "tl") +                # Add a north arrow
  annotation_scale(location = "br") +                        # Add a scale bar from ggspatial
  coord_sf(xlim = c(-65.0, -64.4), ylim = c(17.55, 17.95)) +          # crop to St. Croix    
  theme_bw() +                                                      # simple black/white theme
  theme(plot.title = element_text(hjust = 0.5)) +                  # center the title
  labs(x = "Longitude (degrees)",                                                # Make labels
       y = "Latitude (degrees)",
       title = "St. Croix Dive Locations",
       caption = "Data sources: dresser_dive_log.csv (personal dive log), US Census Bureau (tigris)")

stx_map

## FL and Bimini Map -----------------------------------------------------------

fl_bim_map <- ggplot() +
  geom_sf(data = fl_land, fill = "gray85", color = "gray40") +          # Add Florida base layer 
  geom_sf(data = bahamas_land, fill = "gray85", color = "gray40") +     # Add Bahamas base layer
  geom_sf(data = arrange(fl_bim_sites, desc(n_dives)),                  # Dive sites as circles sized by number of dives
          aes(size = n_dives),
          shape = 21, fill = "steelblue", alpha = 0.8) +
  geom_sf_text(data = fl_bim_sites,                                     # Label every site, nudged so East (right) so labels aren't on land
               aes(label = site), nudge_x = 0.25, size = 4) +
  scale_size_area(max_size = 10,                                        # Set bubble sizes/steps
                  limits = c(0, max(fl_bim_sites$n_dives)),
                  breaks = c(1, 5, 10, max(fl_bim_sites$n_dives)),
                  name = "Number of Dives") +
  annotation_north_arrow(location = "tl") +                            # North arrow from ggspatial
  annotation_scale(location = "br") +                                  # Scale bar also from ggspatial
  coord_sf(xlim = c(-80.6, -78.8), ylim = c(25.3, 26.4)) +             # Crop to South Florida and Bimini
  theme_bw() +                                                         # Theme set
  theme(plot.title = element_text(hjust = 0.5)) +                      # Center title
  labs(x = "Longitude (degrees)",                                                # Make labels
       y = "Latitude (degrees)",
       title = "South Florida and Bimini Dive Locations",
       caption = "Data sources: dresser_dive_log.csv (personal dive log), US Census Bureau (tigris), Natural Earth.")

fl_bim_map



# EXPORT ####################################################################### 

## Export STX Dive Map ----------------------------------------------------

ggsave(plot = stx_map, 
       filename = "results/img/st_croix_dive_sites.png",
       width = 10, 
       height = 8,
       dpi = 300)

## Export South Florida/Bimini Dive Map -------------------------------------

ggsave(plot = fl_bim_map, 
       filename = "results/img/florida_bimini_dive_sites.png",
       width = 10, 
       height = 8,
       dpi = 300)
