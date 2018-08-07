## Install the tidycensus package if you haven't yet
#install.packages("tidycensus")

library(tidycensus)
library(ggplot2)
library(sf)
library(dplyr)
library(mapview)
## setup cenus api key
## signup your census api key at http://api.census.gov/data/key_signup.html
census_api_key("9b78398754bf802f69e757bbff922ac185c8d42f") # 
acs <- get_acs(geography = "tract", 
               year = 2016, # 2012-2016
               output = "wide",
               table = c("B01001", "B03002"),  # Median Household Income in the Past 12 Months
               state = "OR", 
               county = c("Multnomah County", "Washington County", "Clackamas County"),
               geometry = TRUE) # load geometry/gis info

(myplot <- ggplot(portland_tract_medhhinc) + 
    geom_sf(aes(fill = estimate)) +
    coord_sf(datum = NA) + theme_minimal())

ggsave("output/mymap.pdf", myplot)

mapview(portland_tract_medhhinc %>% select(estimate), 
        col.regions = sf.colors(10), alpha = 0.1)
