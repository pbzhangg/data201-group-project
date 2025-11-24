source("01_clean.R")

# combine tables together

# spark Vodafone data have area, count and a timestamps (required for dataset to be submitted)
# join sa2_ta on sa2 (for dataset required to be submitted)
# join urban_rural_to_sa2_concord on sa2 (potentially required to answer questions)
# join urban_rural_to_indicator on ur2023 (potentially required to answer questions)


# retrieve the total population of the country
total_population <- subnational_pop_ests %>%
  select(Age, AREA_POPES_SUB_006, OBS_VALUE) %>%
  filter(AREA_POPES_SUB_006 == "NZTA")

# this pulls just the population estimates per sa2 from the dataset
# removes the total population with the filter
# removes the population by ta_code with a right join onto sa
population_by_sa2 <- subnational_pop_ests %>%
  select(Age, AREA_POPES_SUB_006, OBS_VALUE) %>%
  filter(AREA_POPES_SUB_006 != "NZTA") %>%
  mutate(AREA_POPES_SUB_006 = as.numeric(AREA_POPES_SUB_006)) %>%
  right_join(sa2_2023,
             by = join_by(AREA_POPES_SUB_006 == sa2_code))

# makes a table with only the total population count
population_by_sa2_total <- population_by_sa2 %>%
  filter(Age == "Total people, age") %>%
  rename(Population_Count_Total = OBS_VALUE)
# makes a table with only the population count 0-14
# then joins with the total population count
# this gives us a table with both the total and 0-14 population on the same row
population_by_sa2 <- population_by_sa2 %>%
  filter(Age != "Total people, age") %>%
  left_join(population_by_sa2_total,
            by = join_by(AREA_POPES_SUB_006)) %>%
  rename(Population_Count_Age14 = OBS_VALUE, sa2_code = AREA_POPES_SUB_006) %>%
  select(sa2_code, Population_Count_Age14, Population_Count_Total)

# join all the data required to be able to produce the calculations
# make sure all items for the final dataset are included
primary_dataset <- vf_data %>%
  full_join(sp_data,
            by = join_by(time_NZST, sa2_code)) %>%
  left_join(sa2_ta_concord_2023,
            by = join_by(sa2_code)) %>%
  select(sa2_code,
         sa_name,
         time_NZST,
         ta_code,
         ta_name,
         device_count_vf,
         device_count_spark) %>%
  mutate(total_device_count = device_count_vf + device_count_spark) %>%
  na.omit()

# gets the device count per hour over multiple days
total_devices_per_hour <- primary_dataset %>%
  group_by(time_NZST) %>%
  summarise(sum = sum(total_device_count), n = n())
# make a plot to help visualise the number of device
ggplot(total_devices_per_hour,
       aes(x = time_NZST, y = sum)) +
  geom_line()  +
  labs(title = "Nationwide total devices per hour",
       x = "Date and time",
       y = "Number of devices") +
  scale_x_datetime(date_breaks = "12 hour",
                   date_minor_breaks = "4 hour") +
  theme(axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1)) +
  geom_hline(yintercept = total_population$OBS_VALUE[2])

# This shows with less days so it's easier to see the pattern
ggplot(subset(total_devices_per_hour, time_NZST <= "2024-06-06 01:00:00"),
       aes(x = time_NZST, y = sum)) +
  geom_line()  +
  scale_x_datetime(date_breaks = "6 hour",
                   date_minor_breaks = "1 hour") +
  theme(axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1)) +
  geom_hline(yintercept = total_population$OBS_VALUE[2])

test <- primary_dataset %>%
  filter(time_NZST <= "2024-06-04 23:00:00") %>%
  filter(time_NZST >= "2024-06-04 00:00:00") %>%
  group_by(time_NZST) %>%
  summarise(sum = sum(total_device_count), n = n())
