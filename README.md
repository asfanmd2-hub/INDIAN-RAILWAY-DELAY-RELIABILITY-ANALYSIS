# Indian Railway Delay & Reliability Analysis 

## 📌 Project Overview

This project analyzes railway journey delays and reliability patterns using **MySQL** and a **500-row synthetic railway journey dataset**. The main objective is to demonstrate practical SQL analytics by transforming raw journey data into meaningful performance metrics and operational insights.

The project follows a simple analytics workflow:

**CSV → MySQL → Data Quality Checks → SQL Analysis → Insights**

> **Note:** The dataset is synthetic sample data created for learning and portfolio purposes. The results should not be considered official Indian Railways statistics.

## 🎯 Objectives

- Analyze overall railway delay performance
- Identify major delay causes
- Compare observed train reliability
- Analyze seasonal delay patterns
- Compare railway zones
- Study peak-hour and weekend delay patterns
- Categorize journeys based on delay severity
- Practice SQL aggregation and analytical queries

## 🛠️ Technologies Used

- **MySQL** – Database creation, data loading, validation, and analysis
- **SQL** – Data aggregation and business analysis
- **CSV** – Source dataset

## 📂 Project Structure

```text
indian-railway-delay-reliability/
│
├── railway_analysis.sql
├── indian_railway_delay_sample_500.csv
└── README.md
```

## 📊 Key SQL Analysis

The SQL file contains seven major analyses:

1. **Overall Delay Performance** – Average delay, maximum delay, delay rate, and on-time rate.
2. **Delay Cause Analysis** – Compares delay frequency and average delay by cause.
3. **Train Reliability Analysis** – Examines observed on-time performance by train.
4. **Seasonal Analysis** – Compares delay patterns across seasons.
5. **Railway Zone Analysis** – Compares observed performance across zones.
6. **Peak Hour & Weekend Analysis** – Examines delays across operating periods.
7. **Delay Severity Analysis** – Categorizes journeys as on-time, minor, moderate, major, or severe delays.

## 🧠 SQL Concepts Demonstrated

`COUNT()` `AVG()` `SUM()` `MAX()` `GROUP BY` `ORDER BY` `ROUND()` `CASE` and **subqueries**.

## 🚀 How to Run

1. Import the CSV data into MySQL.
2. Open `railway_analysis.sql`.
3. Create and select the database.
4. Create the `railway_journeys` table.
5. Load the CSV data.
6. Run the data-quality checks.
7. Execute the analysis queries.

This project demonstrates a complete beginner-to-intermediate **SQL analytics workflow** using a realistic railway-delay scenario.
