# Load packages
library(tidyverse)
library(googleLanguageR)  # Text translation with Google Translation API

# What data will you work with? Use one of the following two values:
# - "nrc" if you want to use the default dataset
# - "mydata" if you want to use your own dataset
data_choice <- "nrc"
data_root <- paste0("data/", data_choice)

# Authorise with personal JSON file obtained from Google Translation
googleLanguageR::gl_auth("~/mint2324q3u-baf951fb3aa5.json")

# Translate text
text_EN_google <- gl_translate(text, target = "en")$translatedText

# Create vector of file names to be used for saving the translated text
doc_names2 <- paste0("data/nrc/google-", str_sub(list.files(data_root, full.names = TRUE, pattern = "*.pdf$"), 10, -4L), ".txt")

# Write translations to file
for (i in 1:length(text_EN_google)) {
  writeLines(text_EN_google[i], doc_names2[i])
}