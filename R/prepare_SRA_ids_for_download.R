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
  file = file.path(getwd(), "data", "varitome_metadata.txt"),
  sep = ',',
  header = TRUE
)


# Making a file of Varitome SRA ids ---------------------------------------
write.table(
  varitome_metadata$Run,
  file = file.path(getwd(), "output", "varitome_sra_ids.txt"),
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE
)


# Making a file of Alonge et al SRA ids -----------------------------------
alonge_metadata_output <- alonge_metadata %>%
  filter(LibrarySource == "GENOMIC")

write.table(
  alonge_metadata_output$Run,
  file = file.path(getwd(), "output", "alonge_sra_ids.txt"),
  quote = FALSE,
  row.names = FALSE,
  col.names = FALSE
)

