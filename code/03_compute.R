source("02_preprocess.R")

###### new method starts here #######
# get total device counts per hour per region
dataset_per_hour <- primary_dataset %>%
  group_by(time_NZST) %>%
  summarise(sum_devices = sum(total_device_count))
# find the hour that has the most connected devices
max_hour <- dataset_per_hour %>%
  slice_max(order_by = sum_devices)
offset <- total_population$OBS_VALUE[2] - max_hour$sum_devices
offset_multiplier <- (total_population$OBS_VALUE[2]) / max_hour$sum_devices
# produces a ratio between the hour with the most connected devices and each individual hour
dataset_per_hour <- dataset_per_hour %>%
  mutate(formula = ((max_hour$sum_devices) / sum_devices))

# join dataset_per_hour gets the ratio between current hour and highest hour
# add in population estimates data to help produce an offset
# combine these all together to get a population estimate
final_dataset <- primary_dataset %>%
  left_join(dataset_per_hour,
            by = join_by(time_NZST)) %>%
  left_join(population_by_sa2,
            by = join_by(sa2_code)) %>%
  mutate(estimate_population = formula * total_device_count) %>%
  mutate(estimate_population_age_offset =
           (estimate_population +
              (Population_Count_Age14 / Population_Count_Total)  * estimate_population)) %>%
  mutate(estimate_population_basicoffset = estimate_population * offset_multiplier) %>%
  replace_na(list(estimate_population_age_offset = 0))


# turn dataset back into hourly format so that it can be graphed for total country
primary_dataset_per_hour <- final_dataset %>%
  na.omit() %>%
  group_by(time_NZST) %>%
  summarise(sum_devices = sum(total_device_count),
            n = n(),
            population_estimate_sum = sum(estimate_population_basicoffset))
# plot the estimated population of the country
# doing it this way as it's much tidier the ploting each region by itself
ggplot(primary_dataset_per_hour,
       aes(x = time_NZST, y = population_estimate_sum)) +
  geom_line() +
  labs(title = "Estimated Population for entire country",
       x = "Date Time in NZST",
       y = "Population Estimate") +
  scale_x_datetime(date_breaks = "12 hour",
                   date_minor_breaks = "4 hour") +
  theme(axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1)) +
  geom_hline(yintercept = total_population$OBS_VALUE[2], color = "blue")

# datetimes for normal week: 2024-06-03 00:00:00 - 2024-06-09 23:59:00
# datetimes for school holidays: 2024-06-10 00:00:00 - 2024-06-16 23:59:00



# Christchurch CBD SA2s - Christchurch Central North/South/East/West
chch_cbd_sa2 <- c(326600, 325800, 327100, 327000, 325700)
chch_cbd_dataset <- final_dataset %>%
  filter(sa2_code %in% chch_cbd_sa2) %>%
  group_by(time_NZST) %>%
  summarise(sum_devices = sum(total_device_count),
            sum_estimate_population = sum(estimate_population_basicoffset))


ggplot(chch_cbd_dataset,
       aes(x = time_NZST, y = sum_devices)) +
  geom_line() +
  scale_x_datetime(date_breaks = "24 hour",
                   date_minor_breaks = "4 hour") +
  theme(axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1)) +
  geom_smooth(se = FALSE)
# Wellington CBD SA2s - Wellington Central, Thorndon South, Thorndon North,
# Pipitea-Kaiwharawhara, Courtenay, Dixon Street East, Dixon Street West,
# Vivian East, Vivian West
wlg_cbd_sa2 <- c(251400, 250902, 250901, 250700, 251800, 251602, 251601, 252100,
                 251700)

wlg_cbd_dataset <- final_dataset %>%
  filter(sa2_code %in% wlg_cbd_sa2) %>%
  group_by(time_NZST) %>%
  summarise(sum_devices = sum(total_device_count),
            sum_estimate_population = sum(estimate_population_basicoffset))

ggplot(wlg_cbd_dataset,
       aes(x = time_NZST, y = sum_devices)) +
  geom_line() +
  scale_x_datetime(date_breaks = "24 hour",
                   date_minor_breaks = "4 hour") +
  theme(axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1)) +
  geom_smooth(se = FALSE)
# Auckland CBD SA2s - Wynyard-Viaduct, Quay Street-Customs Street, Hobson Ridge North,
# Hobson Ridge South, Hobson Ridge Central, Victoria Park, Karangahape East,
# Karangahape West, Queen Street South West, Queen Street, Symonds Street West,
# Symonds Street North West, Symonds Street East, Shortland Street,
# Auckland-University, Anzac Avenue, The Strand
akl_cbd_sa2 <- c(131300, 133301, 132700, 133800, 133400, 132400, 134302, 134301,
                 134100, 133200, 135300, 135100, 135900, 133700, 134800, 133500,
                 135700)
akl_cbd_dataset <- final_dataset %>%
  filter(sa2_code %in% akl_cbd_sa2) %>%
  group_by(time_NZST) %>%
  summarise(sum_devices = sum(total_device_count),
            sum_estimate_population = sum(estimate_population_basicoffset))

ggplot(akl_cbd_dataset,
       aes(x = time_NZST, y = sum_devices)) +
  geom_line() +
  scale_x_datetime(date_breaks = "24 hour",
                   date_minor_breaks = "4 hour") +
  theme(axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1)) +
  geom_smooth(se = FALSE)

##### data for all cbds combined #####
all_cbd_sa2 <- c(akl_cbd_sa2, wlg_cbd_sa2, chch_cbd_sa2)

all_cbd_dataset <- final_dataset %>%
  filter(sa2_code %in% all_cbd_sa2) %>%
  group_by(time_NZST) %>%
  summarise(sum_devices = sum(total_device_count),
            sum_estimate_population = sum(estimate_population_basicoffset))
ggplot(all_cbd_dataset,
       aes(x = time_NZST, y = sum_devices)) +
  geom_line() +
  scale_x_datetime(date_breaks = "24 hour",
                   date_minor_breaks = "4 hour") +
  theme(axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1)) +
  geom_smooth(se = FALSE)
