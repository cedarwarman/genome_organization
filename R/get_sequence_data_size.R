# Introduction ------------------------------------------------------------
# In this script I will use metadata downloaded from the SRA to get the 
# size of the data used in this project. Data downloaded from:
# Alonge et al.:
# https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP216764&o=acc_s%3Aa
# Varitome: 
# https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP150040&o=acc_s%3Aa

library(dplyr)

# Loading the data
alonge_metadata <- read.table(
  file = file.path(getwd(), "data", "alonge_metadata.txt"),
  sep = ',',
  header = TRUE
)

solavar_metadata <- read.table(
  file = file.path(getwd(), "data", "solavar_metadata.txt"),
  sep = ',',
  header = TRUE
)


# Figuring out the size ---------------------------------------------------
# It's pretty straightforward for the Solavar samples, as far as I can tell
# there's nothing extra in here. First getting the size in GB.
solavar_metadata <- solavar_metadata %>%
  mutate(size_gb = Bytes / 10^9)

# Total size in TB:
sum(solavar_metadata$size_gb) / 1000 # 1.43 TB

# For the Alonge long read data there's some extra RNA-seq stuff in there.
alonge_metadata <- alonge_metadata %>%
  mutate(size_gb = Bytes / 10^9)

# Total size in TB:
sum(alonge_metadata$size_gb) / 1000 # 6.79 TB

# Only including the genomic data:
alonge_metadata %>%
  filter(LibrarySource == "GENOMIC") %>%
  summarize(sum_tb = sum(size_gb) / 1000) # 6.74 TB, not much different

# Curious how many libraries there are for each platform and each accession
platform_summary <- alonge_metadata %>%
  filter(LibrarySource == "GENOMIC") %>%
  group_by(Cultivar, Platform) %>%
  summarize(n = n())

# How many have both long read and Illumina?
alonge_metadata %>%
  filter(LibrarySource == "GENOMIC") %>%
  group_by(Cultivar, Platform) %>%
  summarize(n = n()) %>%
  ungroup() %>%
  group_by(Cultivar) %>%
  summarize(n_rows = n()) %>%
  filter(n_rows > 1) %>%
  nrow() # 14 accessions have both
