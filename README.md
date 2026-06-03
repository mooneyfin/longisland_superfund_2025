# Demographic inequities and cumulative environmental burdens within communities near superfund sites on Long Island, New York

Data and cleaning code for Mooney et al. (2025), *Health & Place*.

**Author:** Fintan A. Mooney ([@mooneyfin](https://github.com/mooneyfin))
**Last updated:** 2026-06-02

## Overview

This repository holds the tract-level data and cleaning code for 

> Mooney, F. A., Kelly, J. R., Warren, J. L., & Deziel, N. C. (2025). Demographic inequities and
> cumulative environmental burdens within communities near superfund sites on Long Island, New York.
> *Health & Place, 91,* 103409. https://doi.org/10.1016/j.healthplace.2024.103409

The study links socio-demographic and environmental characteristics of **665 census
tracts** to the number of **Federal (NPL)** and **New York State** Superfund sites per tract using
hierarchical Bayesian spatial Poisson regression, with analyses stratified by county and by site
type (Federal vs. state).

In brief, tracts with higher proportions of low-income and Hispanic/Latino residents, higher
PM2.5, higher toxic air releases, and closer proximity to underground gas storage tanks tended to
contain more Superfund sites; low-income residents were concentrated around state (rather than
federal) sites, with several disparities specific to Suffolk County. See the paper for full results.

## Data sources

*Access dates indicate when each dataset was downloaded for this analysis.*

- **U.S. EPA EJScreen** — tract-level demographic indicators, population denominators, and environmental burden indicators (national geodatabase **accessed 2024-07-16**).
- **U.S. EPA National Priorities List (NPL)** — federal Superfund site locations/boundaries (NPL boundaries **accessed 2024-07-16**; federal Superfund sites **accessed 2024-08-21**).
- **NY State DEC Environmental Remediation Database** ("remediation site borders") — State Superfund, Brownfield Cleanup, Voluntary Cleanup, Environmental Restoration, RCRA, and Petroleum Remediation site boundaries (**accessed 2024-07-16**).
- **Area Deprivation Index** (Neighborhood Atlas, University of Wisconsin) — national percentile and state decile.
- **U.S. Census Bureau** — TIGER/Line 2020 tract geographies (**accessed 2024-07-19**) and ACS population denominators.

> The Long Island extracts used by the analysis are included under `01_data/`. The full
> files (EJScreen national geodatabase, NPL boundary geodatabase, NY State Superfunds) are not in this repository; they can be downloaded from here:
- **EJScreen**: [
EJScreen](https://experience.arcgis.com/experience/e7cd788e274c45eeb313a94da849e7fe)
- **EPA National Piority List Superfund Sites**: [Federal Superfund Sites](https://www.arcgis.com/home/item.html?id=d6e1591d9a424f1fa6d95a02095a06d7)
- **NY State DEC Environmental Remediation Database**: [State Superfund Sites](https://nam02.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdec.ny.gov%2Fenvironmental-protection%2Fsite-cleanup%2Fdatabase-search%2Fremediation-site-boundaries-downloadable-gis-files&data=05%7C02%7Cfm2873%40cumc.columbia.edu%7Cd0c925a948d34feeb49e08dec0c331e4%7Cb0002a9b0017404d97dc3d3bab09be81%7C0%7C0%7C639160142817064583%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=BJrc4GPoH5LlVoGRZQX3RKScqOqLoRGa4l6sBusKJaE%3D&reserved=0)
  

## Repository contents

```
longisland_superfund_2025/
├── 01_data/
│   ├── li_tracts/                 # Primary analytic layer — 665 census tracts (Nassau + Suffolk)
│   ├── ejscreen_li/               # EJScreen Long Island extract (shapefile + CSV)
│   ├── federal_superfund/         # Federal (NPL) Superfund sites
│   ├── state_superfund/           # NY State Superfund sites
│   ├── remediation_site_borders/  # NY State DEC remediation site boundaries
│   └── tract_boundary/            # Long Island tract boundary
├── 02_code/
│   ├── LI_Superfund.R             # Clean the tract layer → readable names → GeoPackage
│   ├── More_Maps.Rmd              # Superfund maps
│   ├── Lplot.R                    # Ripley's K/L spatial-clustering plots
│   └── Tables.R                   # Summary tables
├── 03_output/
│   ├── LI_Superfund.gpkg          # Cleaned tract layer (readable column names)
│   ├── More_Maps.html             # Rendered maps (+ More_Maps_files/)
│   └── figures/                   # Exported figures (e.g. LPlot_Federal.png)
├── longisland_superfund_2025.Rproj
└── README.md
```

## Data dictionary

Primary spatial dataframe for modeling: 'LI_Superfund.gpkg'

### Identifiers
| Variable | Source field | Description |
|---|---|---|
| `geoid` | `ID` | Census tract GEOID (state + county + tract FIPS) |
| `state` | `ST_ABBREV` | State abbreviation |
| `county` | `CNTY_NAME` | County name |

### Population denominators (ACS)
| Variable | Source field | Description |
|---|---|---|
| `pop_total` | `ACSTOTPOP` | Total population |
| `pop_poverty_base` | `ACSIPOVBAS` | Population with determined poverty status |
| `pop_edu_base` | `ACSEDUCBAS` | Population age 25+ (education denominator) |
| `households_total` | `ACSTOTHH` | Total households |
| `housing_units_total` | `ACSTOTHU` | Total housing units |
| `labor_force_base` | `ACSUNEMPBA` | Civilian labor force (unemployment denominator) |

### Demographic indicators (EJScreen)
| Variable | Source field | Description |
|---|---|---|
| `demo_index` / `demo_index_supp` | `DEMOGIDX_2` / `DEMOGIDX_5` | Demographic Index and Supplemental (5-factor) Demographic Index |
| `poc_count` / `poc_pct` | `PEOPCOLOR` / `PEOPCOLORP` | People of color |
| `lowincome_count` / `lowincome_pct` | `LOWINCOME` / `LOWINCPCT` | Low income |
| `unemployed_count` / `unemployed_pct` | `UNEMPLOYED` / `UNEMPPCT` | Unemployed |
| `lingiso_count` / `lingiso_pct` | `LINGISO` / `LINGISOPCT` | Limited English-speaking (linguistically isolated) households |
| `less_hs_count` / `less_hs_pct` | `LESSHS` / `LESSHSPCT` | Less than high school education |
| `under5_count` / `under5_pct` | `UNDER5` / `UNDER5PCT` | Population under age 5 |
| `over64_count` / `over64_pct` | `OVER64` / `OVER64PCT` | Population over age 64 |
| `low_life_exp_pct` | `LIFEEXPPCT` | Low life expectancy (%) |

### Environmental indicators (EJScreen)
| Variable | Source field | Description |
|---|---|---|
| `pm25` | `PM25` | Annual PM2.5 (µg/m³) |
| `ozone` | `OZONE` | Ozone (ppb) |
| `diesel_pm` | `DSLPM` | Diesel particulate matter (µg/m³) |
| `air_toxics_cancer` | `CANCER` | Air toxics cancer risk (per million) |
| `air_toxics_resp` | `RESP` | Air toxics respiratory hazard index |
| `rsei_air` | `RSEI_AIR` | RSEI modeled air toxics concentration |
| `traffic_proximity` | `PTRAF` | Traffic proximity and volume |
| `pre1960_count` / `pre1960_pct` | `PRE1960` / `PRE1960PCT` | Pre-1960 housing (lead paint indicator) |
| `npl_proximity` | `PNPL` | Proximity to NPL sites |
| `rmp_proximity` | `PRMP` | Proximity to RMP facilities |
| `tsdf_proximity` | `PTSDF` | Proximity to TSDF facilities |
| `ust_proximity` | `UST` | Underground storage tanks (proximity) |
| `wastewater_discharge` | `PWDIS` | Wastewater discharge indicator |
| `env_burden_index` | `EnvBurden_` | Cumulative environmental burden index |
| `area_land` / `area_water` | `AREALAND` / `AREAWATER` | Land / water area (m²) |

### Race & ethnicity (%)
| Variable | Source field | Description |
|---|---|---|
| `pct_nh_white` | `PCT_NHWHIT` | Non-Hispanic White |
| `pct_black` | `PCT_BLACK` | Black |
| `pct_asian` | `PCT_ASIAN` | Asian |
| `pct_other` | `PCT_OTHER` | Other |
| `pct_hispanic` | `PCT_HISPLA` | Hispanic / Latino |

### Superfund site measures
Counts of Superfund sites per tract are the modeled outcome. For three categories — **federal NPL**,
**NY State Superfund**, and **all Superfund sites (federal + state)** — the data provide a
within-tract count, a mean distance, and a distance to the nearest site boundary:

| Variable | Source field | Description |
|---|---|---|
| `npl_count` | `NPL_Bounda` | NPL sites within the tract (count) |
| `npl_meandist_m` | `MEANDIST_N` | Mean distance to NPL sites (m) |
| `npl_dist_nearest_m` | `NPL_Bound_` | Distance to nearest NPL site boundary (m) |
| `state_sf_count` | `SF02_Bound` | State Superfund sites within the tract (count) |
| `state_sf_meandist_m` | `MEANDIST_S` | Mean distance to State Superfund sites (m) |
| `state_sf_dist_nearest_m` | `SF02_Bou_1` | Distance to nearest State Superfund boundary (m) |
| `all_sf_count` | `ALLSF_Boun` | All Superfund sites within the tract (count) |
| `all_sf_meandist_m` | `MEANDIST_5` | Mean distance to all Superfund sites (m) |
| `all_sf_dist_nearest_m` | `ALLSD_Boun` | Distance to nearest Superfund site boundary (m) |
| `npl_count_ej` | `NPL_CNT_EJ` | NPL site count (EJScreen) |
| `tsdf_count_ej` | `TSDF_CNT_E` | Hazardous-waste (TSDF) count (EJScreen) |

> **Note:** In the raw shapefile, the `MEANDIST_*` block also contains six ArcGIS symbology
> artifacts — `MEANDIST_1`/`_3`/`_6` (class id, 1–10) and `MEANDIST_2`/`_4`/`_7` (class-range
> label strings) — that are redundant with the continuous distances and can be dropped.

### Area Deprivation Index
| Variable | Source field | Description |
|---|---|---|
| `adi_national_pct` | `MEDIAN_ADI` | Median ADI, national percentile (0 = missing) |
| `adi_state_decile` | `MEDIAN_A_1` | Median ADI, NY state decile (0 = missing) |

## Coordinate reference system

NAD83(2011) / New York Long Island State Plane (meters).


## The published article

> Mooney, F. A., Kelly, J. R., Warren, J. L., & Deziel, N. C. (2025). Demographic inequities and
> cumulative environmental burdens within communities near superfund sites on Long Island, New York.
> *Health & Place, 91,* 103409. https://doi.org/10.1016/j.healthplace.2024.103409



## Contact

Corresponding author: **Nicole C. Deziel**, Yale School of Public Health — Nicole.deziel@yale.edu
Repository maintainer: **Fintan A. Mooney** ([@mooneyfin](https://github.com/mooneyfin))
