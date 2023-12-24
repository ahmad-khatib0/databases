package main

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Missing URL argument")
		os.Exit(1)
	}

	uri := os.Args[1]
	conn, err := pgx.Connect(context.Background(), uri)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	execSQL(*conn, "DROP TABLE IF EXISTS names")
	execSQL(*conn, "CREATE TABLE names (name String PRIMARY KEY NOT NULL)")
	execSQL(*conn, "INSERT INTO names (name) VALUES('Ben'),('Jesse'),('Guy')")

	rows, err := conn.Query(context.Background(), "SELECT name FROM names")
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	defer rows.Close()
	for rows.Next() {
		var name string
		err = rows.Scan(&name)
		fmt.Println(name)
	}
}

func execSQL(conn pgx.Conn, sql string) {
	result, err := conn.Exec(context.Background(), sql)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
		os.Exit(1)
	}
	fmt.Fprintf(os.Stdout, "%v rows affected\n", result.RowsAffected())
}
