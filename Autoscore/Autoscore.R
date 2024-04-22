#install packages
install.packages("tidyverse")
install.packages("remotes")
remotes::install_github("autoscore/autoscore")

#load packages
library(tidyverse)
library(autoscore)
library(readxl)
library(dplyr)
library(writexl)

USMX <- read_excel("USMXoutput.xlsx")

#change column names from Actual to Target and Predicted to Response
USMX <- rename(USMX, Target = Actual, Response = Predicted)

#create id column 
USMX <- USMX %>% 
  mutate(id = row_number())

#calculate autoscore
USMX <- USMX %>%
            autoscore() %>%
            as_tibble()

#calculate percent words correct score
percent_words_correct <- USMX %>% pwc(id)

#merge USMX data frame and percent_words_correct data frame
USMX_autoscore <- merge(USMX, percent_words_correct, by="id", all=TRUE)

#Write this to new excel file USMX_autoscore
write_xlsx(USMX_autoscore, "USMX_autoscore.xlsx")
