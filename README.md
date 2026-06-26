# BrewMetrics FP&A — SQL Reporting Warehouse & Automated Dashboard

A SQL-driven **financial reporting and monitoring** project that turns transaction-level budget and actuals data into an automated FP&A dashboard. It pairs a small **star-schema data warehouse** (SQLite) with a library of analytical **SQL** queries and a **Streamlit** dashboard — demonstrating the kind of *scalable, repeatable reporting* that FP&A teams build to replace manual spreadsheets.

---

## Why this project

FP&A increasingly runs on databases and BI tools, not just Excel. This project shows the full path: **raw financial data → SQL warehouse → analytical queries → live management dashboard**, refreshed automatically whenever the underlying data changes.

---

## Architecture

```
fpa.sql  ──build_db.py──►  fpa.db (SQLite star schema)  ──SQL──►  dashboard.py (Streamlit)
```

**Star schema**
- `dim_department` — Sales, Marketing, Operations, G&A
- `dim_account` — 8 revenue/expense accounts, each tagged Income / COGS / Opex
- `fact_financials` — monthly `budget` and `actual` per department × account (Jan–Jun, 48 rows)

---

## Files

| File | Description |
|------|-------------|
| `fpa.sql` | DDL + synthetic data for the warehouse |
| `build_db.py` | Builds `fpa.db` from `fpa.sql` |
| `queries.sql` | 6 analytical FP&A queries (see below) |
| `dashboard.py` | Streamlit reporting dashboard |

---

## Analytical queries (`queries.sql`)

1. **Monthly P&L** — budget vs. actual (Revenue, COGS, Opex, Operating Income)
2. **Variance by department** — $ and % over the full period
3. **Top line-item variances** — sign-aware Favorable / Unfavorable flag
4. **Gross margin % trend**
5. **Opex-to-revenue %** (efficiency monitoring)
6. **3-month rolling average revenue** (SQL window function)

---

## The dashboard

`dashboard.py` renders:
- **KPI cards** — Revenue vs. budget, Gross Margin %, Opex/Revenue %, Operating Income & margin
- **Revenue: Budget vs. Actual** by month
- **Margin & efficiency trend** lines
- **Variance by department** and **largest line-item variances** tables

---

## Run it

```bash
pip install streamlit pandas
python build_db.py          # creates fpa.db
streamlit run dashboard.py  # opens the dashboard
```

---

## Skills demonstrated

- **SQL**: joins, `CASE`-based pivoting, aggregation, window functions
- **Data modeling**: star schema (fact + dimensions) for financial reporting
- **Automated / scalable reporting & monitoring** (a stated FP&A preferred qualification)
- **Python + Streamlit + pandas** for BI-style dashboards
- Translating financial data into KPIs and variance insight

---

## Author

**Jose Thomas** — M.S. Statistics & Data Science, B.S. Mathematics
[LinkedIn](https://www.linkedin.com/in/jose-thomas-852b67290/)
