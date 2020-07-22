library(readr)

file = file.path("C:", "Users", "mavos", "OneDrive", "DSPG", "Systems of Care Project", "Data", "regional_substance_treatment.csv")

regional_substance_treatment = read_csv(file)

regional_substance_treatment$dataset = "regional_substance_treatment"

usethis::use_data(regional_substance_treatment, overwrite = TRUE)
