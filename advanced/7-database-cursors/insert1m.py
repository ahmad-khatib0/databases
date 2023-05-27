import psycopg2

con = psycopg2.connect(host="localhost",
                       database="husseindb",
                       user="postgres",
                       password="postgres")

cur = con.cursor()

for i in range(1000000):
    cur.execute("insert into employees (id, name) values(%s,%s) ",
                (i, f"test{i}"))

con.commit()
con.close()
