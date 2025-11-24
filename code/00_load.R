
library(tidyverse)
library(nanoparquet)
# loads the required files

# load location data
# skip the rows at the top of the file containing descriptive information
sa2_2023 <- read_csv("data files/sa2_2023.csv",
                     skip = 6,
                     col_select = c("Code", "Descriptor"),
                     col_types = c("dc")) %>%
  rename(sa2_code = Code, sa2_name = Descriptor)
sa2_ta_concord_column_names <- c("sa2_code",
                                 "sa_name",
                                 "mapping",
                                 "ta_code",
                                 "ta_name")
sa2_ta_concord_2023 <- read_csv("data files/sa2_ta_concord_2023.csv",
                                skip = 7,
                                col_types = c("dccdc"),
                                col_names = sa2_ta_concord_column_names,
                                col_select = sa2_ta_concord_column_names)

ur_indicator_column_names <- c("ur_code",
                               "ur_name",
                               "mapping",
                               "indicator",
                               "indicator_name")
urban_rural_to_indicator_2023 <- read_csv("data files/urban_rural_to_indicator_2023.csv",
                                          skip = 7,
                                          col_types = c("dccdc"),
                                          col_names = ur_indicator_column_names,
                                          col_select = ur_indicator_column_names)

ur_sa2_23_column_names <- c("sa2",
                            "sa2_name",
                            "mapping",
                            "ur_code",
                            "ur_name")
urban_rural_to_sa2_concord_2023 <- read_csv("data files/urban_rural_to_sa2_concord_2023.csv",
                                            skip = 7,
                                            col_types = c("dccdc"),
                                            col_names = ur_sa2_23_column_names,
                                            col_select = ur_sa2_23_column_names)


# load population data
subnational_pop_ests <- read_csv("data files/subnational_pop_ests.csv",
                                 col_types = c("ccccnnccccccdc"))
# load telecommunications data
sp_data <- read_csv("data files/sp_data.csv.gz",
                    col_types = c("Tdd")) %>%
  rename(time_date = ts, sa2_code = sa2, device_count_spark = cnt)
vf_data <- read_parquet("data files/vf_data.parquet") %>%
  rename(date_time = dt, sa2_code = area, device_count_vf = devices)
