# Power BI Report

## Planned report pages
1. **Executive overview:** revenue, orders, sessions, conversion rate, AOV and revenue per session.
2. **Acquisition performance:** sessions, orders, conversion and revenue by channel/campaign.
3. **Product and refunds:** product performance, refunded value and refund rate.
4. **Trends:** daily/weekly/monthly movement and notable changes.

## Modelling notes
- Confirm the actual CSV schema before creating relationships.
- Prefer a star schema with clearly defined fact and dimension tables where appropriate.
- Create a dedicated date table for time intelligence.
- Validate every measure against an independently calculated SQL/Python result.
- Document filter behaviour and metric definitions.

Power BI Service can be used to get started, but some modelling and authoring features require Power BI Desktop.
