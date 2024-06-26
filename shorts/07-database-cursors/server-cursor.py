import psycopg2
import time as t

con = psycopg2.connect(host="localhost",
                       database="husseindb",
                       user="postgres",
                       password="postgres")
#  con.cursor('a name')  server side cursor
s = t.time()
cur = con.cursor("serverSide")
e = (t.time() - s)*1000
print(f"Cursor established in {e}ms")

s = t.time()
cur.execute("select * from employees")
e = (t.time() - s)*1000
print(f"execute query {e}ms")

s = t.time()
rows = cur.fetchmany(50)
e = (t.time() - s)*1000
print(f"fetching first 50 rows {e}ms")

cur.close()
con.close()
