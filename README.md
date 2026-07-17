# Kenya Climate Analytics Dashboard

### Interactive R Shiny Dashboard for County-Level Temperature and Rainfall Trend Analysis (1990–2018)

WeatherInformant is an interactive climate analytics dashboard built with **R Shiny** to explore historical temperature and rainfall patterns across Kenya's 46 counties. The application transforms nearly three decades of meteorological data into interactive visualizations and statistical summaries that support climate research, agricultural planning, and evidence-based decision-making.

---

## Business Problem

Climate variability poses significant challenges to agriculture, water resource management, infrastructure development, disaster preparedness, and public health in Kenya.

Although historical climate records are available, they are often distributed across static reports that make exploratory analysis difficult. Decision-makers require interactive tools that enable them to understand long-term climate trends, compare counties, and identify spatial and temporal climate patterns.

This project demonstrates how statistical computing and interactive visualization can transform historical climate data into actionable insights.

---

## Project Overview

WeatherInformant analyzes monthly temperature and rainfall records collected between **1990 and 2018** across **46 Kenyan counties**.

Using an interactive R Shiny dashboard, users can explore:

- Long-term temperature trends
- Rainfall variability
- County-level climate comparisons
- Seasonal climate patterns
- Statistical summaries
- Interactive visualizations for decision support

The dashboard was developed as part of a Master's course in Statistical Computing and has been enhanced as a professional portfolio project.

---

## Business Value

The dashboard supports evidence-based climate analysis by enabling stakeholders to:

- Monitor long-term climate variability
- Compare climate characteristics across counties
- Support agricultural planning
- Assist drought preparedness and adaptation planning
- Inform environmental research
- Support county-level policy development

---

## Objectives

The project aims to:

- Analyze long-term temperature trends across Kenya.
- Examine rainfall variability between 1990 and 2018.
- Compare climate characteristics across counties.
- Identify seasonal and regional climate patterns.
- Visualize historical climate data interactively.
- Support climate-informed decision-making.

---

## Dataset

**Source**

Kenya Meteorological Department

**Coverage**

- **Period:** 1990–2018
- **Observations:** 16,008 monthly records
- **Geographic Coverage:** 46 Kenyan counties
- **Temporal Resolution:** Monthly

### Variables

- Year
- Month
- County
- Mean Temperature (°C)
- Maximum Temperature (°C)
- Minimum Temperature (°C)
- Monthly Rainfall (mm)
- Date

---

## Statistical Analysis Workflow

```text
Meteorological Data
        ↓
Data Cleaning
        ↓
Exploratory Data Analysis
        ↓
Descriptive Statistics
        ↓
Trend Analysis
        ↓
County Comparison
        ↓
Interactive Visualization
        ↓
Climate Decision Support
```

---

## Dashboard Features

The application provides:

### Climate Trend Analysis

- Mean temperature trends
- Maximum temperature trends
- Minimum temperature trends
- Rainfall trend visualization

### Interactive Exploration

- County selection
- Year filtering
- Dynamic plots
- Interactive statistical summaries

### Statistical Analysis

- Descriptive statistics
- Climate comparisons
- Long-term trend analysis
- Temporal climate exploration

### Decision Support

- County climate profiling
- Climate variability assessment
- Regional comparison
- Evidence-based climate insights

---

## Technologies Used

### Programming Language

- R

### Framework

- Shiny

### Packages

- ggplot2
- dplyr
- tidyverse
- lubridate
- DT
- shiny
- readxl

### Data Source

- Kenya Meteorological Department

---

## Key Insights

Analysis of the historical climate data reveals several important observations:

- Northern counties consistently experience higher average temperatures than the central highlands.
- Western Kenya receives substantially higher rainfall than arid northern counties.
- Temperature and rainfall exhibit clear seasonal patterns across regions.
- County-level comparisons highlight significant spatial climate variability.
- Long-term climate visualization supports environmental planning and climate adaptation initiatives.

---

## Potential Users

This dashboard can support:

- Kenya Meteorological Department
- County Governments
- Agricultural Researchers
- Environmental Scientists
- Climate Researchers
- Disaster Risk Management Agencies
- NGOs
- Students and Researchers

---

## Repository Structure

```text
Kenya_Climate_Analytics_Dashboard/

│── app.R
│── README.md
│── LICENSE
│── .gitignore
│
├── data/
│
├── images/
│
├── report/
│
└── presentation/
```

---

## Screenshots

### Dashboard Home

![Dashboard Home](images/dashboard_home.png)

### Temperature Trends

![Temperature Trends](images/temperature_trends.png)

### Rainfall Analysis

![Rainfall Trends](images/rainfall_trends.png)

### County Comparison

![County Comparison](images/county_comparison.png)

---

## What I Learned

This project strengthened my skills in statistical computing with **R**, interactive dashboard development using **Shiny**, exploratory climate data analysis, and communicating complex environmental data through intuitive visualizations. It also improved my ability to transform long-term meteorological datasets into decision-support tools for researchers, policymakers, and agricultural stakeholders.

---

## Future Improvements

Potential enhancements include:

- Deploy the dashboard using **shinyapps.io**
- Integrate real-time weather APIs
- Add interactive GIS mapping
- Include climate anomaly detection
- Implement rainfall forecasting models
- Develop downloadable climate reports
- Add predictive analytics for climate trends

---

## Data Ethics

The dataset used in this project originates from historical climate observations collected by the Kenya Meteorological Department and is used solely for educational and analytical purposes. The dashboard is intended to demonstrate statistical computing, interactive visualization, and climate analytics techniques.

---

## License

This project is released under the **MIT License**.

---

## Author

**Allan**

Master's Student in Data Science | Data Scientist | Statistical Computing | Machine Learning | Business Intelligence

GitHub: https://github.com/AllanDS-coder
