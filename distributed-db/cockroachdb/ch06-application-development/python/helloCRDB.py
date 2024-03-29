import psycopg2
import sys
 
def main():

  if ((len(sys.argv)) !=2):
    sys.exit("Error:No URL provided on command line")
  uri=sys.argv[1]

  connection = psycopg2.connect(uri)
  cursor=connection.cursor()
  cursor.execute("DROP TABLE IF EXISTS names")
  cursor.execute("""CREATE TABLE names 
                    (name String PRIMARY KEY NOT NULL)""")
  cursor.execute("""INSERT INTO names (name) 
                    VALUES('Ben'),('Jesse'),('Guy')""")
  cursor.execute("SELECT name FROM names")
  for row in cursor:
    print(row[0])
  cursor.close()
  connection.close()

main()
