-- BrewMetrics Coffee Co. FP&A Reporting Warehouse (SQLite)

DROP TABLE IF EXISTS fact_financials;
DROP TABLE IF EXISTS dim_account;
DROP TABLE IF EXISTS dim_department;

CREATE TABLE dim_department (dept_id INTEGER PRIMARY KEY, dept_name TEXT);
CREATE TABLE dim_account (account_id INTEGER PRIMARY KEY, account_name TEXT, category TEXT);
CREATE TABLE fact_financials (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dept_id INTEGER REFERENCES dim_department(dept_id),
  account_id INTEGER REFERENCES dim_account(account_id),
  month TEXT,           -- YYYY-MM
  budget REAL,
  actual REAL
);

INSERT INTO dim_department VALUES (1,'G&A');
INSERT INTO dim_department VALUES (2,'Marketing');
INSERT INTO dim_department VALUES (3,'Operations');
INSERT INTO dim_department VALUES (4,'Sales');
INSERT INTO dim_account VALUES (1,'Revenue','Income');
INSERT INTO dim_account VALUES (2,'Cost of Goods Sold','COGS');
INSERT INTO dim_account VALUES (3,'Digital Ads','Opex');
INSERT INTO dim_account VALUES (4,'Events','Opex');
INSERT INTO dim_account VALUES (5,'Store Labor','Opex');
INSERT INTO dim_account VALUES (6,'Rent','Opex');
INSERT INTO dim_account VALUES (7,'Software','Opex');
INSERT INTO dim_account VALUES (8,'Salaries','Opex');

INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (4,1,'2026-01',700000,720664);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,2,'2026-01',230000,217005);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,3,'2026-01',80000,78280);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,4,'2026-01',20000,19425);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,5,'2026-01',150000,156466);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,6,'2026-01',40000,41390);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,7,'2026-01',25000,26623);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,8,'2026-01',60000,57130);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (4,1,'2026-02',721000,720329);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,2,'2026-02',236900,223674);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,3,'2026-02',83200,80755);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,4,'2026-02',20000,20215);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,5,'2026-02',151500,142973);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,6,'2026-02',40000,38713);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,7,'2026-02',25000,25775);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,8,'2026-02',60600,61587);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (4,1,'2026-03',742630,720991);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,2,'2026-03',244007,249496);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,3,'2026-03',86528,91142);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,4,'2026-03',20000,18818);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,5,'2026-03',153015,161096);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,6,'2026-03',40000,41510);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,7,'2026-03',25000,24691);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,8,'2026-03',61206,58866);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (4,1,'2026-04',764909,821520);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,2,'2026-04',251327,248091);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,3,'2026-04',89989,85758);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,4,'2026-04',20000,19071);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,5,'2026-04',154545,163609);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,6,'2026-04',40000,40981);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,7,'2026-04',25000,26325);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,8,'2026-04',61818,64424);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (4,1,'2026-05',787856,799731);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,2,'2026-05',258867,278602);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,3,'2026-05',93589,92933);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,4,'2026-05',20000,20346);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,5,'2026-05',156091,164850);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,6,'2026-05',40000,41064);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,7,'2026-05',25000,26516);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,8,'2026-05',62436,63736);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (4,1,'2026-06',811492,842848);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,2,'2026-06',266633,252346);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,3,'2026-06',97332,94598);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (2,4,'2026-06',20000,19610);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,5,'2026-06',157652,149954);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (3,6,'2026-06',40000,38904);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,7,'2026-06',25000,23854);
INSERT INTO fact_financials (dept_id,account_id,month,budget,actual) VALUES (1,8,'2026-06',63061,61731);
