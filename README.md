# COVID-19 Country-Wise Analysis  
### **Author:** *Sarvadhnya Patil (2321)*  
### **Dataset:** `country_wise_latest.csv`  
### **Output:** `plots_2321.pdf`

---

## 📌 Overview

This project performs an in-depth **statistical and visual analysis** of global COVID-19 data on a per-country basis.  
All analyses are conducted using **R**, and the results are consolidated into a single PDF containing 8 high-quality visualizations.

The goal is to understand:
- Which countries were most affected  
- How deaths compare to confirmed cases  
- Distribution patterns  
- Regional differences across WHO zones  
- Relationships between key COVID indicators  

---

## 📁 Files Included

| File | Description |
|------|-------------|
| `Analysis.R` | Main R script used to generate plots and the final PDF |
| `country_wise_latest.csv` | Source dataset containing country-level COVID-19 statistics |
| `plots_2321.pdf` | Final compiled PDF containing all visualizations |
| `Findings.md` | Detailed explanation and interpretation of each plot |

---

## 📊 Visualizations Included (in PDF)

The generated **plots_2321.pdf** contains:

1. **Top 10 Countries — Confirmed Cases (Bar Chart)**  
2. **Top 10 Countries — Deaths (Bar Chart)**  
3. **Confirmed vs Deaths (Scatter Plot)**  
4. **Distribution of Confirmed Cases (Histogram)**  
5. **Top 10 Countries — Recovered Cases (Bar Chart)**  
6. **Top 10 Countries — Active Cases (Bar Chart)**  
7. **Confirmed / Deaths / Recovered Comparison (Line Graph)**  
8. **WHO Region Share of Global Cases (Pie Chart)**  

👉 **Download PDF:**  
[plots_2321.pdf](plots_2321.pdf)

---

## ▶️ How to Run the Script

### **In RStudio**
1. Open `Analysis.R`
2. Ensure the CSV path is correct
3. Click **Run All**
4. A PDF named `plots_2321.pdf` will be generated in the same folder

### **Using Terminal**
```bash
Rscript Analysis.R
