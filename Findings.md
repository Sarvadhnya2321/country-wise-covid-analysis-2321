# COVID-19 Country-Wise Data Analysis — Findings Report  
**Author:** *Sarvadhnya Patil (2321)*  
**Course:** Data Science & Analytics  
**Dataset:** `country_wise_latest.csv`

---

## 1. Introduction

This report provides a comprehensive analysis of the **global COVID-19 dataset**, summarizing country-wise confirmed cases, deaths, recoveries, active cases, fatality rate, and regional distribution patterns.

All visualizations were generated using **R** and compiled into a single PDF.

👉 **Download all plots:**  
[plots_2321.pdf](plots_2321.pdf)

---

# 2. Visual Analysis & Insights

Below is the explanation for each statistical visualization included in the PDF.

---

## 2.1 Top 10 Countries by Confirmed Cases

This bar chart displays the countries with the highest confirmed COVID-19 cases.  
It helps identify the global hotspots.

**Key Insights:**
- Countries such as the USA, India, and Brazil dominate the highest counts.  
- The spread is uneven globally, with a few nations contributing to the majority of global cases.

---

## 2.2 Top 10 Countries by Deaths

This plot shows countries with the highest total deaths.

**Key Insights:**
- High-income countries still show large death counts.  
- Indicates early waves overwhelmed healthcare systems.

---

## 2.3 Scatter Plot — Confirmed Cases vs Deaths

This scatter plot compares the confirmed cases with deaths for the top 50 countries.

**Key Insights:**
- There is a clear positive correlation between cases and deaths.  
- Outliers show countries with:
  - **Low deaths despite high cases** (strong healthcare response), or  
  - **High deaths compared to cases** (possible underreporting or weak systems).

---

## 2.4 Histogram — Distribution of Confirmed Cases

A histogram showing how confirmed cases are distributed globally.

**Key Insights:**
- The distribution is **highly right-skewed**.  
- Most countries have relatively low cases, while a few have extremely high counts.  
- Log-scaling highlights this imbalance more clearly.

---

## 2.5 Top 10 Countries by Recovered Cases

This bar chart shows countries with the highest number of recoveries.

**Key Insights:**
- Recovery numbers largely mirror confirmed cases.  
- High-recovery countries correspond with those having high confirmed cases.

---

## 2.6 Top 10 Countries by Active Cases

A bar plot representing countries with the highest active cases.

**Key Insights:**
- High active cases indicate ongoing transmission or recent surges.  
- Suggests current healthcare burden.

---

## 2.7 Line Chart — Confirmed vs Deaths vs Recovered (Top 10 Countries)

A multi-metric line graph showing three critical COVID-19 indicators.

**Key Insights:**
- **Confirmed** is always the highest.  
- **Recovered** trends upward steadily over time.  
- **Deaths** remain significantly below confirmed numbers but follow the same pattern.  
- Shows comparative progression across countries.

---

## 2.8 Pie Chart — WHO Region Share of Global Confirmed Cases

Pie chart that displays what percentage of global cases belong to each WHO region.

**Key Insights:**
- Some WHO regions disproportionately contribute to the global total.  
- Reflects population size, outbreak timing, and reporting ability.

---

# 3. Conclusion

The analysis reveals significant differences across countries and WHO regions.

### **Major Observations:**
- A small number of countries make up the majority of global COVID-19 cases.  
- Recovery and death counts strongly correlate with confirmed cases.  
- Active cases highlight regions with ongoing transmission.  
- WHO region distribution shows unequal spread across the world.  
- The dataset demonstrates clear epidemiological patterns consistent with COVID-19 waves.

### **Overall**, the analysis provides meaningful insight into:
- Country-specific severity  
- Global pandemic burden  
- Regional trends  
- COVID-19 impacts on healthcare systems  

---

# 4. PDF Link

All plots are available in one PDF:

👉 **[Download plots_2321.pdf](plots_2321.pdf)**

---

