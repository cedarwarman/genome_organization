# Introduction ------------------------------------------------------------

# In this script I will collect SRR IDs for accessions sequenced in Alonge
# 2020 (doi:10.1016/j.cell.2020.05.021) and Gao 2019 
# (doi:10.1038/s41588-019-0410-2).

library(dplyr)
library(googlesheets4)
gs4_auth(path = "~/.credentials/google_sheets_api/service_account.json")

# Loading existing data ---------------------------------------------------
# I will start with just the tables from the two papers, then add a table I 
# made to reconcile all the different names.

# Table downloaded from: https://www.ncbi.nlm.nih.gov/sra?linkname=bioproject_sra_all&from_uid=557253
alonge_sra_source <- read_sheet("18f05G-wFJhkA041bAnXgpcvss56Jt_mzV7CayOR9saY")

# Gao et al. Table downloaded from: https://www.ncbi.nlm.nih.gov/sra/SRP150040
gao_sra_source <- read_sheet("1MyYgkeG4DrUFpYyENYwVys4tmZvxo6hkS2Ap7U_qUXQ")

# Metadata table that has all the different names
metadata <- read_sheet("1V2kH8G4tfYsYqnYb6bVHpGjwwkjd9le0arGBJ2o4r8s")


# Cleaning the tables -----------------------------------------------------
clean_tables <- function(input_df){
  input_df <- input_df %>%
    filter(LibraryStrategy == "WGS") %>%
    select(Run, SampleName, Platform, LibrarySource, LoadDate)
  return(input_df)
}

alonge_clean <- clean_tables(alonge_sra_source)
gao_clean <- clean_tables(gao_sra_source)


# Adding LA names when available ------------------------------------------
# I made this big metadata sheet that has all the names I could find. At the 
# moment I'm only interested in the LA names, so I'll make a simpler version
# with just those.
metadata <- metadata %>%
  select(name_TGRC, name_original_alonge, name_original_razifard)

# Joining based on the original names
alonge_clean <- left_join(alonge_clean, metadata[ , c("name_TGRC", "name_original_alonge")], 
                          by = c("SampleName" = "name_original_alonge"))
gao_clean <- left_join(gao_clean, metadata[ , c("name_TGRC", "name_original_razifard")], 
                       by = c("SampleName" = "name_original_razifard"))


# Making the columns for upload -------------------------------------------
# Andria's spreadsheet has columns:
# order, sra_id, batch, description, LA ID, strain ID, notes, sequencing_type, sequencing_details, submission_date, collection_date, sequencing_date

alonge <- alonge_clean %>%
  mutate(notes = "Alonge_2020", order = "", batch = "", strain = "", collection_date = "", sequencing_date = "") %>%
  relocate(order, sra_id = Run, batch, description = SampleName, "LA ID" = name_TGRC, 
           "strain ID" = strain, notes, sequencing_type = Platform, sequencing_details = LibrarySource,
           submission_date = LoadDate)

gao <- gao_clean %>%
  mutate(notes = "Gao_2019", order = "", batch = "", strain = "", collection_date = "", sequencing_date = "") %>%
  relocate(order, sra_id = Run, batch, description = SampleName, "LA ID" = name_TGRC, 
           "strain ID" = strain, notes, sequencing_type = Platform, sequencing_details = LibrarySource,
           submission_date = LoadDate)

# Adding them together
df <- rbind(alonge, gao)


# Uploading ---------------------------------------------------------------

write_sheet(df, "12MQAydwr0ZPQbvit51qavE1XN0inlPjpkhQXHyWzfvY", sheet = "Sheet1")
