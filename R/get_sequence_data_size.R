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
