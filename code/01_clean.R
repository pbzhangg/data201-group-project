source("00_load.R")

# used to explore and clean the data

# explore vf_data
summary(vf_data)
attr(vf_data$date_time, "tzone")

# fix issues with vf_data
# no timezone listed from looking through data looks to be already in nzdt
# purpose of this is just to make a set timezone for easier comparisions later
vf_data$time_NZST <- with_tz(vf_data$date_time, "Pacific/Auckland")
attr(vf_data$time_NZST, "tzone")

# makes the sa2 a double like in the other datasets and removes duplicates
# first but removing all rows that are completly duplicated
# then it removes all duplicate reading timestamps with the highest value
vf_data <- vf_data %>%
  distinct() %>%
  mutate(sa2_code = as.double(sa2_code)) %>%
  group_by(sa2_code, date_time) %>%
  slice_max(device_count_vf, n = 1) %>%
  ungroup()

# should make a blank df if there are no duplicates
duplicate_area_vf <- vf_data %>%
  group_by(sa2_code, date_time) %>%
  filter(n() > 1) %>%
  ungroup()

summary(sp_data)
attr(sp_data$time_date, "tzone")

# set the correct timezone (check that this is nzst and not nzdt)
sp_data$time_NZST <- with_tz(sp_data$time_date, "Pacific/Auckland")
# remove duplicates
# first but removing all rows that are completly duplicated
# then it removes all duplicate reading timestamps with the highest value
sp_data <- distinct(sp_data) %>%
  group_by(sa2_code, time_date) %>%
  slice_max(device_count_spark, n = 1) %>%
  ungroup()
attr(sp_data$time_NZST, "tzone")
# this shows that there are duplicates rows in the data
# should make a blank df if there are no duplicates
duplicate_area_sp <- sp_data %>%
  group_by(sa2_code, time_date) %>%
  filter(n() > 1) %>%
  ungroup()
