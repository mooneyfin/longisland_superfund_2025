# Load necessary packages
library(dplyr)
library(gtsummary)

# Define folder path and file name
folder_path <- "C:/Users/moone/OneDrive - Columbia University Irving Medical Center/MiscResearch/Superfund/Data/"
file_name <- "EJScreen_SF_LI.csv"
file_path <- paste0(folder_path, file_name)

# Import the CSV file
data <- read.csv(file_path)

# Define the columns to keep
columns_to_keep <- c("COUNTYFP","SFS_Count", "FSF_Count", "Threat", "EPA_FSF_Count", "White_PCT", "Black_PCT", 
                     "HISPLA_PCT", "Asian_PCT", "LOWINCPCT", "LINGISOPCT", "LESSHSPCT", 
                     "PRE1960PCT", "PM25", "OZONE", "NO2", "PWDIS", "PRMP", "PTRAF", "UST", "RSEI_AIR", 
                     "ACSTOTPOP", "TRACTCE", "DISABILITY", "DISABILITYPCT", "LIFEEXPPCT", "UNEMPPCT", "UNEMPLOYED", "PEOPCOLORPCT", "AREA")

# Subset the data to include only the specified columns
subset_data <- data[, columns_to_keep]

# Modify DISABILITYPCT by dividing values in DISABILITY by ACSTOTPOP
subset_data <- subset_data %>%
  mutate(DISABILITYPCT = (DISABILITY / ACSTOTPOP))

# Modify UNEMPPCT by dividing values in UNEMPLOYED by ACSTOTPOP
subset_data <- subset_data %>%
  mutate(UNEMPPCT = (UNEMPLOYED / ACSTOTPOP))

# Multiply columns with 'PCT' in their names by 100
subset_data <- subset_data %>%
  mutate(across(contains("PCT"), ~ . * 100))



# Create binary superfund column
subset_data <- subset_data %>%
  mutate(superfund = if_else(FSF_Count > 0 | SFS_Count > 0, 1, 0))

# Sum total population for Superfund and non-Superfund tracts, and for the overall dataset
total_population <- subset_data %>%
  summarize(
    Total_Population_Overall = sum(ACSTOTPOP, na.rm = TRUE),
    Total_Population_Superfund = sum(ACSTOTPOP[superfund == 1], na.rm = TRUE),
    Total_Population_NonSuperfund = sum(ACSTOTPOP[superfund == 0], na.rm = TRUE)
  )


# Calculate the 90th percentile for PRMP, PTRAF, UST, and PWDIS across all tracts
percentiles <- subset_data %>%
  summarize(
    PRMP_90th = quantile(PRMP, 0.9, na.rm = TRUE),
    PTRAF_90th = quantile(PTRAF, 0.9, na.rm = TRUE),
    UST_90th = quantile(UST, 0.9, na.rm = TRUE),
    PWDIS_90th = quantile(PWDIS, 0.9, na.rm = TRUE)
  )

# Add columns indicating if the values are above the 90th percentiles
subset_data <- subset_data %>%
  mutate(
    PRMP_Above_90th = if_else(PRMP > percentiles$PRMP_90th, 1, 0),
    PTRAF_Above_90th = if_else(PTRAF > percentiles$PTRAF_90th, 1, 0),
    UST_Above_90th = if_else(UST > percentiles$UST_90th, 1, 0),
    PWDIS_Above_90th = if_else(PWDIS > percentiles$PWDIS_90th, 1, 0),
  )

# Count how many tracts are above the 90th percentile for each variable within each Superfund category
counts_above_percentile <- subset_data %>%
  left_join(percentiles, by = character()) %>%  # Join without a key to add percentiles to all rows
  group_by(superfund) %>%
  summarize(
    PRMP_Above_90th = sum(PRMP >= PRMP_90th, na.rm = TRUE),
    PTRAF_Above_90th = sum(PTRAF >= PTRAF_90th, na.rm = TRUE),
    UST_Above_90th = sum(UST >= UST_90th, na.rm = TRUE),
    PWDIS_Above_90th = sum(PWDIS >= PWDIS_90th, na.rm = TRUE)
  )

# Print the counts above the 90th percentile for debugging
print(counts_above_percentile)

# Create a summary table by superfund status
summary_table_superfund <- subset_data %>%
  tbl_summary(by = superfund,
              type = all_continuous() ~ "continuous2",
              statistic = all_continuous() ~ c("{mean} ({sd})"),
              digits = all_continuous() ~ 1) %>%
              add_overall()

# Print the summary table
print(summary_table_superfund)

# Calculate the 90th percentile for PRMP, PTRAF, UST, and PWDIS across all tracts
percentiles <- subset_data %>%
  summarize(
    PRMP_90th = quantile(PRMP, 0.9, na.rm = TRUE),
    PTRAF_90th = quantile(PTRAF, 0.9, na.rm = TRUE),
    UST_90th = quantile(UST, 0.9, na.rm = TRUE),
    PWDIS_90th = quantile(PWDIS, 0.9, na.rm = TRUE)
  )

# Print the calculated 90th percentiles for debugging
print(percentiles)

# Add columns indicating if the values are above the 90th percentiles
subset_data <- subset_data %>%
  mutate(
    PRMP_Above_90th = if_else(PRMP > percentiles$PRMP_90th, 1, 0),
    PTRAF_Above_90th = if_else(PTRAF > percentiles$PTRAF_90th, 1, 0),
    UST_Above_90th = if_else(UST > percentiles$UST_90th, 1, 0),
    PWDIS_Above_90th = if_else(PWDIS > percentiles$PWDIS_90th, 1, 0)
  )

# Print a sample of the modified data to check the new columns
print(head(subset_data))

# Count how many tracts are above the 90th percentile for each variable within each Superfund category
counts_above_percentile <- subset_data %>%
  group_by(superfund) %>%
  summarize(
    PRMP_Above_90th = sum(PRMP_Above_90th, na.rm = TRUE),
    PTRAF_Above_90th = sum(PTRAF_Above_90th, na.rm = TRUE),
    UST_Above_90th = sum(UST_Above_90th, na.rm = TRUE),
    PWDIS_Above_90th = sum(PWDIS_Above_90th, na.rm = TRUE)
  )

# Print the counts above the 90th percentile for debugging
print(counts_above_percentile)

# Create a summary table by superfund status including the new columns
summary_table_superfund <- subset_data %>%
  tbl_summary(by = superfund,
              type = all_continuous() ~ "continuous2",
              statistic = all_continuous() ~ c("{mean} ({sd})"),
              digits = all_continuous() ~ 2,
              missing_text = "(Missing)") %>%
              add_overall()

# Print the summary table
print(summary_table_superfund)

# Create a subset for Nassau County (COUNTYFP = 103)
Nassau_Data <- subset(subset_data, COUNTYFP == 103)

# Sum total population for Superfund and non-Superfund tracts in Nassau, and for the overall dataset
Nassau_pop <- Nassau_Data %>%
  summarize(
    Total_Population_Overall = sum(ACSTOTPOP, na.rm = TRUE),
    Total_Population_Superfund = sum(ACSTOTPOP[superfund == 1], na.rm = TRUE),
    Total_Population_NonSuperfund = sum(ACSTOTPOP[superfund == 0], na.rm = TRUE)
  ) %>%
  mutate(
    Percent_Superfund = round((Total_Population_Superfund / Total_Population_Overall) * 100, 1),
    Percent_NonSuperfund = round((Total_Population_NonSuperfund / Total_Population_Overall) * 100, 1)
  )

# View the result
Nassau_pop


# Create a subset for Suffolk County (COUNTYFP = 59)
Suffolk_Data <- subset(subset_data, COUNTYFP == 59)

# Sum total population for Superfund and non-Superfund tracts in Suffolk, and for the overall dataset
Suffolk_pop <- Suffolk_Data %>%
  summarize(
    Total_Population_Overall = sum(ACSTOTPOP, na.rm = TRUE),
    Total_Population_Superfund = sum(ACSTOTPOP[superfund == 1], na.rm = TRUE),
    Total_Population_NonSuperfund = sum(ACSTOTPOP[superfund == 0], na.rm = TRUE)
  ) %>%
  mutate(
    Percent_Superfund = round((Total_Population_Superfund / Total_Population_Overall) * 100, 1),
    Percent_NonSuperfund = round((Total_Population_NonSuperfund / Total_Population_Overall) * 100, 1)
  )


Suffolk_pop
