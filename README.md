# Cyber Security MOOC — Statistical Analysis in R

Learning analytics on 7 runs of a FutureLearn Cyber Security MOOC using R, CRISP-DM, and the ProjectTemplate framework. Investigates how learner engagement predicts course completion and statement purchase.

## Overview

This project applies the **CRISP-DM** framework to learner interaction data from a three-week cyber security MOOC delivered on the FutureLearn platform across seven course runs. Two analytical cycles investigate how engagement relates to:

- **Statement purchase** — monetisation outcome
- **Course completion** — learner success outcome

## CRISP-DM Cycles

### Cycle 1 — Full-course Engagement
Descriptive analysis of overall learner engagement across all three weeks. Identifies engagement patterns (step activity, video views, comments) correlated with completion and purchase.

### Cycle 2 — Early Engagement (Week 1)
Focused analysis of Week 1 behaviour as a leading indicator of final outcomes. Tests whether early engagement signals can predict later monetisation and completion.

## Project Structure

```
data/       Raw FutureLearn CSV files (7 course runs, unmodified + derived)
config/     global.dcf — ProjectTemplate options and package loading
munge/      Preprocessing scripts for Cycle 1 and Cycle 2
cache/      Cached derived datasets (cycle1_data, cycle2_data)
src/        Analysis and plotting scripts
reports/    R Markdown report (knit to PDF)
```

## How to Run

1. Open `CyberAnalysis_PT_Stats.Rproj` in RStudio
2. Call `load.project()` in the console — packages load and cached objects restore automatically
3. Open the `.Rmd` file in `reports/`
4. Click **Knit** to reproduce the full analysis as a PDF report

## Tech Stack

- R, RStudio
- ProjectTemplate framework
- dplyr, ggplot2, tidyr
- renv (dependency management)

## Author

Mohammed Kabeer Sheikh — Newcastle University (January 2026)
