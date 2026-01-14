library(dplyr)
library(ggplot2)

#Purchase rate based on engagement (Line Chart)
cycle1_plot_df <- cycle1_data %>%
  mutate(
    engaged = total_steps_completed > 0
  ) %>%
  filter(engaged) %>%   # optional: focus on learners who did something
  mutate(
    engagement_group = ntile(total_steps_completed, 4) %>%
      factor(labels = c("Low", "Medium-Low", "Medium-High", "High"))
  ) %>%
  group_by(engagement_group) %>%
  summarise(
    n_learners = n(),
    purchase_rate = mean(purchased),
    .groups = "drop"
  )

ggplot(cycle1_plot_df,
       aes(x = engagement_group, y = purchase_rate, group = 1)) +
  geom_point(size = 3) +
  geom_line() +
  labs(
    title = "Purchase rate by engagement level",
    x = "Engagement group",
    y = "Purchase rate"
  )


#Purchase rate by weeks active
cycle1_weeks_df <- cycle1_data %>%
  mutate(weeks_active = factor(weeks_active, levels = 0:3)) %>%
  group_by(weeks_active) %>%
  summarise(
    n_learners = n(),
    purchase_rate = mean(purchased),
    .groups = "drop"
  )

ggplot(cycle1_weeks_df, aes(x = weeks_active, y = purchase_rate)) +
  geom_col(aes(fill = weeks_active), show.legend = FALSE) +
  labs(
    title = "Purchase rate by number of active weeks",
    x = "Weeks active (based on step completion)",
    y = "Purchase rate"
  )

#Purchase rates based upon the Runs-(Dot plot + mean line)
overall_mean <- mean(cycle1_data$purchased)

ggplot(cycle1_run_df,
       aes(x = run_id, y = purchase_rate)) +
  geom_point(size = 3) +
  geom_hline(yintercept = overall_mean,
             linetype = "dashed", colour = "red") +
  labs(
    title = "Purchase rate across course runs",
    x = "Run ID",
    y = "Purchase rate"
  )

