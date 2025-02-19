# import script for
# TODO APA Citation
# Justine Dombroski, Rochelle S. Newman;
# Toddlers' ability to map the meaning of new words in multi-talker environments.
# J. Acoust. Soc. Am. 1 November 2014; 136 (5): 2807–2815.
# https://doi.org/10.1121/1.4898051


library(tidyverse)
library(here)
library(peekds)
library(osfr)
library(readxl)

path <- here("data", "dombroski_backgroundnoise_2014")
data_path <- here(path, "raw_data")
output_path <- here("data", "dombroski_backgroundnoise_2014", "processed_data")
dataset_name <- "dombroski_backgroundnoise_2014"

### 1. DATASET TABLE
dataset <- tibble(
  dataset_id = 0,
  lab_dataset_id = 0,
  dataset_name = dataset_name,
  name = dataset_name,
  shortcite = "",
  cite = "", # TODO APA Citation
  dataset_aux_data = NA
)

demo <- read_excel(here(data_path, "demographics", "34m WordLearninginNoise running sheet.xls"), col_names = FALSE)[-c(1,2),c(1,3,5)] %>%
  rename(
    lab_subject_id = `...1`,
    sex = `...3`,
    age = `...5`
  ) %>% 
  filter(!is.na(lab_subject_id))

### 2. SUBJECTS TABLE

subjects <- demo %>% 
  select(lab_subject_id, sex) %>% 
  mutate(subject_id = 0:(n() - 1),
    native_language = 'eng', # according to the paper, this was the same for everyone
    subject_aux_data = NA # no mention of cdi in the paper, nothing in the raw_data
  )
  
# TODO heavily wip


# going by the paper, there is a 1:1 mapping
# between participants and administrations




################## WRITING AND VALIDATION ##################

dir.create(here(output_path), showWarnings=FALSE)

write_csv(dataset, file = here(output_path, "datasets.csv"))
write_csv(subjects, file = here(output_path, "subjects.csv"))
write_csv(stimuli, file = here(output_path,  "stimuli.csv"))
write_csv(administrations, file = here(output_path, "administrations.csv"))
write_csv(trial_types, file = here(output_path, "trial_types.csv"))
write_csv(trials, file = here(output_path, "trials.csv"))
write_csv(aoi_region_sets, file = here(output_path, "aoi_region_sets.csv"))
write_csv(xy_timepoints, file = here(output_path, "xy_timepoints.csv"))
write_csv(aoi_timepoints, file = here(output_path, "aoi_timepoints.csv"))

# run validator
peekds::validate_for_db_import(dir_csv = output_path)