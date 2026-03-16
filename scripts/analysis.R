# ============================================================
# Relationship Between Rising Rent Costs and Homelessness in WA
# University of Washington Bothell — Data Analysis Project
# Authors: Alisa Seng Chea, Duke Sarankhuu, Tarang Jammalamadaka
# Data: Zillow ZORI (2015–2024) + HUD Point-in-Time Count
# ============================================================

library(tidyverse)
library(readr)
library(ggplot2)
library(scales)

# ── 1. LOAD & CLEAN ZILLOW RENT DATA ─────────────────────────────────────────

rent_raw <- read_csv("data/zillow_rent_index_wa.csv")

# Filter Washington State metros only
wa_rent <- rent_raw %>%
  filter(StateName == "WA")

# Pivot from wide (one column per month) to long format
wa_rent_long <- wa_rent %>%
  select(-RegionID, -SizeRank, -RegionType, -StateName) %>%
  pivot_longer(-RegionName, names_to = "date", values_to = "rent") %>%
  mutate(
    date = as.Date(date),
    year = as.integer(format(date, "%Y"))
  ) %>%
  filter(!is.na(rent))

# Average monthly rent across all WA metros per year
wa_rent_annual <- wa_rent_long %>%
  filter(year >= 2015, year <= 2024) %>%
  group_by(year) %>%
  summarise(avg_rent = mean(rent, na.rm = TRUE), .groups = "drop") %>%
  mutate(pct_change_rent = round((avg_rent - avg_rent[year == 2015]) /
                                    avg_rent[year == 2015] * 100, 2))

# ── 2. HUD POINT-IN-TIME HOMELESSNESS DATA ────────────────────────────────────
# Source: HUD Point-in-Time Estimates by State, 2007–2024
# https://www.hudexchange.info/resource/3031/pit-and-hic-data-since-2007/

hud_wa <- tibble(
  year        = 2015:2024,
  homeless    = c(19419, 20827, 21112, 22304, 21577, 22923,
                  11511, 25211, 28036, 31554)
) %>%
  mutate(pct_change_homeless = round((homeless - homeless[year == 2015]) /
                                        homeless[year == 2015] * 100, 2))

# ── 3. MERGE DATASETS ─────────────────────────────────────────────────────────

combined <- wa_rent_annual %>%
  left_join(hud_wa, by = "year")

cat("\n=== Combined Dataset (2015–2024) ===\n")
print(combined)

# ── 4. CHART 1 — Average Monthly Rent ─────────────────────────────────────────

chart1 <- ggplot(wa_rent_annual, aes(x = factor(year), y = avg_rent)) +
  geom_col(fill = "#2E6DA4", width = 0.7) +
  geom_text(
    aes(label = paste0(ifelse(pct_change_rent == 0, "0%",
                              paste0("+", pct_change_rent, "%")),
                       "\n$", round(avg_rent))),
    vjust = -0.4, size = 2.8, color = "#333333"
  ) +
  scale_y_continuous(
    labels = dollar_format(),
    limits = c(0, 2200),
    expand = expansion(mult = c(0, 0.12))
  ) +
  labs(
    title    = "Average Monthly Rent in Washington State (2015–2024)",
    subtitle = "Average Rent with % Change from 2015",
    x        = "Year",
    y        = "Average Rent ($)",
    caption  = "Source: Zillow Research Data"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold"),
    panel.grid.major.x = element_blank(),
    axis.text.x   = element_text(angle = 0)
  )

ggsave("output/chart1_avg_rent.png", chart1, width = 10, height = 6, dpi = 150)
cat("✓ Chart 1 saved\n")

# ── 5. CHART 2 — Total Homelessness ──────────────────────────────────────────

chart2 <- ggplot(hud_wa, aes(x = factor(year), y = homeless)) +
  geom_col(fill = "#E05A3A", width = 0.7) +
  geom_text(
    aes(label = paste0(ifelse(pct_change_homeless >= 0,
                              paste0("+", pct_change_homeless, "%"),
                              paste0(pct_change_homeless, "%")),
                       "\n", format(homeless, big.mark = ","))),
    vjust = -0.4, size = 2.8, color = "#333333"
  ) +
  scale_y_continuous(
    labels = comma,
    limits = c(0, 38000),
    expand = expansion(mult = c(0, 0.12))
  ) +
  labs(
    title    = "Total Homelessness in Washington State (2015–2024)",
    subtitle = "Point-in-Time (PIT) Count with % Change from 2015",
    x        = "Year",
    y        = "Number of Homeless Individuals",
    caption  = "Source: HUD Point-in-Time Count"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold"),
    panel.grid.major.x = element_blank()
  )

ggsave("output/chart2_homelessness.png", chart2, width = 10, height = 6, dpi = 150)
cat("✓ Chart 2 saved\n")

# ── 6. CHART 3 — Rent vs. Homelessness Scatter ───────────────────────────────

year_colors <- c(
  "2015" = "#A8D8EA", "2016" = "#2E6DA4", "2017" = "#A8E6CF",
  "2018" = "#2D9E5F", "2019" = "#F4A3A3", "2020" = "#D9534F",
  "2021" = "#F5C97A", "2022" = "#E87722", "2023" = "#C5A3D9",
  "2024" = "#4A235A"
)

chart3 <- ggplot(combined, aes(x = avg_rent, y = homeless,
                                color = factor(year), label = year)) +
  geom_smooth(method = "lm", se = FALSE, linetype = "dashed",
              color = "gray50", linewidth = 0.8) +
  geom_point(size = 6) +
  geom_text(vjust = -1, size = 3.2, fontface = "bold", color = "black") +
  scale_x_continuous(labels = dollar_format(), limits = c(950, 1750)) +
  scale_y_continuous(labels = comma, limits = c(8000, 35000)) +
  scale_color_manual(values = year_colors, name = "Year") +
  labs(
    title    = "Rent vs. Homelessness in Washington State (2015–2024)",
    subtitle = "Each point represents one year — dashed line shows trend",
    x        = "Average Monthly Rent ($)",
    y        = "Total Homeless Individuals",
    caption  = "Sources: Zillow Research Data & HUD PIT Count"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"))

ggsave("output/chart3_rent_vs_homelessness.png", chart3,
       width = 10, height = 7, dpi = 150)
cat("✓ Chart 3 saved\n")

# ── 7. CORRELATION & SUMMARY STATS ───────────────────────────────────────────

# Exclude 2021 outlier (COVID eviction moratorium)
combined_no_outlier <- combined %>% filter(year != 2021)

cat("\n=== Correlation: Rent vs. Homelessness ===\n")
cat("All years (2015–2024):         r =",
    round(cor(combined$avg_rent, combined$homeless), 3), "\n")
cat("Excluding 2021 (COVID outlier): r =",
    round(cor(combined_no_outlier$avg_rent, combined_no_outlier$homeless), 3), "\n")

cat("\n=== Key Findings ===\n")
cat("Rent increase 2015–2024:       +",
    round(combined$pct_change_rent[combined$year == 2024], 1), "%\n", sep = "")
cat("Homelessness increase 2015–2024: +",
    round(combined$pct_change_homeless[combined$year == 2024], 1), "%\n", sep = "")
cat("2021 outlier: homelessness dropped to",
    format(hud_wa$homeless[hud_wa$year == 2021], big.mark = ","),
    "(COVID eviction protections + rental assistance)\n")
cat("2024 peak: both rent ($",
    round(combined$avg_rent[combined$year == 2024]),
    ") and homelessness (",
    format(combined$homeless[combined$year == 2024], big.mark = ","),
    ") at all-time highs\n", sep = "")
