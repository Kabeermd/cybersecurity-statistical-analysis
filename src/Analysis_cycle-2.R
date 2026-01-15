
#Analysis for Crisp-dm cycle-two (Does early engagement shows any change in the purchasers behaviors)

#Week-1 Engagement table
cycle2_table1 <- cycle2_data %>%
  group_by(purchased) %>%
  summarise(
    learners = n(),
    wk1_active_rate = round(mean(wk1_active), 4),
    mean_wk1_steps = round(mean(wk1_steps_completed), 2),
    median_wk1_steps = median(wk1_steps_completed),
    .groups = "drop"
  )

cycle2_table1

#Purchase and completion rate by week-1
cycle2_table2 <- cycle2_data %>%
  group_by(wk1_active) %>%
  summarise(
    learners = n(),
    purchase_rate = round(mean(purchased), 4),
    completion_rate = round(mean(completed), 4),
    .groups = "drop"
  )

cycle2_table2

#Steps completed by purchase outcome week-1 (boxplot)
ggplot(cycle2_data, aes(x = factor(purchased), y = wk1_steps_completed)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.15, alpha = 0.2) +
  scale_x_discrete(labels = c("Not Purchased", "Purchased")) +
  scale_y_continuous(trans = "log1p") +
  labs(
    title = "Week 1 engagement by purchase outcome",
    subtitle = "Log-scaled y-axis used to account for skewed engagement distribution",
    x = "Purchased outcome",
    y = "Week 1 steps completed(log scale)"
  )

#Purchase rate by week-1 engagement(Line chart)
cycle2_band_df <- cycle2_data %>%
  mutate(
    wk1_band = case_when(
      wk1_steps_completed == 0,   #"0"
      wk1_steps_completed <= 2,  #"1–2"
      wk1_steps_completed <= 5,  #"3–5"
      TRUE #"6+"
    )
  ) %>%
  group_by(wk1_band) %>%
  summarise(
    n = n(),
    purchase_rate = mean(purchased),
    .groups = "drop"
  )

ggplot(cycle2_band_df, aes(x = wk1_band, y = purchase_rate, group = 1)) +
  geom_point(size = 3) +
  geom_line() +
  labs(
    title = "Purchase rate by Week 1 engagement band",
    x = "Week 1 steps completed (banded)",
    y = "Purchase rate"
  )

