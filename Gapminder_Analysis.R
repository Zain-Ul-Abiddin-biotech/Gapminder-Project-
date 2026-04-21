# ============================================================
# Gapminder Case Study — Global Health & Wealth Analysis
# Converted from Quarto (.qmd) to plain R script
# Author: Zain Ul Abiddin
# Corrected & optimized for current R / tidyverse best practices
# ============================================================


# ── Install packages (run once, then comment out) ───────────
# install.packages(c("dslabs", "tidyverse", "ggplot2", "ggrepel"))



# ── Load libraries ───────────────────────────────────────────
library(dslabs)
library(tidyverse)
library(ggplot2)
library(ggrepel)


# ── Load the Gapminder dataset ───────────────────────────────
data(gapminder)

# Quick look at the data structure
head(gapminder)
str(gapminder)


# ============================================================
# SECTION 1: Exploring the Data
# ============================================================

# Preview Pakistan's data as a country-level check
pakistan_data <- gapminder %>% filter(country == "Pakistan")
print(pakistan_data)


# ============================================================
# SECTION 2: Comparing Infant Mortality
# ============================================================

# Sri Lanka vs Turkey in 2015
gapminder %>%
  filter(year == 2015 & country %in% c("Sri Lanka", "Turkey")) %>%
  select(country, infant_mortality)

# Pakistan vs India in 2000 — infant mortality + life expectancy
p <- gapminder %>%
  filter(year == 2000 & country %in% c("Pakistan", "India")) %>%
  select(country, infant_mortality, life_expectancy)
print(p)


# ============================================================
# SECTION 3: Comparing Entire Continents
# ============================================================

# --- 3a. Scatter plot: fertility vs life expectancy in 1962 ---
# Hypothesis: Asia has lower life expectancy than Europe
filter(gapminder, year == 1962) %>%
  ggplot(aes(fertility, life_expectancy, color = continent)) +
  geom_point() +
  labs(title = "Fertility vs Life Expectancy — 1962",
       x = "Fertility Rate", y = "Life Expectancy") +
  theme_minimal()

# --- 3b. Facet by continent AND year: 1962 vs 2012 ---
# Did the gap close over 50 years?
filter(gapminder, year %in% c(1962, 2012)) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_grid(continent ~ year) +
  labs(title = "Fertility vs Life Expectancy: 1962 vs 2012 by Continent",
       x = "Fertility Rate", y = "Life Expectancy") +
  theme_minimal()

# --- 3c. Facet by year only (cleaner comparison) ---
filter(gapminder, year %in% c(1962, 2012)) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_grid(. ~ year) +
  labs(title = "Fertility vs Life Expectancy: 1962 vs 2012",
       x = "Fertility Rate", y = "Life Expectancy") +
  theme_minimal()

# --- 3d. Europe vs Asia across 5 decades ---
# Most countries shifted toward lower fertility & higher life expectancy
years      <- c(1962, 1980, 1990, 2000, 2012)
continents <- c("Europe", "Asia")

gapminder %>%
  filter(year %in% years & continent %in% continents) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_wrap(~year) +
  labs(title = "Europe vs Asia: Fertility & Life Expectancy Over Time",
       x = "Fertility Rate", y = "Life Expectancy") +
  theme_minimal()


# ============================================================
# SECTION 4: Time Series Plots
# ============================================================

# --- 4a. Pakistan fertility over time (scatter) ---
gapminder %>%
  filter(country == "Pakistan") %>%
  ggplot(aes(year, fertility)) +
  geom_point() +
  labs(title = "Pakistan: Fertility Rate Over Time",
       x = "Year", y = "Fertility Rate") +
  theme_minimal()

# --- 4b. Pakistan fertility over time (line) ---
gapminder %>%
  filter(country == "Pakistan") %>%
  ggplot(aes(year, fertility)) +
  geom_line() +
  labs(title = "Pakistan: Fertility Rate Over Time (Line)",
       x = "Year", y = "Fertility Rate") +
  theme_minimal()


# ============================================================
# SECTION 5: Comparing Countries — Multiple Time Series
# ============================================================

countries <- c("South Korea", "Germany")

# --- 5a. Fertility — grouped (no color) ---
gapminder %>%
  filter(country %in% countries) %>%
  ggplot(aes(year, fertility, group = country)) +
  geom_line() +
  labs(title = "Fertility: South Korea vs Germany",
       x = "Year", y = "Fertility Rate") +
  theme_minimal()

# --- 5b. Fertility — colored by country ---
gapminder %>%
  filter(country %in% countries) %>%
  ggplot(aes(year, fertility, col = country)) +
  geom_line() +
  labs(title = "Fertility: South Korea vs Germany",
       x = "Year", y = "Fertility Rate") +
  theme_minimal()

# --- 5c. Life expectancy with direct country labels ---
# FIX: label coordinates adjusted to be clearly within plot range
labels <- data.frame(
  country = countries,
  x       = c(1975, 1965),
  y       = c(60,   72)
)

gapminder %>%
  filter(country %in% countries) %>%
  ggplot(aes(year, life_expectancy, col = country)) +
  geom_line() +
  geom_text(data = labels, aes(x, y, label = country), size = 5) +
  theme_minimal() +
  theme(legend.position = "none") +
  labs(title = "Life Expectancy: South Korea vs Germany",
       x = "Year", y = "Life Expectancy")


# ============================================================
# SECTION 6: Measuring GDP — Dollars Per Day
# ============================================================

# --- 6a. Create the dollars_per_day variable ---
# FIX: original code recalculated mutate(dollars_per_day) three times
#      unnecessarily. Calculated once here and used throughout.
gapminder <- gapminder %>%
  mutate(dollars_per_day = gdp / population / 365)

past_year    <- 1970
present_year <- 2010

# --- 6b. Histogram of daily income in 1970 (raw scale) ---
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black", fill = "steelblue") +
  labs(title = "Distribution of Daily Income — 1970",
       x = "Dollars Per Day", y = "Count") +
  theme_minimal()

# --- 6c. Same histogram on log2 scale (reveals two-peak structure) ---
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black", fill = "steelblue") +
  scale_x_continuous(trans = "log2") +
  labs(title = "Distribution of Daily Income — 1970 (Log2 Scale)",
       x = "Dollars Per Day (log2)", y = "Count") +
  theme_minimal()


# ============================================================
# SECTION 7: Wealth by Region — Boxplots
# ============================================================

# How many regions are there?
length(levels(gapminder$region))

# --- 7a. Basic boxplot by region ---
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(region, dollars_per_day)) +
  geom_boxplot() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "GDP Per Day by Region — 1970",
       x = "", y = "Dollars Per Day")

# --- 7b. Reorder regions by median income + color by continent ---
p <- gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  mutate(region = reorder(region, dollars_per_day, FUN = median)) %>%
  ggplot(aes(region, dollars_per_day, fill = continent)) +
  geom_boxplot() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("")

# Raw scale
p + labs(title = "GDP Per Day by Region (Ordered by Median) — 1970")

# Log2 y-axis (better for skewed income data)
p + scale_y_continuous(trans = "log2") +
  labs(title = "GDP Per Day by Region (Log2) — 1970")

# Log2 y-axis + individual country data points
p + scale_y_continuous(trans = "log2") +
  geom_point(size = 0.8, alpha = 0.5) +
  labs(title = "GDP Per Day by Region (Log2 + Data Points) — 1970")


# ============================================================
# SECTION 8: West vs Developing Countries
# ============================================================

# Define "Western" regions
west <- c("Western Europe", "Northern Europe", "Southern Europe",
          "Northern America", "Australia and New Zealand")

# Countries with data available in BOTH years (fair comparison)
country_list_1 <- gapminder %>%
  filter(year == past_year    & !is.na(dollars_per_day)) %>%
  pull(country)   # FIX: replaced .$country with pull() — modern tidyverse idiom

country_list_2 <- gapminder %>%
  filter(year == present_year & !is.na(dollars_per_day)) %>%
  pull(country)

country_list <- intersect(country_list_1, country_list_2)

# --- 8a. Histogram: West vs Developing in 1970 ---
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black", fill = "steelblue") +
  scale_x_continuous(trans = "log2") +
  facet_grid(. ~ group) +
  labs(title = "Income Distribution: West vs Developing — 1970",
       x = "Dollars Per Day (log2)", y = "Count") +
  theme_minimal()

# --- 8b. Compare 1970 vs 2010 side by side ---
gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black", fill = "steelblue") +
  scale_x_continuous(trans = "log2") +
  facet_grid(year ~ group) +
  labs(title = "Income Distribution: West vs Developing — 1970 vs 2010",
       x = "Dollars Per Day (log2)", y = "Count") +
  theme_minimal()

# --- 8c. Boxplot comparison 1970 vs 2010 by region ---
p <- gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  mutate(region = reorder(region, dollars_per_day, FUN = median)) %>%
  ggplot() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("") +
  scale_y_continuous(trans = "log2")

# Faceted by year (stacked)
p + geom_boxplot(aes(region, dollars_per_day, fill = continent)) +
  facet_grid(year ~ .) +
  labs(title = "Regional Income Distribution: 1970 vs 2010 (Faceted)")

# Same year side by side (colored by year)
p + geom_boxplot(aes(region, dollars_per_day, fill = factor(year))) +
  labs(title = "Regional Income Distribution: 1970 vs 2010 (Side by Side)",
       fill = "Year")


# ============================================================
# SECTION 9: Density Plots — Income Distribution
# ============================================================

# --- 9a. Simple West vs Developing density (1970 only) ---
gapminder %>%
  filter(year == past_year & country %in% country_list) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  ggplot(aes(dollars_per_day, y = after_stat(count), fill = group)) +
  scale_x_continuous(trans = "log2") +
  geom_density(alpha = 0.2, bw = 0.75) +
  labs(title = "Income Density: West vs Developing — 1970",
       x = "Dollars Per Day (log2)", y = "Count") +
  theme_minimal()

# --- 9b. Assign countries to 5 global groups ---
# FIX: original used .$region and .$continent (old data.table-style notation)
#      inside case_when — this is fragile in dplyr. Use bare column names.
gapminder <- gapminder %>%
  mutate(group = case_when(
    region %in% west                                              ~ "West",
    region %in% c("Eastern Asia", "South-Eastern Asia")          ~ "East Asia",
    region %in% c("Caribbean", "Central America", "South America") ~ "Latin America",
    continent == "Africa" & region != "Northern Africa"           ~ "Sub-Saharan Africa",
    TRUE                                                          ~ "Others"
  )) %>%
  mutate(group = factor(group,
                        levels = c("Others", "Latin America", "East Asia",
                                   "Sub-Saharan Africa", "West")))

# --- 9c. Stacked density: 1970 vs 2010, 5 groups ---
gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  ggplot(aes(dollars_per_day, fill = group)) +
  scale_x_continuous(trans = "log2") +
  geom_density(alpha = 0.2, bw = 0.75, position = "stack") +
  facet_grid(year ~ .) +
  labs(title = "Income Distribution by World Region: 1970 vs 2010",
       x = "Dollars Per Day (log2)", y = "Density") +
  theme_minimal()

# --- 9d. Population-weighted density (accounts for country size) ---
# FIX: original weight = population/sum(population*2) was incorrect —
#      multiplying sum by 2 gives arbitrary weights that don't sum to 1.
#      Correct formula: weight = population / sum(population)
gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  group_by(year) %>%
  mutate(weight = population / sum(population)) %>%
  ungroup() %>%
  ggplot(aes(dollars_per_day, fill = group, weight = weight)) +
  scale_x_continuous(trans = "log2") +
  geom_density(alpha = 0.2, bw = 0.75, position = "stack") +
  facet_grid(year ~ .) +
  labs(title = "Population-Weighted Income Distribution: 1970 vs 2010",
       x = "Dollars Per Day (log2)", y = "Weighted Density") +
  theme_minimal()


# ============================================================
# SECTION 10: Infant Survival Rate vs Income
#             (Demonstrating the Ecological Fallacy)
# ============================================================

present_year <- 2010

# --- 10a. Reassign detailed global groups ---
# FIX: removed .$region / .$continent notation — use bare names in case_when
gapminder <- gapminder %>%
  mutate(group = case_when(
    region %in% west                                                ~ "The West",
    region == "Northern Africa"                                     ~ "Northern Africa",
    region %in% c("Eastern Asia", "South-Eastern Asia")            ~ "East Asia",
    region == "Southern Asia"                                       ~ "Southern Asia",
    region %in% c("Central America", "South America", "Caribbean") ~ "Latin America",
    continent == "Africa" & region != "Northern Africa"            ~ "Sub-Saharan Africa",
    region %in% c("Melanesia", "Micronesia", "Polynesia")          ~ "Pacific Islands"
  ))

# --- 10b. Group-level summary: average income + infant survival ---
surv_income <- gapminder %>%
  filter(year == present_year & !is.na(gdp) &
           !is.na(infant_mortality) & !is.na(group)) %>%
  group_by(group) %>%
  summarize(
    income              = sum(gdp) / sum(population) / 365,
    infant_survival_rate = 1 - sum(infant_mortality / 1000 * population) / sum(population)
  )

surv_income %>% arrange(income)

# --- 10c. Quick label plot (region averages) ---
surv_income %>%
  ggplot(aes(income, infant_survival_rate, label = group, color = group)) +
  scale_x_continuous(trans = "log2", limits = c(0.25, 150)) +
  scale_y_continuous(trans = "logit",
                     limits = c(0.875, 0.9981),
                     breaks = c(0.85, 0.90, 0.95, 0.99, 0.995, 0.998)) +
  geom_label_repel(size = 3, show.legend = FALSE) +
  labs(title = "Income vs Infant Survival Rate (Regional Averages)",
       x = "Income — Dollars Per Day (log2 scale)",
       y = "Infant Survival Rate (logit scale)") +
  theme_minimal()

# --- 10d. Polished version with points + labels (region averages) ---
ggplot(surv_income, aes(x = income, y = infant_survival_rate,
                        label = group, color = group)) +
  scale_x_continuous(trans = "log2", limits = c(0.25, 150)) +
  scale_y_continuous(trans = "logit",
                     limits = c(0.875, 0.9981),
                     breaks = c(0.85, 0.90, 0.95, 0.99, 0.995, 0.998)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_text_repel(size = 3, show.legend = FALSE) +
  labs(title    = "Income vs Infant Survival Rate",
       subtitle = "Each point = regional average",
       x        = "Income — Dollars Per Day (log2 scale)",
       y        = "Infant Survival Rate (logit scale)",
       color    = "World Region") +
  theme_minimal(base_size = 14) +
  theme(
    plot.title    = element_text(hjust = 0.5, size = 18, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    axis.title.x  = element_text(size = 13, face = "bold"),
    axis.title.y  = element_text(size = 13, face = "bold"),
    legend.position    = "right",
    panel.grid.major   = element_line(color = "grey80"),
    panel.grid.minor   = element_blank()
  )

# --- 10e. Country-level plot (exposes ecological fallacy) ---
# Regional averages hide the large variation WITHIN regions.
# Plotting individual countries reveals this.
present_year <- 2009   # 2009 used here as data is more complete

gapminder <- gapminder %>%
  mutate(group = case_when(
    region %in% west                                                ~ "The West",
    region == "Northern Africa"                                     ~ "Northern Africa",
    region %in% c("Eastern Asia", "South-Eastern Asia")            ~ "East Asia",
    region == "Southern Asia"                                       ~ "Southern Asia",
    region %in% c("Central America", "South America", "Caribbean") ~ "Latin America",
    continent == "Africa" & region != "Northern Africa"            ~ "Sub-Saharan Africa",
    region %in% c("Melanesia", "Micronesia", "Polynesia")          ~ "Pacific Islands"
  ))

surv_income_country <- gapminder %>%
  filter(year == present_year & !is.na(gdp) &
           !is.na(infant_mortality) & !is.na(group)) %>%
  mutate(
    income               = gdp / population / 365,
    infant_survival_rate = 1 - (infant_mortality / 1000)
  ) %>%
  select(country, income, infant_survival_rate, region, group)

ggplot(surv_income_country,
       aes(x = income, y = infant_survival_rate, label = country, color = group)) +
  scale_x_continuous(trans = "log2", limits = c(0.25, 150)) +
  scale_y_continuous(trans = "logit",
                     limits = c(0.875, 0.9981),
                     breaks = c(0.85, 0.90, 0.95, 0.99, 0.995, 0.998)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_text_repel(size = 2, show.legend = FALSE, max.overlaps = 20) +
  labs(title    = "Income vs Infant Survival Rate by Country",
       subtitle = "Ecological fallacy: within-region variation is large",
       x        = "Income — Dollars Per Day (log2 scale)",
       y        = "Infant Survival Rate (logit scale)",
       color    = "World Region") +
  theme_minimal(base_size = 14) +
  theme(
    plot.title    = element_text(hjust = 0.5, size = 18, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, color = "grey40"),
    axis.title.x  = element_text(size = 13, face = "bold"),
    axis.title.y  = element_text(size = 13, face = "bold"),
    legend.position    = "right",
    panel.grid.major   = element_line(color = "grey80"),
    panel.grid.minor   = element_blank()
  )
