#!/usr/bin/env python3

""" 
Parameterized queries in python 
"""

import psycopg2
import sys
import time
import csv


def main():

    if ((len(sys.argv)) != 2):
        sys.exit("Error:No URL provided on command line")
    uri = sys.argv[1]

    connection = psycopg2.connect(uri)
    cursor = connection.cursor()
    cursor.execute('USE movr')
    cursor.execute('set tracing=on')
    sql = """SELECT u.name FROM movr.rides r   
             JOIN movr.users u ON (r.rider_id=u.id)   
            WHERE r.id=%s"""
    cursor.execute(sql, ('ffc3c373-63ec-43fe-98ff-311f29424d8b',))
    row = cursor.fetchone()
    print(row[0])


main()
