# Introduction ------------------------------------------------------------

# In this script I will collect SRR IDs for accessions sequenced in Alonge
# 2020 (doi:10.1016/j.cell.2020.05.021) and Gao 2019 
# (doi:10.1038/s41588-019-0410-2).

library(dplyr)
library(googlesheets4)
gs4_auth(path = "~/.credentials/google_sheets_api/service_account.json")

# Loading existing data ---------------------------------------------------
# I will start with just the tables from the two papers, then possibly add 
# a table I made to reconcile all the different names.

# Alonge
alonge_source <- read_sheet("1AghS5eZrdbwwEwFDvzyI-ERfkmEOjNp90UY8HjgwFh0", 
                            sheet = "S1B",
                            skip = 1)
# Gao et al. Table downloaded from: https://www.ncbi.nlm.nih.gov/sra/SRP150040
gao_source <- read_sheet("1MyYgkeG4DrUFpYyENYwVys4tmZvxo6hkS2Ap7U_qUXQ")
