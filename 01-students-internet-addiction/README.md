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

## Project Files

- **`data/`**  
  Contains prepared (cleaned and non-identifiable) datasets used for analysis, along with a data dictionary describing each variable.

- **`analysis.R`**  
  The main R script that runs the complete workflow: data cleaning, statistical analysis, and creation of visualizations.

- **`report.qmd`**  
  A reproducible Quarto report that documents the full study, including the research question, aims, methods, results, and discussion.

---

## How to Run

1. Clone this repo to your computer.  
2. In RStudio, open `analysis.R` to run the cleaning/analysis pipeline.  
3. Render `report.qmd` in RStudio (click **Render**) or run from console:  
   ```bash
   quarto render report.qmd
