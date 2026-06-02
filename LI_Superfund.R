# LI_Superfund.R
# Load the Long Island Superfund tract dataset (665 tracts; Nassau + Suffolk),
# give the truncated EJScreen / Superfund shapefile fields readable names, and
# export a cleaned GeoPackage. See README.md for the full data dictionary.

library(dplyr)
library(sf)
library(here)

# 1. Load the primary tract shapefile (path is project-relative via here())
superfund <- st_read(here("LI_Tracts_Final", "LI_Tracts_Final.shp"))

# 2. Map truncated shapefile field names -> readable names
rename_map <- c(
  # identifiers
  geoid = "ID", state = "ST_ABBREV", county = "CNTY_NAME",
  # ACS population denominators
  pop_total = "ACSTOTPOP", pop_poverty_base = "ACSIPOVBAS", pop_edu_base = "ACSEDUCBAS",
  households_total = "ACSTOTHH", housing_units_total = "ACSTOTHU", labor_force_base = "ACSUNEMPBA",
  # EJScreen demographic indicators
  demo_index = "DEMOGIDX_2", demo_index_supp = "DEMOGIDX_5",
  poc_count = "PEOPCOLOR", poc_pct = "PEOPCOLORP",
  lowincome_count = "LOWINCOME", lowincome_pct = "LOWINCPCT",
  unemployed_count = "UNEMPLOYED", unemployed_pct = "UNEMPPCT",
  lingiso_count = "LINGISO", lingiso_pct = "LINGISOPCT",
  less_hs_count = "LESSHS", less_hs_pct = "LESSHSPCT",
  under5_count = "UNDER5", under5_pct = "UNDER5PCT",
  over64_count = "OVER64", over64_pct = "OVER64PCT",
  low_life_exp_pct = "LIFEEXPPCT",
  # EJScreen environmental indicators
  pm25 = "PM25", ozone = "OZONE", diesel_pm = "DSLPM",
  air_toxics_cancer = "CANCER", air_toxics_resp = "RESP", rsei_air = "RSEI_AIR",
  traffic_proximity = "PTRAF", pre1960_count = "PRE1960", pre1960_pct = "PRE1960PCT",
  npl_proximity = "PNPL", rmp_proximity = "PRMP", tsdf_proximity = "PTSDF",
  ust_proximity = "UST", wastewater_discharge = "PWDIS", env_burden_index = "EnvBurden_",
  area_land = "AREALAND", area_water = "AREAWATER",
  # Superfund / TSDF site counts within tract
  npl_count_ej = "NPL_CNT_EJ", tsdf_count_ej = "TSDF_CNT_E",
  npl_count = "NPL_Bounda", state_sf_count = "SF02_Bound", all_sf_count = "ALLSF_Boun",
  # race / ethnicity (%)
  pct_nh_white = "PCT_NHWHIT", pct_black = "PCT_BLACK", pct_asian = "PCT_ASIAN",
  pct_other = "PCT_OTHER", pct_hispanic = "PCT_HISPLA",
  # mean distance to sites (m), plus ArcGIS class-id / class-label artifacts
  npl_meandist_m = "MEANDIST_N", npl_distclass = "MEANDIST_1", npl_distclass_lbl = "MEANDIST_2",
  state_sf_meandist_m = "MEANDIST_S", state_sf_distclass = "MEANDIST_3", state_sf_distclass_lbl = "MEANDIST_4",
  all_sf_meandist_m = "MEANDIST_5", all_sf_distclass = "MEANDIST_6", all_sf_distclass_lbl = "MEANDIST_7",
  # distance to nearest site boundary (m)
  npl_dist_nearest_m = "NPL_Bound_", all_sf_dist_nearest_m = "ALLSD_Boun", state_sf_dist_nearest_m = "SF02_Bou_1",
  # Area Deprivation Index
  adi_national_pct = "MEDIAN_ADI", adi_state_decile = "MEDIAN_A_1"
)

superfund <- rename(superfund, any_of(rename_map))

# 3. Export the cleaned layer as a GeoPackage
out <- here("LI_Superfund.gpkg")
st_write(superfund, out, layer = "li_superfund", delete_dsn = TRUE)
cat("Wrote", out, "-", nrow(superfund), "features,", ncol(superfund) - 1, "attributes\n")
