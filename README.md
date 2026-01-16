#----------------------------------
# Cyber Security MOOC Data Analysis
#----------------------------------

# Analysis of Learner Engagement in Cyber Security massive open online course (MOOC) by FutureLearn
# Author: Mohammed Kabeer Sheikh
# Date: 15th January 2026


### This project applies the CRISP-DM framework to learner interaction data from a three-week cyber security MOOC delivered on the FutureLearn platform across seven course runs.
### The analysis investigates how learner engagement relates to two key outcomes Statement purchase (monetisation) and Course completion (learner success)

### Two CRISP-DM cycles are conducted:
### 1) Cycle 1 – Descriptive analysis of overall engagement across the full course

### 2) Cycle 2 – Focused analysis of early (Week 1) engagement

##---------------
## PROJECT SETUP
##---------------

### This project uses the ProjectTemplate framework.
### Raw course data are stored in the 'data' folder and are not modified.
### Preprocessing scripts are stored in the 'munge' folder and generate derived datasets.
### Derived objects created during preprocessing are cached in the 'cache' folder and for permanent reproducibility also stored in "data".
### Project options are defined in the 'config/global.dcf' file.
### The 'load_libraries' option is set to TRUE to load required packages automatically.
### The R Markdown report file is stored in the 'reports' folder.

##-------------------
## PROJECT EXECUTION
##-------------------

### The user should open the R Markdown report file located in the 'reports' folder.
### The project should be loaded by calling load.project().
### Cached objects will be restored automatically if available.
### The user should click 'Knit' in RStudio to reproduce the analysis.
### This will generate the final report in PDF format.

##-------------------
## PROJECT STRUCTURE
##-------------------

### data/     – Raw course data (CSV files, unmodified,modified)
### config/   - Includes the global.dcf file used to set global options.
### munge/    – Data preprocessing scripts (Cycle 1 & Cycle 2)
### cache/    – Cached derived datasets (cycle1_data, cycle2_data)
### src/      – Analysis and plotting scripts
### reports/  – R Markdown report 

### other folders not used here.

