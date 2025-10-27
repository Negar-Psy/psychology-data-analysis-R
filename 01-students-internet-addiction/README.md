# Students’ Internet Addiction

## Overview
This project analyzes open data on the link between Internet Addiction and mental health among college students in Malawi.  
We build on the original study by (a) evaluating the factor structure and measurement invariance of the Internet Addiction Test (IAT), and (b) modeling the (potentially non-linear) association between IAT and common mental disorder (CMD; SRQ-20) using modern, reproducible R workflows.

---

## Prior Study Summary (Original Dataset)

**Aim.** To examine the link between Internet Addiction (IAT) and common mental disorder (CMD; SRQ-20) among Malawian tertiary students.

**Design.** Cross-sectional survey (May–July 2018).

**Setting & participants.** 13 higher-education institutions across Malawi; **n = 984** students (undergraduate + postgraduate; science and humanities/social sciences).

**Sampling.** Institutions identified from public/private HEIs; simple random sampling (SRS) where all-student mailing lists existed; snowball link distribution and paper surveys used where needed.

**Data collection.** Google Forms (with “limit to 1 response” enabled); paper questionnaires for students with limited internet access; paper entries double-entered to spreadsheet.

**Measures.**
- **Internet Addiction Test (IAT):** 20 items, 0–5 Likert scale, measuring problematic internet use.
- **Self-Reporting Questionnaire (SRQ-20):** 20 yes/no items; probable CMD defined at cutoff ≥ 8.
- **Demographics & use:** gender, age band, level of study (UG/PG), discipline, internet/social-media use indicators.

**Data access.** Publicly available via Mendeley Data (DOI: [10.17632/xbfbcy5bhv.3](https://doi.org/10.17632/xbfbcy5bhv.3)) and described in the Journal of Open Psychology Data data paper (DOI: [10.5334/jopd.72](https://doi.org/10.5334/jopd.72)).  
Raw data are **not re-distributed** in this repo; they are downloaded at build time.

---

## Source & Citation

- Data paper: *Data from “Internet Addiction and Mental Health among College Students in Malawi”*, *Journal of Open Psychology Data*.  
  DOI: https://doi.org/10.5334/jopd.72  
- Dataset (files): Mendeley Data, DOI: https://doi.org/10.17632/xbfbcy5bhv.3  
- Instruments: Internet Addiction Test (IAT), Self-Reporting Questionnaire (SRQ-20)  
- See `data/README.md` for full variable dictionary.

**Citation:**  
Mwakilama, E. P., Jamu, E. S., Senganimalunje, L., & Manda, T. D. (2022). *Data on Internet Addiction and Mental Health among university students in Malawi* (Version 3) [Data set]. Mendeley Data. https://doi.org/10.17632/xbfbcy5bhv.3  

---

## Research Objectives

- Validate the psychometric properties of the Internet Addiction Test (IAT).
- Examine the relationship between IAT scores and probable Common Mental Disorder (CMD).
- Explore the effects of demographic variables on mental health outcomes.

## Repository Structure

- **R/00_download_data.R**  
  Script to download and prepare raw data for analysis.

- **R/01_clean_score.R**  
  Performs cleaning and preprocessing of raw data, computes IAT and CMD scores.

- **R/02_setup_and_load.R**  
  Loads cleaned datasets and sets up necessary libraries and environment.

- **R/03_data_explore_describe.R**  
  Conducts exploratory data analysis and descriptive statistics.

- **R/04_statistical_analysis.R**  
  Fits logistic regression models and performs hypothesis testing.

- **R/05_results_interpretation_reporting.R**  
  Generates summary tables, plots, and final reports consolidating findings.

- **data/**  
  Contains anonymized, cleaned datasets and a comprehensive data dictionary.

- **reports/**  
  Includes output reports, visualizations, and model summaries in HTML, PDF, or Word formats.

- **README.md**  
  This documentation file.

## How to Use This Repository

### Prerequisites

- R (version 4.0 or higher)  
- RStudio IDE (recommended)  
- Required R packages (managed via `renv` or install manually)

### Getting Started

1. Clone the repository with:

    ```
    git clone https://github.com/Negar-Psy/psychology-data-analysis-R.git
    ```

2. Open the project folder in RStudio.

3. Install required packages if not already installed:

    ```
    install.packages(c("dplyr", "ggplot2", "broom", "gt", "gtsummary", "readr", "rmarkdown", "quarto"))
    ```

4. Execute scripts in sequential order to reproduce the analysis:

    - `R/00_download_data.R` – Download raw data.  
    - `R/01_clean_score.R` – Data cleaning and scoring.  
    - `R/02_setup_and_load.R` – Load prepared data.  
    - `R/03_data_explore_describe.R` – Explore and describe data.  
    - `R/04_statistical_analysis.R` – Statistical modeling.  
    - `R/05_results_interpretation_reporting.R` – Generate reports and figures.

5. Render the interactive report with Quarto:

    ```
    quarto::quarto_render("report.qmd")
    ```

6. Inspect outputs in the `reports/` directory (tables, plots, summaries).

## Contribution

Contributions, issues, and feature requests are welcome! Please fork the repository and create pull requests for collaborative improvements.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---











