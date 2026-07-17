# WA Rent & Homelessness Analysis

An R analysis of how rising rents track with homelessness in Washington State from 2015 to 2024, using Zillow rent data and HUD point-in-time counts.

Interactive report (charts): https://tarang-tj.github.io/wa-housing-homelessness/

## Question

Do statewide rent increases move together with homelessness counts in Washington? The report pairs annual average rent with the annual homeless count, computes a Pearson correlation, and treats the 2021 pandemic year as a separate case.

## Key findings

- **Parallel growth:** both rent and homelessness rose roughly 60% between 2015 and 2024.
- **2024 highs:** average rent about $1,650/mo and 31,554 people counted as homeless, the highest in the series.
- **2021 outlier:** homelessness fell to 11,511 despite rising rent, which lines up with COVID-19 eviction moratoriums and federal emergency rental assistance.
- Correlation, not causation. Rent is one pressure among many; the report states this caveat directly.

## Data sources

- **Zillow Observed Rent Index (ZORI)** - smoothed, all homes plus multifamily (`data/zillow_rent_index_wa.csv`).
- **HUD Point-in-Time estimates by state, 2015-2024** (`data/hud_pit_wa_2015_2024.csv`).

## Repo layout

- `scripts/` - R scripts for loading (`01_data_loading.R`), processing (`02_data_processing.R`), analysis (`03_analysis.R`), and visualization (`04_visualization.R`).
- `data/` - the two source CSVs.
- `docs/METHODOLOGY.md` - how the series were built and compared.
- `index.html` - the published interactive report (Chart.js), served via GitHub Pages.
- `output/` - directory for generated results.

## Reproduce

Install R with `dplyr`, `tidyr`, and `ggplot2`, then run the scripts in order:

```r
install.packages(c("dplyr", "tidyr", "ggplot2"))
```

```bash
Rscript scripts/01_data_loading.R
Rscript scripts/02_data_processing.R
Rscript scripts/03_analysis.R
Rscript scripts/04_visualization.R
```

## Stack

R (dplyr, tidyr, ggplot2) for the analysis; HTML plus Chart.js for the published report.
