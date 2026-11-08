# Metric Definitions

Document the exact grain, formula, filters, date logic and known limitations for every KPI before using it in the dashboard.

| Metric | Draft formula | Grain / date rule | Validation notes |
|---|---|---|---|
| Sessions | Distinct session IDs | To be confirmed from source | Check duplicate IDs and session date field |
| Orders | Distinct order IDs | To be confirmed | Confirm order status and date field |
| Conversion rate | Orders / sessions | Align numerator and denominator by chosen cohort/date | Avoid mixing order date with session date without explanation |
| Gross revenue | Sum of order-item revenue | To be confirmed | Confirm whether discounts/tax/shipping are included |
| Average order value | Revenue / distinct orders | Same revenue basis and date scope | Check multi-item orders |
| Revenue per session | Revenue / sessions | Align date attribution | State attribution approach |
| Refund value | Sum of refund amounts | Refund date or original order date; choose and document | Avoid double-counting refunds |
| Refund rate | Refund value / gross revenue | Same population and period | Define treatment of partial refunds |

## Decisions log
Add dated notes here whenever a definition changes. Explain why the change was made and whether previously reported results need to be recalculated.
