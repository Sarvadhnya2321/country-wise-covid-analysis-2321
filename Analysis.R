# analysis.R
# IMC503 — Country-wise COVID Analysis (pie fixed, boxplot removed, + line chart)
# Author: Sarvadhnya Patil (2321)
# Usage: in RStudio -> source("analysis.R")  OR  Rscript analysis.R
#
# Requirements: readr, dplyr, ggplot2, scales, stringr, ggrepel, rstudioapi
# The script attempts to install missing packages automatically.

## ---------------- Setup ----------------
required <- c("readr","dplyr","ggplot2","scales","stringr","ggrepel","rstudioapi")
missing_pkgs <- required[!(required %in% rownames(installed.packages()))]
if (length(missing_pkgs) > 0) install.packages(missing_pkgs, dependencies = TRUE)
library(readr); library(dplyr); library(ggplot2); library(scales); library(stringr); library(ggrepel)

# If running in RStudio, set working directory to the script folder (so images/ is predictable)
if (interactive() && requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::hasFun("getActiveDocumentContext")) {
  sp <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(sp)) setwd(dirname(sp))
}

## ---------------- Config ----------------
csv_file <- "C:\\Users\\sarva\\OneDrive\\Desktop\\SEA_DST\\country-wise-covid-analysis-2321\\country_wise_latest.csv"
img_dir  <- file.path(getwd(), "images"); dir.create(img_dir, showWarnings = FALSE)
out_pdf  <- file.path(getwd(), "plots_R.pdf")

TOP_N     <- 10    # top N for bar charts / line
SCATTER_N <- 50    # how many countries to include in scatter
img_w <- 10; img_h <- 7; img_dpi <- 200

## ---------------- Helpers ----------------
find_col <- function(df, candidates) {
  nm <- names(df)
  for (c in candidates) {
    m <- nm[tolower(nm) == tolower(c)]
    if (length(m)) return(m[1])
  }
  for (c in candidates) {
    ix <- grep(tolower(c), tolower(nm))
    if (length(ix)) return(nm[ix[1]])
  }
  NA_character_
}

save_and_show <- function(plot_obj, fname) {
  fpath <- file.path(img_dir, fname)
  ggsave(filename = fpath, plot = plot_obj, width = img_w, height = img_h, dpi = img_dpi)
  message("Saved: ", fpath)
  if (interactive()) {
    print(plot_obj)
    readline(prompt = "Plot displayed. Press [Enter] in the console to continue...")
  }
}

## ---------------- Read data ----------------
if (!file.exists(csv_file)) stop("CSV not found at path: ", csv_file)
df <- read_csv(csv_file, show_col_types = FALSE)

# tidy column names
names(df) <- gsub("\\s+", "_", str_trim(names(df)))

# detect columns (flexible naming)
country_col    <- find_col(df, c("Country/Region","Country","Country_Region"))
confirmed_col  <- find_col(df, c("Confirmed","Total_cases","TotalConfirmed","ConfirmedCases"))
deaths_col     <- find_col(df, c("Deaths","Total_deaths","TotalDeaths"))
recovered_col  <- find_col(df, c("Recovered","Total_recovered","Total_Recovered"))
active_col     <- find_col(df, c("Active","Active_cases","Active_Cases"))
population_col <- find_col(df, c("Population","Pop","population"))
who_col        <- find_col(df, c("WHO_Region","WHO Region","WHORegion","WHO_Region"))

if (any(is.na(c(country_col, confirmed_col, deaths_col)))) {
  stop("Required columns not found automatically. Ensure CSV contains Country, Confirmed, Deaths.")
}

# numeric conversion for relevant columns
num_cols <- unique(na.omit(c(confirmed_col, deaths_col, recovered_col, active_col, population_col)))
for (c in num_cols) df[[c]] <- as.numeric(df[[c]])

# derived metrics
df <- df %>% mutate(
  CFR = ifelse(!is.na(.data[[confirmed_col]]) & .data[[confirmed_col]]>0,
               100 * .data[[deaths_col]] / .data[[confirmed_col]], NA_real_)
)
if (!is.na(population_col)) df <- df %>% mutate(cases_per_million = .data[[confirmed_col]]/(.data[[population_col]]/1e6))

## ---------------- Plot 1: bar_top_confirmed ----------------
p_bar_confirmed <- (function() {
  dat <- df %>% filter(!is.na(.data[[confirmed_col]])) %>% arrange(desc(.data[[confirmed_col]])) %>% slice_head(n = TOP_N) %>% mutate(country = .data[[country_col]])
  p <- ggplot(dat, aes(x = reorder(country, .data[[confirmed_col]]), y = .data[[confirmed_col]])) +
    geom_col(fill = "#2b8cbe") + coord_flip() +
    scale_y_continuous(labels = comma) +
    labs(title = paste0("Top ", TOP_N, " Countries — Confirmed Cases"), x = NULL, y = "Confirmed cases") +
    theme_minimal(base_size = 13) + theme(plot.title = element_text(hjust = 0.5))
  save_and_show(p, "bar_top_confirmed.png")
  p
})()

## ---------------- Plot 2: bar_top_deaths ----------------
p_bar_deaths <- (function() {
  dat <- df %>% filter(!is.na(.data[[deaths_col]])) %>% arrange(desc(.data[[deaths_col]])) %>% slice_head(n = TOP_N) %>% mutate(country = .data[[country_col]])
  p <- ggplot(dat, aes(x = reorder(country, .data[[deaths_col]]), y = .data[[deaths_col]])) +
    geom_col(fill = "#f03b20") + coord_flip() +
    scale_y_continuous(labels = comma) +
    labs(title = paste0("Top ", TOP_N, " Countries — Deaths"), x = NULL, y = "Deaths") +
    theme_minimal(base_size = 13) + theme(plot.title = element_text(hjust = 0.5))
  save_and_show(p, "bar_top_deaths.png")
  p
})()

## ---------------- Plot 3: scatter_cases_vs_deaths ----------------
p_scatter <- (function() {
  dat <- df %>% filter(!is.na(.data[[confirmed_col]]) & !is.na(.data[[deaths_col]])) %>% arrange(desc(.data[[confirmed_col]])) %>% slice_head(n = SCATTER_N) %>% mutate(country = .data[[country_col]], region = ifelse(!is.na(.data[[who_col]]), as.character(.data[[who_col]]), "Unknown"))
  p <- ggplot(dat, aes(x = .data[[confirmed_col]], y = .data[[deaths_col]], color = region)) +
    geom_point(size = 3, alpha = 0.85) +
    scale_x_continuous(labels = comma) + scale_y_continuous(labels = comma) +
    labs(title = paste0("Cases vs Deaths — Top ", SCATTER_N, " Countries"), x = "Confirmed cases", y = "Deaths", color = ifelse(!is.na(who_col),"WHO Region","")) +
    theme_minimal(base_size = 12) + theme(plot.title = element_text(hjust = 0.5))
  lab <- dat %>% arrange(desc(.data[[confirmed_col]])) %>% slice_head(n = 8)
  p <- p + geom_text_repel(data = lab, aes(label = country), size = 3, max.overlaps = 8)
  save_and_show(p, "scatter_cases_vs_deaths.png")
  p
})()

## ---------------- Plot 4: histogram_cases_distribution ----------------
p_hist <- (function() {
  dat <- df %>% filter(!is.na(.data[[confirmed_col]]))
  p <- ggplot(dat, aes(x = .data[[confirmed_col]])) +
    geom_histogram(bins = 40, fill = "#8da0cb", color = "white") +
    scale_y_log10() + scale_x_continuous(labels = comma) +
    labs(title = "Distribution of Confirmed Cases (log-scaled counts)", x = "Confirmed cases", y = "Count (log scale)") +
    theme_minimal(base_size = 12) + theme(plot.title = element_text(hjust = 0.5))
  save_and_show(p, "histogram_cases_distribution.png")
  p
})()

## ---------------- Plot 5: bar_top_recovered (optional) ----------------
p_bar_recovered <- (function() {
  if (is.na(recovered_col)) return(NULL)
  dat <- df %>% filter(!is.na(.data[[recovered_col]])) %>% arrange(desc(.data[[recovered_col]])) %>% slice_head(n = TOP_N) %>% mutate(country = .data[[country_col]])
  if (nrow(dat)==0) return(NULL)
  p <- ggplot(dat, aes(x = reorder(country, .data[[recovered_col]]), y = .data[[recovered_col]])) +
    geom_col(fill = "#6baed6") + coord_flip() + scale_y_continuous(labels = comma) +
    labs(title = paste0("Top ", TOP_N, " Countries — Recovered"), x = NULL, y = "Recovered") +
    theme_minimal(base_size = 13) + theme(plot.title = element_text(hjust = 0.5))
  save_and_show(p, "bar_top_recovered.png")
  p
})()

## ---------------- Plot 6: bar_top_active (optional) ----------------
p_bar_active <- (function() {
  if (is.na(active_col)) return(NULL)
  dat <- df %>% filter(!is.na(.data[[active_col]])) %>% arrange(desc(.data[[active_col]])) %>% slice_head(n = TOP_N) %>% mutate(country = .data[[country_col]])
  if (nrow(dat)==0) return(NULL)
  p <- ggplot(dat, aes(x = reorder(country, .data[[active_col]]), y = .data[[active_col]])) +
    geom_col(fill = "#f1a340") + coord_flip() + scale_y_continuous(labels = comma) +
    labs(title = paste0("Top ", TOP_N, " Countries — Active Cases"), x = NULL, y = "Active cases") +
    theme_minimal(base_size = 13) + theme(plot.title = element_text(hjust = 0.5))
  save_and_show(p, "bar_top_active.png")
  p
})()

## ---------------- Plot 7: line_confirmed_deaths_recovered (new) ----------------
p_line_metrics <- (function() {
  # Create line chart comparing Confirmed / Deaths / Recovered for top TOP_N countries
  top_countries <- df %>% filter(!is.na(.data[[confirmed_col]])) %>% arrange(desc(.data[[confirmed_col]])) %>% slice_head(n = TOP_N) %>% pull(.data[[country_col]])
  dat <- df %>% filter(.data[[country_col]] %in% top_countries) %>% 
    select(all_of(c(country_col, confirmed_col, deaths_col, recovered_col))) %>%
    rename(country = !!country_col, Confirmed = !!confirmed_col, Deaths = !!deaths_col)
  # include recovered if available
  if (!is.na(recovered_col)) {
    dat <- dat %>% rename(Recovered = !!recovered_col)
    long <- dat %>% tidyr::pivot_longer(cols = c("Confirmed","Deaths","Recovered"), names_to = "Metric", values_to = "Value")
  } else {
    long <- dat %>% tidyr::pivot_longer(cols = c("Confirmed","Deaths"), names_to = "Metric", values_to = "Value")
  }
  # keep the country order as factor by confirmed rank
  order_country <- df %>% filter(!is.na(.data[[confirmed_col]])) %>% arrange(desc(.data[[confirmed_col]])) %>% slice_head(n = TOP_N) %>% pull(.data[[country_col]])
  long$country <- factor(long$country, levels = order_country)
  p <- ggplot(long, aes(x = country, y = Value, color = Metric, group = Metric)) +
    geom_line(aes(linetype = Metric), size = 1) +
    geom_point(size = 2) +
    scale_y_continuous(labels = comma) +
    labs(title = paste0("Confirmed / Deaths", ifelse(!is.na(recovered_col), " / Recovered", ""), " — Top ", TOP_N, " Countries"),
         x = "Country (ranked by confirmed)", y = "Count", color = "Metric") +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle = 35, hjust = 1))
  save_and_show(p, "line_top_countries_metrics.png")
  p
})()

## ---------------- Plot 8: pie_who_region (clean legend, no slice labels) ----------------
p_pie <- (function() {
  if (is.na(who_col)) return(NULL)
  dat <- df %>% filter(!is.na(.data[[confirmed_col]])) %>% group_by(.data[[who_col]]) %>% summarise(total = sum(.data[[confirmed_col]], na.rm = TRUE)) %>% arrange(desc(total)) %>% mutate(region = as.character(.data[[who_col]]))
  if (nrow(dat)==0) return(NULL)
  dat <- dat %>% mutate(pct = round(100 * total / sum(total), 1), legend_label = paste0(region, " — ", pct, "%"))
  p <- ggplot(dat, aes(x = "", y = total, fill = region)) +
    geom_col(width = 1, color = "white") +
    coord_polar(theta = "y") +
    theme_void() +
    labs(title = "Confirmed Cases — WHO Region Share") +
    theme(plot.title = element_text(hjust = 0.5), legend.title = element_blank(), legend.text = element_text(size = 10))
  p <- p + scale_fill_discrete(labels = dat$legend_label)
  p <- p + xlim(-1.2, 1.2)
  save_and_show(p, "pie_who_region.png")
  p
})()

## ---------------- Combined PDF ----------------
plots <- list(p_bar_confirmed, p_bar_deaths, p_scatter, p_hist, p_bar_recovered, p_bar_active, p_line_metrics, p_pie)
pdf(out_pdf, width = 11, height = 8.5)
for (p in plots) if (!is.null(p)) print(p)
dev.off()
message("Combined PDF written to: ", out_pdf)
message("Individual image files saved in: ", img_dir)
