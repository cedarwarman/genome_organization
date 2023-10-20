# Introduction ------------------------------------------------------------
# I will use the script to prepare lists of SRA ids for download with nf-core
# fetchngs.

library(dplyr)
library(googlesheets4)
gs4_auth(path = "~/.credentials/google_sheets_api/service_account.json")


# Loading the data --------------------------------------------------------
alonge_metadata <- read.table(
  file = file.path(getwd(), "data", "alonge_metadata.txt"),
  sep = ',',
  header = TRUE
)

varitome_metadata <- read.table(
  file = file.path(getwd(), "data", "varitome_metadata.txt"),
  sep = ',',
  header = TRUE
)


# Making a file of Varitome SRA ids ---------------------------------------
# write.table(
#   varitome_metadata$Run,
#   file = file.path(getwd(), "output", "varitome_sra_ids.txt"),
#   quote = FALSE,
#   row.names = FALSE,
#   col.names = FALSE
# )


# Making a file of Alonge et al SRA ids -----------------------------------
alonge_metadata_output <- alonge_metadata %>%
  filter(LibrarySource == "GENOMIC")

# write.table(
#   alonge_metadata_output$Run,
#   file = file.path(getwd(), "output", "alonge_sra_ids.txt"),
#   quote = FALSE,
#   row.names = FALSE,
#   col.names = FALSE
# )


# Linking SRA ids to CW identifiers ---------------------------------------
# Right now the SRA ids are just linked to whatever accession identifier the 
# authors used, which are inconsistent and confusing. I'll try to link them 
# to CW ids here.

# Loading the metadata sheet
metadata <- read_sheet("1V2kH8G4tfYsYqnYb6bVHpGjwwkjd9le0arGBJ2o4r8s") %>%
  select(wave:name_original_razifard)

sra_info_varitome <- varitome_metadata %>%
  select(Run, Sample.Name)

sra_info_alonge <- alonge_metadata_output %>%
  select(Run, Sample.Name)

# Joining in the CW identifiers
sra_info_varitome <- sra_info_varitome %>%
  left_join(metadata, join_by(Sample.Name == name_original_razifard))
