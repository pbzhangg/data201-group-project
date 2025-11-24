source("03_compute.R")
library(egg)

###### VISUALISATIONS FOR Q1 ######

# Christchurch CBD population trend graph
q1_chch <- ggplot(chch_cbd_dataset,
                  aes(x = time_NZST, y = sum_estimate_population)) +
  geom_line() +
  # hourly portions of date/time x-axis labels removed due to redundancy
  # date portions reordered to recognisable NZ format
  scale_x_datetime(date_breaks = "24 hour",
                   date_minor_breaks = "4 hour",
                   date_labels = "%d-%m-%Y") +
  # x-axis labels rotated for readability
  theme(axis.text.x = element_text(angle = 65, vjust = 1, hjust = 1)) +
  geom_smooth(se = FALSE) +
  # vertical dotted line added to indicate normal -> school holiday transition
  geom_vline(xintercept = as.POSIXct("2024-06-10 00:00:00"),
             linetype = "dotted") +
  labs(x = "Date",
       y = "Estimated Population")
print(q1_chch)

# Wellington CBD population trend graph
q1_wlg <- ggplot(wlg_cbd_dataset,
                 aes(x = time_NZST, y = sum_estimate_population)) +
  geom_line() +
  scale_x_datetime(date_breaks = "24 hour",
                   date_minor_breaks = "4 hour",
                   date_labels = "%d-%m-%Y") +
  theme(axis.text.x = element_text(angle = 65, vjust = 1, hjust = 1)) +
  geom_smooth(se = FALSE) +
  geom_vline(xintercept = as.POSIXct("2024-06-10 00:00:00"),
             linetype = "dotted") +
  labs(x = "Date",
       y = "Estimated Population")
print(q1_wlg)

# Auckland CBD population trend graph
q1_akl <- ggplot(akl_cbd_dataset,
                 aes(x = time_NZST, y = sum_estimate_population)) +
  geom_line() +
  scale_x_datetime(date_breaks = "24 hour",
                   date_minor_breaks = "4 hour",
                   date_labels = "%d-%m-%Y") +
  theme(axis.text.x = element_text(angle = 65, vjust = 1, hjust = 1)) +
  geom_smooth(se = FALSE) +
  geom_vline(xintercept = as.POSIXct("2024-06-10 00:00:00"),
             linetype = "dotted") +
  labs(x = "Date",
       y = "Estimated Population")
print(q1_akl)

# combined CBD population trend graph
q1_all_cbd <- ggplot(all_cbd_dataset,
                     aes(x = time_NZST, y = sum_estimate_population)) +
  geom_line() +
  scale_x_datetime(date_breaks = "24 hour",
                   date_minor_breaks = "4 hour",
                   date_labels = "%d-%m-%Y") +
  theme(axis.text.x = element_text(angle = 65, vjust = 1, hjust = 1)) +
  geom_smooth(se = FALSE) +
  geom_vline(xintercept = as.POSIXct("2024-06-10 00:00:00"),
             linetype = "dotted") +
  labs(x = "Date",
       y = "Estimated Population")
print(q1_all_cbd)

##### Visualisations for Q2 ########
# visualisations are to show which day roadworks are best to be preformed on
# all three of these graphs are the mean hourly population per day
# coloured by the population count to make it easier to see changes
q2_chch <- chch_cbd_dataset %>%
  mutate(wday = wday(time_NZST, label = TRUE)) %>%
  mutate(hour = hour(time_NZST)) %>%
  group_by(wday) %>%
  summarise(
            sum_estimate_population = mean(sum_estimate_population)) %>%
  ggplot(aes(x = wday, y = sum_estimate_population)) +
  geom_bar(stat = "identity", aes(fill = sum_estimate_population)) +
  labs(title = "Mean Hour Population In Christchurch CBD",
       x = "Day of Week",
       y = "Mean Hourly Population") +
  theme(legend.position = "none")

q2_wlg <- wlg_cbd_dataset %>%
  mutate(wday = wday(time_NZST, label = TRUE)) %>%
  mutate(hour = hour(time_NZST)) %>%
  group_by(wday) %>%
  summarise(
            sum_estimate_population = mean(sum_estimate_population)) %>%
  ggplot(aes(x = wday, y = sum_estimate_population)) +
  geom_bar(stat = "identity", aes(fill = sum_estimate_population)) +
  labs(title = "Mean Hour Population In Wellington CBD",
       x = "Day of Week",
       y = "Mean Hourly Population") +
  theme(legend.position = "none")

q2_akl <- akl_cbd_dataset %>%
  mutate(wday = wday(time_NZST, label = TRUE)) %>%
  mutate(hour = hour(time_NZST)) %>%
  group_by(wday) %>%
  summarise(
            sum_estimate_population = mean(sum_estimate_population)) %>%
  ggplot(aes(x = wday, y = sum_estimate_population)) +
  geom_bar(stat = "identity", aes(fill = sum_estimate_population)) +
  labs(title = "Mean Hour Population In Auckland CBD",
       x = "Day of Week",
       y = "Mean Hourly Population") +
  theme(legend.position = "none")

# this puts all 3 graphs into one plot for the report
ggarrange(q2_akl, q2_chch, q2_wlg)

all_cbd_dataset %>%
  mutate(wday = wday(time_NZST, label = TRUE)) %>%
  mutate(hour = hour(time_NZST)) %>%
  group_by(wday) %>%
  summarise(
            sum_estimate_population = mean(sum_estimate_population)) %>%
  ggplot(aes(x = wday, y = sum_estimate_population)) +
  geom_bar(stat = "identity", aes(fill = sum_estimate_population)) +
  labs(title = "Mean Hour Population In All CBD",
       x = "Day of Week",
       y = "Mean Hourly Population") +
  theme(legend.position = "none")

# select just the data asked for this can be changed if required
export_dataset <- final_dataset %>%
  select(sa2_code, ta_code, time_NZST, estimate_population_basicoffset)
# this will export the final result to be submitted
write_csv(export_dataset, "finaldataset.csv.gz")
