library(dplyr)
library(sf)

superfund <- st_read("LI_Tracts_Final/LI_Tracts_Final.shp")
colnames(superfund)
