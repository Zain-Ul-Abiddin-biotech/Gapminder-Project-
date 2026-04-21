# 🌍 Gapminder Case Study — Global Health & Wealth Analysis in R

> **Who is this for?**
> This guide is written for **complete R beginners**. Every section explains *what* the code does in plain English, *why* we do it, and *what you can change* to explore different countries, years, or questions.

---

## 📋 Table of Contents

1. [What does this project explore?](#1-what-does-this-project-explore)
2. [Requirements — what to install](#2-requirements--what-to-install)
3. [The Dataset](#3-the-dataset)
4. [Step-by-Step Code Walkthrough](#4-step-by-step-code-walkthrough)
   - [Step 0 — Load Libraries](#step-0--load-libraries)
   - [Step 1 — Load & Explore the Data](#step-1--load--explore-the-data)
   - [Step 2 — Compare Infant Mortality](#step-2--compare-infant-mortality)
   - [Step 3 — Compare Continents: Fertility vs Life Expectancy](#step-3--compare-continents-fertility-vs-life-expectancy)
   - [Step 4 — Time Series Plots](#step-4--time-series-plots)
   - [Step 5 — Comparing Two Countries Over Time](#step-5--comparing-two-countries-over-time)
   - [Step 6 — Measuring GDP: Dollars Per Day](#step-6--measuring-gdp-dollars-per-day)
   - [Step 7 — Wealth by Region: Boxplots](#step-7--wealth-by-region-boxplots)
   - [Step 8 — West vs Developing World](#step-8--west-vs-developing-world)
   - [Step 9 — Density Plots: Income Distribution](#step-9--density-plots-income-distribution)
   - [Step 10 — Infant Survival vs Income & The Ecological Fallacy](#step-10--infant-survival-vs-income--the-ecological-fallacy)
5. [Tweaking the Analysis for Your Own Questions](#5-tweaking-the-analysis-for-your-own-questions)
6. [Common Errors and Fixes](#6-common-errors-and-fixes)
7. [Project Structure](#7-project-structure)
8. [Further Reading](#8-further-reading)

---

## 1. What does this project explore?

This R script uses the **Gapminder** dataset to answer real-world questions about how wealth, health, and fertility have changed across the globe over the past 50+ years.

The questions we explore:

- Has Asia caught up with Europe in life expectancy since 1962?
- How has Pakistan's birth rate changed over time?
- Are developing countries getting richer faster than the West?
- Does higher income always mean lower infant mortality — or is that too simple?

The last question introduces an important concept called the **ecological fallacy** — the mistake of assuming that patterns you see in group averages also hold for individuals.

---

## 2. Requirements — what to install

### R version
This script requires **R 4.1 or higher**.

### Install packages (run once)

```r
install.packages(c("dslabs", "tidyverse", "ggplot2", "ggrepel"))
```

> ⚠️ **Common beginner mistake:** Do NOT write `install.packages("pkg1", "pkg2")` — the correct way is `install.packages(c("pkg1", "pkg2"))` using `c()` to make a vector. Without `c()`, only the first package installs.

---

## 3. The Dataset

The Gapminder dataset is built into the `dslabs` package — no download needed. Load it with a single line:

```r
data(gapminder)
```

### What's in the dataset?

| Column | What it means |
|---|---|
| `country` | Country name |
| `year` | Year of observation |
| `infant_mortality` | Infant deaths per 1,000 live births |
| `life_expectancy` | Average life expectancy at birth |
| `fertility` | Average number of children per woman |
| `population` | Total population |
| `gdp` | Total GDP in US dollars |
| `continent` | Continent the country belongs to |
| `region` | More specific geographic region |

The dataset covers **185 countries** from **1960 to 2016** — though not every country has data for every year.

> 💡 **To explore what years are available:**
> ```r
> range(gapminder$year)            # earliest and latest year
> unique(gapminder$year)           # all years in the data
> sum(is.na(gapminder$gdp))        # how many missing GDP values
> ```

---

## 4. Step-by-Step Code Walkthrough

---

### Step 0 — Load Libraries

```r
library(dslabs)
library(tidyverse)
library(ggplot2)
library(ggrepel)
```

| Package | Purpose |
|---|---|
| `dslabs` | Contains the Gapminder dataset |
| `tidyverse` | Data manipulation tools (`dplyr`, `ggplot2`, pipes `%>%`) |
| `ggplot2` | The main plotting system |
| `ggrepel` | Adds non-overlapping text labels to plots |

---

### Step 1 — Load & Explore the Data

```r
data(gapminder)
head(gapminder)
str(gapminder)

pakistan_data <- gapminder %>% filter(country == "Pakistan")
print(pakistan_data)
```

**What this does:**
- `data(gapminder)` — loads the dataset into your R session
- `head()` — shows the first 6 rows
- `str()` — shows the structure: column names, types, and sample values
- `filter(country == "Pakistan")` — keeps only rows where the country is Pakistan

**What to change:**

```r
# 👇 Replace "Pakistan" with any country you're interested in
my_country <- gapminder %>% filter(country == "Brazil")
```

To see all available country names:
```r
unique(gapminder$country)
```

---

### Step 2 — Compare Infant Mortality

```r
gapminder %>%
  filter(year == 2015 & country %in% c("Sri Lanka", "Turkey")) %>%
  select(country, infant_mortality)
```

**What this does:** Filters the data to a specific year and two countries, then shows only the columns we care about.

**Key functions:**

| Function | What it does |
|---|---|
| `filter()` | Keeps rows matching a condition |
| `select()` | Keeps only the columns you name |
| `%in%` | Checks if a value is in a list |

**What to change:**

```r
# 👇 Compare any two countries in any year
gapminder %>%
  filter(year == 2010 & country %in% c("Nigeria", "Ghana")) %>%
  select(country, infant_mortality, life_expectancy)
```

---

### Step 3 — Compare Continents: Fertility vs Life Expectancy

This section tests and then disproves a hypothesis using data visualization.

**The original hypothesis (1962):** Asia has lower life expectancy than Europe.

```r
# Scatter plot for 1962
filter(gapminder, year == 1962) %>%
  ggplot(aes(fertility, life_expectancy, color = continent)) +
  geom_point()
```

**What this does:** Creates a scatter plot where each dot is a country. The x-axis shows fertility rate (births per woman), y-axis shows life expectancy, and color shows the continent.

**Then we test: is this still true 50 years later?**

```r
# Faceted comparison: 1962 vs 2012
filter(gapminder, year %in% c(1962, 2012)) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_grid(. ~ year)
```

**New concept — `facet_grid()`:** This creates **side-by-side panels** of the same plot, one for each year. It's one of the most powerful tools for seeing change over time.

| Facet syntax | What it produces |
|---|---|
| `facet_grid(. ~ year)` | Panels arranged left to right by year |
| `facet_grid(continent ~ year)` | Grid: continents as rows, years as columns |
| `facet_wrap(~year)` | Panels wrapping onto multiple rows automatically |

**What the data shows:** By 2012, most countries — including Asian ones — had moved toward lower fertility and higher life expectancy. The original hypothesis is largely disproved.

**What to change:**

```r
# 👇 Explore different years
years <- c(1970, 1985, 2000, 2012)

# 👇 Explore different continents
continents <- c("Africa", "Americas")
```

---

### Step 4 — Time Series Plots

```r
# Scatter plot of Pakistan's fertility over all years
gapminder %>%
  filter(country == "Pakistan") %>%
  ggplot(aes(year, fertility)) +
  geom_point()

# Line plot (better for showing trends)
gapminder %>%
  filter(country == "Pakistan") %>%
  ggplot(aes(year, fertility)) +
  geom_line()
```

**What this does:** Shows how a single country's fertility has changed year by year.

**`geom_point()` vs `geom_line()`:**

| Plot type | Best for |
|---|---|
| `geom_point()` | Seeing individual data values; spotting gaps in data |
| `geom_line()` | Seeing the overall trend over time |

**What to change:**

```r
# 👇 Try a different country and metric
gapminder %>%
  filter(country == "Brazil") %>%
  ggplot(aes(year, life_expectancy)) +
  geom_line()
```

---

### Step 5 — Comparing Two Countries Over Time

```r
countries <- c("South Korea", "Germany")

gapminder %>%
  filter(country %in% countries) %>%
  ggplot(aes(year, fertility, col = country)) +
  geom_line()
```

**What this does:** Draws one line per country on the same plot, colored differently. This makes direct comparison easy.

**Adding direct labels to the plot (instead of a legend):**

```r
labels <- data.frame(
  country = countries,
  x       = c(1975, 1965),   # 👇 x position of the label
  y       = c(60,   72)      # 👇 y position of the label
)

gapminder %>%
  filter(country %in% countries) %>%
  ggplot(aes(year, life_expectancy, col = country)) +
  geom_line() +
  geom_text(data = labels, aes(x, y, label = country), size = 5) +
  theme(legend.position = "none")
```

**What to change:**

```r
# 👇 Compare any two countries
countries <- c("Nigeria", "Kenya")

# 👇 Try life_expectancy or infant_mortality instead of fertility
ggplot(aes(year, life_expectancy, col = country))
```

> 💡 If your labels are in the wrong position, adjust the `x` and `y` values in the `labels` data frame.

---

### Step 6 — Measuring GDP: Dollars Per Day

```r
gapminder <- gapminder %>%
  mutate(dollars_per_day = gdp / population / 365)
```

**What this does:** Creates a new column — daily income per person in US dollars. This makes the GDP numbers human-readable and comparable across countries of different sizes.

**Why divide by 365?** GDP is annual. Dividing by 365 converts it to a daily figure so we can ask: "How much does a person in this country earn per day?"

```r
# Histogram of daily income in 1970
gapminder %>%
  filter(year == 1970 & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black")

# Same histogram with log2 scale on x-axis
gapminder %>%
  filter(year == 1970 & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black") +
  scale_x_continuous(trans = "log2")
```

**Why use a log scale?** Income is extremely skewed — a few rich countries earn $100+/day while many poor countries earn $1–2/day. On a regular scale, all the poor countries get squashed to the left edge. The **log2 scale** spreads them out so you can see the full distribution clearly.

**The key insight from this plot:** The distribution has **two peaks** (bimodal) — one cluster of rich countries and one of poor countries. This is often called the "two worlds" pattern.

---

### Step 7 — Wealth by Region: Boxplots

```r
p <- gapminder %>%
  filter(year == 1970 & !is.na(gdp)) %>%
  mutate(region = reorder(region, dollars_per_day, FUN = median)) %>%
  ggplot(aes(region, dollars_per_day, fill = continent)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("")

p + scale_y_continuous(trans = "log2")
```

**What this does:** Creates boxplots — one per region — ordered by median income and colored by continent.

**How to read a boxplot:**

```
        ─── whisker (max non-outlier value)
        |
    ┌───┤
    │   │  ← upper quartile (75%)
    │ ─ │  ← median (middle value)
    │   │  ← lower quartile (25%)
    └───┤
        |
        ─── whisker (min non-outlier value)
        ○   ← outlier
```

**`reorder(region, dollars_per_day, FUN = median)`** — sorts regions from poorest to richest by median income, making the plot much easier to read than alphabetical order.

**What to change:**

```r
# 👇 Change the year
filter(year == 2010 & !is.na(gdp))

# 👇 Show individual data points on top of the boxplot
p + scale_y_continuous(trans = "log2") + geom_point(size = 0.8, alpha = 0.5)
```

---

### Step 8 — West vs Developing World

```r
west <- c("Western Europe", "Northern Europe", "Southern Europe",
          "Northern America", "Australia and New Zealand")

gapminder %>%
  filter(year == 1970 & !is.na(gdp)) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black") +
  scale_x_continuous(trans = "log2") +
  facet_grid(. ~ group)
```

**What this does:** Labels each country as either "West" or "Developing" and shows their income distributions side by side.

**New concept — `mutate()` with `ifelse()`:**

```r
mutate(group = ifelse(region %in% west, "West", "Developing"))
```

This creates a new column `group`. For every row: if the region is in the `west` list → "West", otherwise → "Developing".

**Comparing 1970 vs 2010:**
The script then ensures only countries with data in **both** years are included (a fair comparison), using `intersect()` to find countries present in both year lists.

---

### Step 9 — Density Plots: Income Distribution

```r
gapminder %>%
  filter(year %in% c(1970, 2010) & country %in% country_list) %>%
  ggplot(aes(dollars_per_day, fill = group)) +
  scale_x_continuous(trans = "log2") +
  geom_density(alpha = 0.2, bw = 0.75, position = "stack") +
  facet_grid(year ~ .)
```

**What this does:** Density plots are smoother alternatives to histograms. Instead of counting how many countries fall in each income bin, they show a smooth curve representing the distribution.

**Key parameters:**

| Parameter | What it controls |
|---|---|
| `alpha = 0.2` | Transparency of the filled area (0 = invisible, 1 = solid) |
| `bw = 0.75` | Smoothing bandwidth — higher = smoother curve |
| `position = "stack"` | Stacks the group curves on top of each other |

**The population-weighted version:**

```r
mutate(weight = population / sum(population))
```

This weights each country by its population size. Without weighting, China (1.4 billion people) counts the same as Luxembourg (600,000 people). With weighting, large countries have more influence on the shape of the curve — giving a more realistic picture of how the world's *people* (not countries) are distributed.

---

### Step 10 — Infant Survival vs Income & The Ecological Fallacy

This is the most conceptually important section.

**Step 1: Group-level analysis (regional averages)**

```r
surv_income <- gapminder %>%
  filter(year == 2010 & !is.na(gdp) & !is.na(infant_mortality) & !is.na(group)) %>%
  group_by(group) %>%
  summarize(
    income               = sum(gdp) / sum(population) / 365,
    infant_survival_rate = 1 - sum(infant_mortality / 1000 * population) / sum(population)
  )
```

**What this does:** Collapses many countries into a single average per world region. It calculates:
- `income` — average daily income for the whole region
- `infant_survival_rate` — what fraction of infants survive (1 minus the mortality rate)

The resulting plot shows a clean, smooth relationship: richer regions → higher infant survival.

**Step 2: Country-level analysis (individuals)**

```r
ggplot(surv_income_country, aes(x = income, y = infant_survival_rate,
                                label = country, color = group)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_text_repel(size = 2)
```

**What this reveals — The Ecological Fallacy:**

When you plot individual *countries* instead of regional *averages*, you see that:
- There is huge variation **within** each region
- Some "Developing" countries have better infant survival than some "Western" countries
- The clean pattern from the group-level plot is partly an artifact of averaging

> 📖 **The Ecological Fallacy** is when you incorrectly assume that a relationship true at the group level (e.g. "richer regions have lower infant mortality") must also be true at the individual level (e.g. "every rich country has lower infant mortality than every poor country"). This is one of the most common mistakes in data interpretation.

**Why two different scales on the axes?**

| Scale | Why used |
|---|---|
| `trans = "log2"` on x-axis | Income is highly skewed; log scale spreads the range |
| `trans = "logit"` on y-axis | Survival rates are bounded between 0 and 1; logit scale stretches the ends |

---

## 5. Tweaking the Analysis for Your Own Questions

| What you want to explore | What to change |
|---|---|
| Different country | `filter(country == "Brazil")` |
| Different comparison pair | `c("Nigeria", "Egypt")` in `countries` |
| Different year | `filter(year == 1990)` |
| Different metric | Replace `fertility` with `life_expectancy` or `infant_mortality` |
| Different continents | `continents <- c("Africa", "Americas")` |
| Different "West" definition | Edit the `west <- c(...)` vector |
| More or fewer groups | Edit the `case_when(...)` block in Section 9 |
| Population-weighted analysis | Add `mutate(weight = population / sum(population))` |

---

## 6. Common Errors and Fixes

| Error | Likely cause | Fix |
|---|---|---|
| `could not find function "%>%"`  | tidyverse not loaded | Run `library(tidyverse)` |
| `object 'gapminder' not found` | Data not loaded | Run `data(gapminder)` |
| `argument 2 (type 'character') cannot be handled by 'cat'` | Wrong `install.packages` syntax | Use `install.packages(c("pkg1", "pkg2"))` with `c()` |
| Plot shows no points | Filter returned 0 rows | Check spelling of country/year — try `unique(gapminder$country)` |
| Labels off the plot | `x` or `y` in `labels` data frame are out of range | Adjust `x` and `y` values to be within your data range |
| `Error in logit: values outside (0,1)` | Survival rate has values exactly 0 or 1 | Add a small filter: `filter(infant_survival_rate > 0.875)` |
| Grey boxes instead of colored regions | `fill` not mapped | Ensure `fill = continent` or `fill = group` is inside `aes()` |

---

## 7. Project Structure

```
📁 your-project/
│
├── 📄 Gapminder_Analysis.R     ← Main analysis script
└── 📄 README.md                ← This file
```

> ✅ **No data files needed!** The Gapminder dataset is built into the `dslabs` package, so this project is fully self-contained. Just install the packages and run the script.

---

## 8. Further Reading

- [Gapminder Foundation](https://www.gapminder.org/) — Hans Rosling's original project with interactive visualizations
- [dslabs package documentation](https://cran.r-project.org/package=dslabs) — all datasets included in the package
- [R for Data Science (free online book)](https://r4ds.hadley.nz/) — the best beginner resource for tidyverse and ggplot2
- [ggplot2 cheatsheet](https://ggplot2.tidyverse.org/) — quick reference for all plot types and options
- [Hans Rosling's TED Talk — "The best stats you've ever seen"](https://www.ted.com/talks/hans_rosling_the_best_stats_you_ve_ever_seen) — the original inspiration for this kind of data storytelling

---

*Converted from Quarto (.qmd) to plain R script — corrected and documented for beginners.*
