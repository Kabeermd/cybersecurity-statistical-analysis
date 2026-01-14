library(dplyr)

# -------------------------------
# Helper functions
# -------------------------------

get_run_id <- function(path) {
  as.integer(sub(".*cyber-security-([0-9]+)_.*", "\\1", basename(path)))
}

clean_names <- function(Sample_df) {
  names(Sample_df) <- tolower(gsub("[^a-z0-9]+", "_", names(df)))
  df
}

# -------------------------------
# Load enrolments (all runs)
# -------------------------------

enrol_files <- list.files(
  "data",
  pattern = "^cyber-security-[1-7]_enrolments\\.csv$",
  full.names = TRUE
)

enrolments_all <- bind_rows(lapply(enrol_files, function(f) {
  Sample_df <- read.csv(f, stringsAsFactors = FALSE)
  Sample_df <- clean_names(Sample_df)
  Sample_df$run_id <- get_run_id(f)
  Sample_df
}))

# -------------------------------
# Load step activity (all runs)
# -------------------------------

step_files <- list.files(
  "data",
  pattern = "^cyber-security-[1-7]_step-activity\\.csv$",
  full.names = TRUE
)

step_activity_all <- bind_rows(lapply(step_files, function(f) {
  Sample_df <- read.csv(f, stringsAsFactors = FALSE)
  Sample_df <- clean_names(df)
  Sample_df$run_id <- get_run_id(f)
  Sample_df
}))

# -------------------------------
# STEP 3: Business outcomes
# -------------------------------

cycle1_outcomes <- enrolments_all %>%
  mutate(
    purchased = !is.na(purchased_statement_at),
    completed = !is.na(fully_participated_at)
  ) %>%
  select(
    run_id,
    learner_id,
    purchased,
    completed,
    enrolled_at,
    purchased_statement_at,
    fully_participated_at
  )

# -------------------------------
# STEP 4: Engagement metrics
# -------------------------------

cycle1_engagement <- step_activity_all %>%
  mutate(
    step_completed = !is.na(last_completed_at)
  ) %>%
  group_by(run_id, learner_id) %>%
  summarise(
    total_steps_completed = sum(step_completed),
    weeks_active = n_distinct(week_number[step_completed]),
    .groups = "drop"
  )

# -------------------------------
# STEP 5: Combine (LEFT JOIN)
# -------------------------------

cycle1_data <- cycle1_outcomes %>%
  left_join(cycle1_engagement,
            by = c("run_id", "learner_id")) %>%
  mutate(
    total_steps_completed = ifelse(is.na(total_steps_completed), 0,
                                   total_steps_completed),
    weeks_active = ifelse(is.na(weeks_active), 0, weeks_active)
  )

# -------------------------------
# STEP 6: Sanity checks
# -------------------------------

message("Total learner-run rows: ", nrow(cycle1_data))
message("Purchase rate: ", round(mean(cycle1_data$purchased), 4))
message("Completion rate: ", round(mean(cycle1_data$completed), 4))
message("Runs included: ",
        paste(sort(unique(cycle1_data$run_id)), collapse = ", "))
