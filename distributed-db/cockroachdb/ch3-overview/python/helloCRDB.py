#!/usr/bin/env python3

import psycopg2
import sys
 
def main():

  if ((len(sys.argv)) !=2):
    sys.exit("Error:No URL provided on command line")
  uri=sys.argv[1]

  conn = psycopg2.connect(uri)
  with conn.cursor() as cur:
    cur.execute("""SELECT CONCAT('Hello from CockroachDB at ', CAST (NOW() as STRING))""")
    data=cur.fetchone()
    print("%s" % data[0])

main()
