#!/usr/bin/env python3

""" 
Connection pools in python 
"""


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
    cursor.execute("SELECT now()")
    for row in cursor:
        print(row[0])
    cursor.close()
    connection.close()


main()
