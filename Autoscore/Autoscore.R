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
USMX <- rename(USMX, target = Actual, response = Predicted)

#create id column 
USMX <- USMX %>% 
  mutate(id = row_number())

#Create vector of acceptable compounds
compound_vector <- c("runkey" = "run key", "creepy-crawly" = "creepy crawly", "outside" = "out side", "tockstar" = "tock star", "deckfast" = "deck fast", "plathtub" = "plath tub", "motorcycle" = "motor cycle", "tayground" = "tay ground", "inside" = "in side", "snayground" = "snay ground", "airplane" = "air plane", "lowboy" = "low boy", "sleckfast" = "sleck fast", "butterfly" = "butter fly", "matterpillar" = "matter pillar", "choo-choo" = "choo choo", "tedrooms" = "ted rooms", "sarshmallows" = "sarsh mallows", "saterpillar" = "sater pillar", "white-striped" = "white striped", "white-striped" = "whitestriped", "hathroom" = "hath room", "rockstar" = "rock star", "snowman" = "snow man", "tall key" = "tallkey", "lilypad" = "lily pad", "breakfast" = "break fast", "sunglasses" = "sun glasses", "bathtub" = "bath tub", "playground" = "play ground", "snowballs" = "snow balls", "marshmallows" = "marsh mallows", "bathroom" = "bath room")

#calculate autoscore
USMX <- USMX %>%
  dplyr::mutate(response = compound_fixer(response, comp = compound_vector)) %>%
            autoscore(acceptable_df = autoscore::acceptable_spellings, number_text_rule = TRUE, 
                      contractions_df = autoscore::contractions_df) %>%
            as_tibble()

#calculate percent words correct score
percent_words_correct <- USMX %>% pwc(id)

#merge USMX data frame and percent_words_correct data frame
USMX_autoscore_all_columns <- merge(USMX, percent_words_correct, by="id", all=TRUE)
USMX_autoscore <- USMX_autoscore_all_columns %>%
  select(id, file, target, response, autoscore, pwc)
#Write this to new excel file USMX_autoscore_all_columns and USMX_autoscore
write_xlsx(USMX_autoscore_all_columns, "USMX_autoscore_all_columns.xlsx")
write_xlsx(USMX_autoscore, "USMX_autoscore.xlsx")



