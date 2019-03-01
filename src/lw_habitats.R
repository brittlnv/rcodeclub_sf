library(sf)
library(tidyverse)
library(ggplot2)

# read monitoring stations from CSV and transform to simple features with coordinates in WGS84
lwstations <- st_read("./data/lfmonitoringstationsPoint.csv",stringsAsFactors=FALSE)
lwstations_spatial <- st_as_sf(lwstations, coords = c("lon","lat"), crs=4326)

#read habitat shapefile, plot and check coordinate reference system
habitats <- st_read("./data/broadscalehabitatmap_200m")
plot(habitats)
st_crs(habitats)

#read EEZ shapefile, plot and check coordinate reference system
eez_be <- st_read("./data/eez_be")
plot(eez_be)
st_crs(eez_be)

#transform habitats data to same CRS as eez_be
habitats_wgs84 <- st_transform(habitats,crs=4326)
st_crs(habitats_wgs84)

#intersect habitats with eez so that only habitats within Belgian EEZ remain (+plot)
habitats_be <- st_intersection(eez_be,habitats_wgs84)
plot(habitats_be)

#intersect Belgian habitats with LifeWatch stations to see to which habitats the stations belong (+ create new df)
lwstations_habitats <- st_intersection(habitats_be,lwstations_spatial)
lwstations_hab <- data.frame(lwstations_habitats$code, lwstations_habitats$msfd_bh17, lwstations_habitats$geometry)
lwstations_hab

#plot results on map
ggplot(lwstations_hab) +
  geom_sf(aes(colour = lwstations_hab$msfd_bh17)) +
  geom_sf_label(aes(label=lwstations_hab$code))


