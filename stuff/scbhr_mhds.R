library(readr)

scbhr_mhds = file.path("C:", "Users", "mavos", "OneDrive", "DSPG", "Systems of Care Project", "Data", "scbhr_mhds.csv")

scbhr_mhds = read_csv(scbhr_mhds)

usethis::use_data(scbhr_mhds)
