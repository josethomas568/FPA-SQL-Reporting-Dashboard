"""Build the SQLite FP&A warehouse from fpa.sql.  Usage: python build_db.py"""
import sqlite3, pathlib

DB = "fpa.db"
SQL = pathlib.Path("fpa.sql").read_text()

con = sqlite3.connect(DB)
con.executescript(SQL)
con.commit()
n = con.execute("SELECT COUNT(*) FROM fact_financials").fetchone()[0]
print(f"Built {DB} with {n} fact rows across "
      f"{con.execute('SELECT COUNT(*) FROM dim_department').fetchone()[0]} departments and "
      f"{con.execute('SELECT COUNT(*) FROM dim_account').fetchone()[0]} accounts.")
con.close()
