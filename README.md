# Executive Business Performance Dashboard

A portfolio project analysing the Maven Fuzzy Factory toy-store e-commerce dataset. The goal is to turn raw website, order, product and refund data into clear business performance insights.

## Business objective
Build an executive-ready view of acquisition, website conversion and commercial performance, then explain what is changing and where the business should investigate.

## Questions to answer
1. How are website sessions, orders and revenue changing over time?
2. Which marketing channels attract the most sessions and orders?
3. How does session-to-order conversion differ by channel and over time?
4. What are average order value (AOV) and revenue per session?
5. How much revenue is refunded, and how does that vary by product?

## Dataset
- Source: [Maven Analytics Toy Store E-Commerce Database](https://mavenanalytics.io/data-playground/toy-store-e-commerce-database)
- Business: Maven Fuzzy Factory, an online toy retailer.
- Format: multiple CSV tables.
- Licence: listed by Maven Analytics as Public Domain.

Download the source files yourself and place the CSVs in `data/raw/`. Keep the originals unchanged. Raw data is excluded from Git by default.

## Project structure
```text
data/raw/                 Original source CSVs (not committed)
data/processed/           Cleaned/derived data (not committed)
notebooks/                Python exploration and analysis
sql/                      SQL profiling and KPI queries
powerbi/                  Power BI model and report notes
reports/figures/          Exported charts
docs/                     Data dictionary and metric definitions
```

## KPI definitions (draft)
- **Sessions:** distinct website session IDs.
- **Orders:** distinct order IDs.
- **Session-to-order conversion:** orders divided by sessions. Confirm the counting grain and date attribution before publishing.
- **Revenue:** sum of order item revenue, subject to validation of the source columns and refund treatment.
- **Average order value:** revenue divided by orders.
- **Revenue per session:** revenue divided by sessions.
- **Refund rate:** refunded value divided by gross order-item revenue. Also consider an order-count refund rate if the data supports it.

These are working definitions, not final results. Record any assumptions and edge cases in `docs/metric_definitions.md`.

## Milestones
1. Download and inspect the dataset; confirm tables, columns, keys and date ranges.
2. Clean and validate the data with Python.
3. Build repeatable SQL analyses.
4. Create a Power BI data model and executive dashboard.
5. Write an insight-led report with recommendations and limitations.

## Tools
Python (pandas), SQL, Power BI, Git/GitHub. Start with the tools you have; Power BI Desktop may be needed later for full modelling and report-authoring features.

## Reproducibility
Install Python dependencies with `pip install -r requirements.txt`. Do not commit credentials, private data, or large raw/processed data files.

## Status
Project scaffold created. Dataset inspection and analysis are not yet complete; no findings or performance claims are being made yet.
