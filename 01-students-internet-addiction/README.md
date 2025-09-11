# Students’ Internet Addiction

## Overview
This project analyzes open data on the link between Internet addiction and mental health among college students in Malawi.

## Source & Citation  
- Data paper: *Data from “Internet Addiction and Mental Health among College Students in Malawi”*, *Journal of Open Psychology Data*.  
  DOI: https://doi.org/10.5334/jopd.72  
- Dataset (files): Mendeley Data, DOI: https://doi.org/10.17632/xbfbcy5bhv.3  
- Instruments: Internet Addiction Test (IAT), Self-Reporting Questionnaire (SRQ-20)
- See `data/README.md` for full variable dictionary.

Mwakilama, E. P., Jamu, E. S., Senganimalunje, L., & Manda, T. D. (2022). *Data on Internet Addiction and Mental Health among university students in Malawi* (Version 3) [Data set]. Mendeley Data. https://doi.org/10.17632/xbfbcy5bhv.3  

## Project Files
- `data/` → raw dataset + data dictionary
- `analysis.R` → main R script (cleaning, analysis, visualizations)
- `report.qmd` → reproducible Quarto report (project question, aims, methods, results, discussion)

## How to Run
1. Clone the repo.
2. Open `analysis.R` in RStudio to run cleaning/analysis code.
3. Render `report.qmd` in RStudio (click Render or run `quarto render report.qmd`).

## License
Dataset licensed CC BY 4.0. Code in this repo is open for reuse with attribution.
