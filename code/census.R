## Install the tidycensus package if you haven't yet
#install.packages("tidycensus")

library(tidycensus)
library(ggplot2)
library(sf)
library(dplyr)
library(mapview)
library(readr)
## setup cenus api key
## signup your census api key at http://api.census.gov/data/key_signup.html
census_api_key("9b78398754bf802f69e757bbff922ac185c8d42f") # 
portland_tract_medhhinc <- get_acs(geography = "tract", 
                                   year = 2016, # 2012-2016
                                   variables = "B19013_001",  # Median Household Income in the Past 12 Months
                                   state = "OR", 
                                   county = c("Multnomah County", "Washington County", "Clackamas County"),
                                   geometry = TRUE) # load geometry/gis info

(myplot <- ggplot(portland_tract_medhhinc) + 
    geom_sf(aes(fill = estimate)) +
    coord_sf(datum = NA) + theme_minimal())

ggsave("output/mymap.pdf", myplot)

mapview(portland_tract_medhhinc %>% select(estimate), 
        col.regions = sf.colors(10), alpha = 0.1)

# SPATIAL JOIN

# read 1994 Metro TAZ shape file
taz_sf <- st_read("data/taz1260.shp", crs=2913)

# read geocode.raw file that contains X and Y coordinates
portland94_df <- read_csv("data/portland94_geocode.raw.zip", col_names=c("uid", "X", "Y", "case_id", 
                                                                         "freq", "rtz", "sid", 
                                                                         "totemp94", "retemp94"))

portland94_df <- portland94_df %>% 
  filter(X!=0, Y!=0) %>% 
  sample_n(500)

# create a point geometry with x and y coordinates in the data frame
portland94_sf <- st_as_sf(portland94_df, coords = c("X", "Y"), crs = 2913)

# spatial join to get TAZ for observations in portland94_sf
portland94_sf <- st_join(portland94_sf, taz_sf)
head(portland94_sf)

ggplot() +
  geom_sf(data = taz_sf, aes(alpha=0.9)) +
  geom_sf(data = portland94_sf)

test <- get_acs(geography = "tract", 
                year = 2016, # 2012-2016
                output = 
                  table = c("B01001", "B03002"),
                state = "OR", 
                county = c("Multnomah County", "Washington County", "Clackamas County"),
                geometry = TRUE) # load geometry/gis info
