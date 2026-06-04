# MSc Electives - Term 3: SMM069 Advanced Predictive Analytics — Group Project

Term 3 group project for Advanced Predictive Analytics (100% of module grade).

This coursework is split into two separate projects, but both are combined
within the same document.

- Group 12 working directory
- HTML report: TBI

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
├── CHANGELOG.md
├── README.md
├── air.toml
├── answer.lua
├── adv-pred-analytics-assessment01-group12.rmd
├── fig
│   ├── ...
├── data
│   ├── DA441_GICS_Sectors.xlsx
│   ├── DA441_weekly_returns.csv
│   └── risk_free_rate_weekly.csv
├── preamble.tex
├── references.bib
└── style.css
```

## Requirements

- R (≥ 4.x)
- Packages: at minimum **rmarkdown** (others as used in the Rmd)

For R Markdown install core package:

```{r}
install.packages("rmarkdown")
```

Additional packages used are

```{r}
TBI
```

- Optional packages: `htmltools` (required only if rendering to HTML)

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

TBI
