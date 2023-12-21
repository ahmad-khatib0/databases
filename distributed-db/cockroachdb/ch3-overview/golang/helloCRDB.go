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
		fmt.Fprintf(os.Stderr, "Unable to connect to database: %v\n", err)
		os.Exit(1)
	}
	var text string
	err = conn.QueryRow(
		context.Background(),
		"SELECT CONCAT('Hello from CockroachDB at ',CAST (NOW() as STRING))",
	).Scan(&text)

	if err != nil {
		fmt.Fprintf(os.Stderr, "QueryRow failed: %v\n", err)
		os.Exit(1)
	}

	fmt.Println(text)
}
