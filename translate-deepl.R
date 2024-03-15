# Load packages
library(tidyverse)
library(deeplr)  # Text translation with DeepL API

# What data will you work with? Use one of the following two values:
# - "nrc" if you want to use the default dataset
# - "mydata" if you want to use your own dataset
data_choice <- "nrc"
data_root <- paste0("data/", data_choice)

# Create vector of file names to be used for saving the translated text
doc_names <- str_sub(list.files(data_root, full.names = TRUE, pattern = "*.pdf$"), 1, -4L) |> paste0(".txt")

# Translate the text from PDFs and write translation to files
for (i in 1:length(text)) {
  text_temp <- deeplr::translate(text[[i]], target_lang = "EN", source_lang = "NL",
                                 auth_key = Sys.getenv("DEEPLR_AUTH_KEY"))
  writeLines(text_temp, doc_names[i])
}