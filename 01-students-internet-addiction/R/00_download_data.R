# download_data.r
# Purpose: Download the Malawi IAT & SRQ-20 dataset from Mendeley Data (DOI: 10.17632/xbfbcy5bhv.3)

# --- Install packages ---
install.packages("httr")
install.packages("readr")
install.packages("here")


# --- Load Packages ---
library(httr)
library(readr)
library(here)

# --- The URL of the dataset (CSV version) ---
# This is a "direct link" to the CSV file in the Mendeley repository
dataset_url <- "https://prod-dcd-datasets-cache-zipfiles.s3.eu-west-1.amazonaws.com/xbfbcy5bhv-3.zip"

raw_dir <- here("data-raw")

# --- Zip file location ---
zip_file <- file.path(raw_dir,"malawi-data.zip")


# --- Download the dataset ---
GET(dataset_url,write_disk(zip_file,overwrite = TRUE))

unzip(zip_file, exdir = raw_dir)

message("Data downloaded and unzipped in data-raw/. Now inspect the files manually.")



