-- ============================================================
-- BrewMetrics FP&A — Analytical Queries (SQLite)
-- Run after building the database:  python build_db.py  (or load fpa.sql)
-- ============================================================

-- 1. Monthly P&L: budget vs. actual (Revenue, COGS, Opex, Operating Income)
SELECT
    f.month,
    SUM(CASE WHEN a.category = 'Income' THEN f.budget END)                       AS revenue_budget,
    SUM(CASE WHEN a.category = 'Income' THEN f.actual END)                       AS revenue_actual,
    SUM(CASE WHEN a.category = 'COGS'   THEN f.actual END)                       AS cogs_actual,
    SUM(CASE WHEN a.category = 'Opex'   THEN f.actual END)                       AS opex_actual,
    SUM(CASE WHEN a.category = 'Income' THEN f.actual ELSE -f.actual END)        AS operating_income
FROM fact_financials f
JOIN dim_account a ON f.account_id = a.account_id
GROUP BY f.month
ORDER BY f.month;

-- 2. Budget vs. actual variance by department (full period)
SELECT
    d.dept_name,
    SUM(f.budget)                         AS budget,
    SUM(f.actual)                         AS actual,
    SUM(f.actual - f.budget)              AS variance_dollars,
    ROUND(100.0 * SUM(f.actual - f.budget) / SUM(f.budget), 1) AS variance_pct
FROM fact_financials f
JOIN dim_department d ON f.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY variance_dollars DESC;

-- 3. Top 10 line-item variances (sign-aware: unfavorable = overspend on costs / shortfall on revenue)
SELECT
    f.month, d.dept_name, a.account_name, a.category,
    f.budget, f.actual,
    (f.actual - f.budget) AS variance_dollars,
    CASE
        WHEN a.category = 'Income' AND f.actual >= f.budget THEN 'Favorable'
        WHEN a.category = 'Income' AND f.actual <  f.budget THEN 'Unfavorable'
        WHEN a.category <> 'Income' AND f.actual <= f.budget THEN 'Favorable'
        ELSE 'Unfavorable'
    END AS status
FROM fact_financials f
JOIN dim_account a    ON f.account_id = a.account_id
JOIN dim_department d ON f.dept_id    = d.dept_id
ORDER BY ABS(f.actual - f.budget) DESC
LIMIT 10;

-- 4. Gross margin % trend (actuals)
SELECT
    f.month,
    ROUND(100.0 *
        (SUM(CASE WHEN a.category='Income' THEN f.actual END)
       - SUM(CASE WHEN a.category='COGS'   THEN f.actual END))
        / SUM(CASE WHEN a.category='Income' THEN f.actual END), 1) AS gross_margin_pct
FROM fact_financials f
JOIN dim_account a ON f.account_id = a.account_id
GROUP BY f.month
ORDER BY f.month;

-- 5. Opex as % of revenue (efficiency monitoring)
SELECT
    f.month,
    ROUND(100.0 * SUM(CASE WHEN a.category='Opex'   THEN f.actual END)
                / SUM(CASE WHEN a.category='Income' THEN f.actual END), 1) AS opex_to_revenue_pct
FROM fact_financials f
JOIN dim_account a ON f.account_id = a.account_id
GROUP BY f.month
ORDER BY f.month;

-- 6. 3-month rolling average revenue (window function)
WITH monthly AS (
    SELECT f.month, SUM(CASE WHEN a.category='Income' THEN f.actual END) AS revenue
    FROM fact_financials f JOIN dim_account a ON f.account_id = a.account_id
    GROUP BY f.month
)
SELECT
    month, revenue,
    ROUND(AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)) AS rolling_3mo_avg
FROM monthly
ORDER BY month;
