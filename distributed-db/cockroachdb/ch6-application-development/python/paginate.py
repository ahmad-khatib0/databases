#!/usr/bin/env python3

""" 
Paginating results
"""

import psycopg2
import sys
import time
import csv
import datetime


def main():

    if ((len(sys.argv)) != 2):
        sys.exit("Error:No URL provided on command line")
    uri = sys.argv[1]
    global connection
    connection = psycopg2.connect(uri)
    connection.autocommit = True

    cursor = connection.cursor()
    cursor.execute("use chapter06")
    for rows in getPage(100, 100):
        print(rows)

    start = 0
    batchSize = 10000
    maxPages = 100
    pageNo = 1
    while True:
        startTime = time.time()
        rows = getPage(start, batchSize)
        print("%s, %s" % (pageNo, (time.time()-startTime)))
        start = start+batchSize
        pageNo = pageNo+1
        if (pageNo > maxPages):
            break

    start = datetime.datetime.now()
    pageNo = 1
    while True:
        startTime = time.time()
        rows = getPageKeySet(start, batchSize)
        print("%s, %s" % (pageNo, (time.time()-startTime)))
        start = (rows[len(rows)-1][0])
        pageNo = pageNo+1
        if (pageNo > maxPages):
            break

    systemTime = datetime.datetime.utcnow()
    start = systemTime
    pageNo = 1
    while True:
        startTime = time.time()
        rows = getPageKeySetST(start, batchSize, systemTime)
        print("%s, %s" % (pageNo, (time.time()-startTime)))
        start = (rows[len(rows)-1][0])
        pageNo = pageNo+1
        if (pageNo > maxPages):
            break


def getPage(startIndex, nEntries):
    cursor = connection.cursor()
    sql = """SELECT post_timestamp, summary 
            FROM blog_posts ORDER BY post_timestamp DESC
          OFFSET %s LIMIT %s"""
    cursor.execute(sql, (startIndex, nEntries))
    return cursor.fetchall()


# The correct method is to move through the result set in key order so that we can
# efficiently retrieve the rows using index ranges. Of course, this approach absolutely
# requires that we have an index on the WHERE clause condition, and ideally, this index
# should be a covering index that includes the SELECT list columns as well:
# CREATE INDEX timeseries_covering ON blog_posts(post_timestamp DESC) STORING (summary);
# So our Python method would look like this:
def getPageKeySet(startTimeStamp, nEntries):
    cursor = connection.cursor()
    sql = """SELECT post_timestamp, summary 
            FROM blog_posts
           WHERE post_timestamp< %s
           ORDER BY post_timestamp DESC
           LIMIT %s"""
    cursor.execute(sql, (startTimeStamp, nEntries))
    return cursor.fetchall()


# In some circumstances, it might be important to ensure that the pages of data are
# consistent. Since each invocation of the method occurs at a different time, each “page”
# of data will reflect the database at a different time. If this is a concern, then AS OF
# SYSTEM TIME can be used to ensure that each page of data reflects the state of the
# database as of a specific time:
def getPageKeySetST(startTimeStamp, nEntries, systemTime):
    cursor = connection.cursor()
    sql = """SELECT post_timestamp, summary FROM blog_posts
           AS OF SYSTEM TIME %s
           WHERE post_timestamp < %s
           ORDER BY post_timestamp DESC
           LIMIT %s
           """
    cursor.execute(sql, (systemTime, startTimeStamp, nEntries))
    return cursor.fetchall()


main()
