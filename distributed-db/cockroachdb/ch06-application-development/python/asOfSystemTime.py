#!/usr/bin/env python3

import sys
import time
import csv

import psycopg2
from psycopg2 import pool


def main():

    if ((len(sys.argv)) != 2):
        sys.exit("Error:No URL provided on command line")
    uri = sys.argv[1]

    pool = psycopg2.pool.ThreadedConnectionPool(
        10, 40, uri)  # min connection=10, max=40

    connection = pool.getconn()

    cursor = connection.cursor()
    connection.autocommit = False
    cursor.execute('ROLLBACK')

    # You can include the AS OF SYSTEM TIME in a SELECT statement or in a BEGIN statement.
    # If included in the BEGIN statement, then the transaction is a read-only transaction with
    # read consistency as of the timestamp provided. here, we read from rides and user_ride_counts
    # consistently. Without  the AS OF SYSTEM TIME clause, a concurrent write to rides or
    # user_ride_counts  might cause the transaction to fail.
    cursor.execute("BEGIN AS OF SYSTEM TIME '-10s'")
    top10cities = cursor.execute('''SELECT city,count(*) 
                                  FROM movr.rides GROUP BY city 
                                 ORDER BY 2 DESC LIMIT 10''')
    top10users = cursor.execute('''SELECT name, rides   
                                 FROM movr.user_ride_counts 
                                ORDER BY  rides DESC LIMIT 10''')
    cursor.execute('COMMIT')

    print(now)
    cursor.close()
    connection.close()


main()
