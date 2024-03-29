import psycopg2
import time as t

con = psycopg2.connect(host="localhost", database="husseindb",
                       user="postgres", password="postgres")

#  con.cursor()  client side cursor
s = t.time()
cur = con.cursor()
e = (t.time() - s)*1000
print(f"Cursor established in {e}ms")

s = t.time()
cur.execute("select * from employees")
e = (t.time() - s)*1000
print(f"execute query {e}ms")

s = t.time()
rows = cur.fetchmany(50)  # fetch 50 rows
e = (t.time() - s)*1000
print(f"fetching first 50 rows {e}ms")

cur.close()
con.close()
