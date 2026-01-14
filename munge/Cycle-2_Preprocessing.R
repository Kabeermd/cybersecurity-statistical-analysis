library(dplyr)

# -------------------------------
# STEP 1: Week 1 engagement only
# -------------------------------

cycle2_wk1_engagement <- step_activity_all %>%
  mutate(
    last_completed_at = na_if(last_completed_at, ""),
    step_completed = !is.na(last_completed_at)
  ) %>%
  filter(week_number == 1) %>%
  group_by(run_id, learner_id) %>%
  summarise(
    wk1_steps_completed = sum(step_completed),
    wk1_active = wk1_steps_completed > 0,
    .groups = "drop"
  )

# -------------------------------
# STEP 2: Combine with outcomes
# -------------------------------

cycle2_data <- cycle1_outcomes %>%
  select(run_id, learner_id, purchased, completed) %>%
  left_join(
    cycle2_wk1_engagement,
    by = c("run_id", "learner_id")
  ) %>%
  mutate(
    wk1_steps_completed = ifelse(is.na(wk1_steps_completed), 0, wk1_steps_completed),
    wk1_active = ifelse(is.na(wk1_active), FALSE, wk1_active)
  )

# -------------------------------
# STEP 3: Sanity checks
# -------------------------------

message("Cycle 2 rows: ", nrow(cycle2_data))
message("Week 1 active rate: ", round(mean(cycle2_data$wk1_active), 4))
message("Mean Week 1 steps completed: ",
        round(mean(cycle2_data$wk1_steps_completed), 2))
message("Purchase rate (should match Cycle 1): ",
        round(mean(cycle2_data$purchased), 4))
