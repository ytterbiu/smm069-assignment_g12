# MSc Term 3 Electives: SMM069 Advanced Predictive Analytics - Group Project

Term 3 group project for Advanced Predictive Analytics (100% of module grade).

This coursework is split into two separate projects, but both are combined
within the same document.

- Group 12 working directory

> [!IMPORTANT]
> HTML report: https://ytterbiu.github.io/smm069-assignment_g12/

> [!NOTE]
> R Shiny app for part A: https://3enji-apps.shinyapps.io/smm069-g12-part-a-dashboard/

## Formatting guide

Making notes here for collaboration using rmd format:

- If using `align*` ensure that it isn't wrapped in math mode
- Add `<!-- prettier-ignore -->` before `align*` environment
- Avoid putting + or - at the start of a new line within an `align*` environment
- Use `$$ (maths) $$` for display math mode for consistency, rather than
  `\[ and \]`
- This character `−` raises warning in X&#x018E;LaTeX, have replaced throughout
  with `-`

## Structure

The directory structure is as follows

```{bash}
.
├── README.md
├── air.toml
├── answer.lua
├── adv-pred-analytics-assessment01-group12.rmd
├── fig
│   ├── ...
├── data
│   ├── DA441_GICS_Sectors.xlsx
│   ├── DA441_weekly_returns.csv
│   ├── final_results.rds
│   ├── freMTPL2freq.csv
│   ├── freMTPL2sev.csv
│   └── risk_free_rate_weekly.csv
├── preamble-local.tex
├── preamble.tex
├── references.bib
├── style.css
├── style_code.lua
```

## Requirements

- R (≥ 4.x)
- Packages: at minimum **rmarkdown** (others as used in the Rmd)

For R Markdown install core package:

```{r}
install.packages("rmarkdown")
```

Additional packages used are

```r
install.packages(c(
  # Data manipulation & plotting
  "tidyverse",   # dplyr, tidyr, ggplot2, purrr, ...
  "patchwork",   # combining plots
  "readxl",      # GICS sectors xlsx
  # Reporting & tables
  "kableExtra",  # static tables
  "DT",          # interactive HTML tables
  "plotly",      # interactive HTML plots
  "pander",      # pandoc output (kept for posterity)
  # Statistical modelling
  "glm2",        # GLM fitting
  "glmnet",      # lasso / elastic net
  "shiny"        # dashboard (Appendix only)
))
# splines ships with base R
```

Course-specific packages (from the course-provided sources):

```r
# savvySh, savvyPR, savvyGLM
```

The Rmd also sources two local scripts, which must sit alongside it:
`All_eight_shrinkage_estimators.R` and `cov1Para.R`.

## Useful operations

### Render outputs (HTML / PDF / Word)

#### Render a single R Markdown file to multiple formats:

```{r}
rmarkdown::render("filename.Rmd", output_format = "all")
```

```{r}
render_clean("filename.Rmd", output_format = "all")
```

#### Render to a specific format:

```{r}
rmarkdown::render("filename.Rmd", output_format = "html_document")
rmarkdown::render("filename.Rmd", output_format = "pdf_document")
rmarkdown::render("filename.Rmd", output_format = "word_document")
```

#### Render everything in a directory (not used here):

```{r}
files <- list.files(pattern = "\\.Rmd$", ignore.case = TRUE)
for (f in files) rmarkdown::render(f, output_format = "all")
```

### Extract R code from an Rmd (purl)

Create a `.R` script from an `.Rmd`:

```{r}
knitr::purl("filename.Rmd", documentation = 0)
```

### Debug: find non-ASCII characters

Useful if PDF/LaTeX builds start to fail without clear errors and if you suspect
things like smart quotes or odd dashes.

```{r}
tools::showNonASCIIfile("filename.Rmd")
```

### Run all code chunks (for debugging)

```{r}
knitr::knit("filename.Rmd")
```

### Session Info

```{r}
sessionInfo()
```

## References

- Asimit, V., Chen, Z. & Lassance, N. (2026). *Journal of Business & Economic
  Statistics*. <https://doi.org/10.1080/07350015.2026.2638490> — mean-vector
  shrinkage estimators (Coursework 1).
- Asimit, V., Avramescu, A., Chen, Z., Rivas, S. & Senatore, G. (2025).
  Technical report, City St George's, University of London.
  <https://openaccess.city.ac.uk/id/eprint/35099> — shrinkage GLMs /
  `savvyGLM` (Coursework 2).
- Full bibliography: see `references.bib` and the References section of the
  report.

## Acknowledgements

- SMM069 (2025–26) course resources by Prof. Vali Asimit and Ms Ziwei Chen,
  including the custom packages `savvySh`, `savvyPR` and `savvyGLM` and the
  estimator scripts `All_eight_shrinkage_estimators.R` and `cov1Para.R`.
- Moodle practice files, adapted for our pipelines:
  - `R_Practice_Section_1_CW_filled.Rmd` (rolling-window backtest)
  - `R_Practice_Section_2_Part2_CW_Template_Filled.Rmd` (CV loop, metrics)
- The `freMTPL2freq` / `freMTPL2sev` datasets originate from the
  `CASdatasets` package (Dutang & Charpentier).
