
#--------------------------
#Preprocessing for Cycle -1
#--------------------------

# ----------------
# Helper functions
# ----------------

get_run_id <- function(path) {
  as.integer(sub(".*cyber-security-([0-9]+)_.*", "\\1", basename(path)))
}

clean_names <- function(Sample_df) {
  names(Sample_df) <- tolower(gsub("[^a-z0-9]+", "_", names(Sample_df)))
  Sample_df
}


# --------------------------
# Load enrolments (all runs)
# --------------------------

enrol_files <- list.files(
  "data",
  pattern = "^cyber-security-[1-7]_enrolments\\.csv$",
  full.names = TRUE
)
print(enrol_files)

enrolments_all <- bind_rows(lapply(enrol_files, function(f) {
  Temp <- read.csv(f, stringsAsFactors = FALSE)
  Temp <- clean_names(Temp)
  Temp$run_id <- get_run_id(f)
  Temp
}))

#Changing Blank Spaces to N/a
enrolments_all <- enrolments_all %>%
  mutate(
    purchased_statement_at = na_if(purchased_statement_at, ""),
    fully_participated_at  = na_if(fully_participated_at, ""),
    enrolled_at            = na_if(enrolled_at, "")
  )

str(enrolments_all)

# ------------------------------
# Load step activity (all runs)
# ------------------------------

step_files <- list.files(
  "data",
  pattern = "^cyber-security-[1-7]_step-activity\\.csv$",
  full.names = TRUE
)
print(step_files)

step_activity_all <- bind_rows(lapply(step_files, function(f) {
  Temp <- read.csv(f, stringsAsFactors = FALSE)
  Temp <- clean_names(Temp)
  Temp$run_id <- get_run_id(f)
  Temp
}))

# -------------------------------------------
# Creating Business outcomes(Cycle1_outcomes)
# -------------------------------------------
print(names(enrolments_all))

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

# ------------------
# Engagement metrics
# ------------------

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

# ---------------------
#  Combine (Left Join)
# ---------------------

cycle1_data <- cycle1_outcomes %>%
  left_join(cycle1_engagement,
            by = c("run_id", "learner_id")) %>%
  mutate(
    total_steps_completed = ifelse(is.na(total_steps_completed), 0,
                                   total_steps_completed),
    weeks_active = ifelse(is.na(weeks_active), 0, weeks_active)
  )

# --------------
# Sanity checks(To check for results of preprocessing step)
# --------------

message("Total learner-run rows: ", nrow(cycle1_data))
message("Purchase count: ", sum(cycle1_data$purchased))
message("Purchase rate: ", round(mean(cycle1_data$purchased), 4))
message("Completion count: ", sum(cycle1_data$completed))
message("Completion rate: ", round(mean(cycle1_data$completed), 4))
message("Runs included: ",
        paste(sort(unique(cycle1_data$run_id)), collapse = ", "))

cache("cycle1_data")

