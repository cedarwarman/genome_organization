# Introduction ------------------------------------------------------------
# I will use the script to prepare lists of SRA ids for download with nf-core
# fetchngs.

library(dplyr)


# Loading the data --------------------------------------------------------
alonge_metadata <- read.table(
  file = file.path(getwd(), "data", "alonge_metadata.txt"),
  sep = ',',
  header = TRUE
)

varitome_metadata <- read.table(
  file = file.path(getwd(), "data", "solavar_metadata.txt"),
  sep = ',',
  header = TRUE
)


# Making a file of Varitome SRA ids
write.table(
  varitome_metadata$Run,
  file = file.path(getwd(), "output", "varitome_sra_ids.txt"),
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE
)
