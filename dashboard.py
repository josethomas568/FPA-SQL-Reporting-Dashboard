"""
BrewMetrics FP&A Reporting Dashboard
Automated budget-vs-actual monitoring built on a SQLite warehouse.
Run:  python build_db.py  &&  streamlit run dashboard.py
"""
import sqlite3
import pandas as pd
import streamlit as st

DB = "fpa.db"

st.set_page_config(page_title="BrewMetrics FP&A Dashboard", layout="wide")

@st.cache_data
def q(sql):
    con = sqlite3.connect(DB)
    df = pd.read_sql_query(sql, con)
    con.close()
    return df

st.title("☕ BrewMetrics Coffee Co. — FP&A Reporting Dashboard")
st.caption("Automated budget-vs-actual monitoring · data served from a SQLite warehouse via SQL")

# ---- KPI strip (full-period actuals vs budget) ----
kpi = q("""
SELECT
  SUM(CASE WHEN a.category='Income' THEN f.actual END) AS revenue,
  SUM(CASE WHEN a.category='Income' THEN f.budget END) AS revenue_budget,
  SUM(CASE WHEN a.category='COGS'   THEN f.actual END) AS cogs,
  SUM(CASE WHEN a.category='Opex'   THEN f.actual END) AS opex
FROM fact_financials f JOIN dim_account a ON f.account_id=a.account_id
""").iloc[0]

revenue, rev_bud = kpi.revenue, kpi.revenue_budget
gross_profit = revenue - kpi.cogs
op_income = gross_profit - kpi.opex
c1, c2, c3, c4 = st.columns(4)
c1.metric("Revenue (Actual)", f"${revenue:,.0f}", f"{(revenue-rev_bud)/rev_bud*100:+.1f}% vs budget")
c2.metric("Gross Margin", f"{gross_profit/revenue*100:.1f}%")
c3.metric("Opex / Revenue", f"{kpi.opex/revenue*100:.1f}%")
c4.metric("Operating Income", f"${op_income:,.0f}", f"{op_income/revenue*100:.1f}% margin")

st.divider()
left, right = st.columns(2)

# ---- Monthly revenue: budget vs actual ----
monthly = q("""
SELECT f.month,
  SUM(CASE WHEN a.category='Income' THEN f.budget END) AS Budget,
  SUM(CASE WHEN a.category='Income' THEN f.actual END) AS Actual
FROM fact_financials f JOIN dim_account a ON f.account_id=a.account_id
GROUP BY f.month ORDER BY f.month
""").set_index("month")
left.subheader("Revenue: Budget vs. Actual")
left.bar_chart(monthly)

# ---- Margin trend ----
margin = q("""
SELECT f.month,
  ROUND(100.0*(SUM(CASE WHEN a.category='Income' THEN f.actual END)
             - SUM(CASE WHEN a.category='COGS'   THEN f.actual END))
        / SUM(CASE WHEN a.category='Income' THEN f.actual END),1) AS "Gross Margin %",
  ROUND(100.0*SUM(CASE WHEN a.category='Opex' THEN f.actual END)
        / SUM(CASE WHEN a.category='Income' THEN f.actual END),1) AS "Opex / Revenue %"
FROM fact_financials f JOIN dim_account a ON f.account_id=a.account_id
GROUP BY f.month ORDER BY f.month
""").set_index("month")
right.subheader("Margin & Efficiency Trend")
right.line_chart(margin)

st.divider()

# ---- Variance by department ----
st.subheader("Budget vs. Actual Variance by Department")
dept = q("""
SELECT d.dept_name AS Department,
  SUM(f.budget) AS Budget, SUM(f.actual) AS Actual,
  SUM(f.actual-f.budget) AS "Variance ($)",
  ROUND(100.0*SUM(f.actual-f.budget)/SUM(f.budget),1) AS "Variance (%)"
FROM fact_financials f JOIN dim_department d ON f.dept_id=d.dept_id
GROUP BY d.dept_name ORDER BY "Variance ($)" DESC
""")
st.dataframe(dept, use_container_width=True, hide_index=True)

# ---- Top variances (sign-aware) ----
st.subheader("Largest Line-Item Variances")
top = q("""
SELECT f.month AS Month, d.dept_name AS Department, a.account_name AS Account,
  f.budget AS Budget, f.actual AS Actual, (f.actual-f.budget) AS "Variance ($)",
  CASE
    WHEN a.category='Income' AND f.actual>=f.budget THEN 'Favorable'
    WHEN a.category='Income' AND f.actual< f.budget THEN 'Unfavorable'
    WHEN a.category<>'Income' AND f.actual<=f.budget THEN 'Favorable'
    ELSE 'Unfavorable' END AS Status
FROM fact_financials f
JOIN dim_account a ON f.account_id=a.account_id
JOIN dim_department d ON f.dept_id=d.dept_id
ORDER BY ABS(f.actual-f.budget) DESC LIMIT 10
""")
st.dataframe(top, use_container_width=True, hide_index=True)
