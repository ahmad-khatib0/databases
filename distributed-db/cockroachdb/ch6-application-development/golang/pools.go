package main

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/pgxpool"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Missing URL argument")
		os.Exit(1)
	}

	uri := os.Args[1]
	ctx := context.Background()
	config, err := pgxpool.ParseConfig(uri)
	config.MaxConns = 40
	pool, err := pgxpool.ConnectConfig(ctx, config)
	defer pool.Close()

	connection, err := pool.Acquire(ctx)

	result, err := connection.Query(context.Background(), "SELECT NOW()")
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	defer result.Close()

	result.Next()
	values, err := result.Values()
	if err != nil {
		panic(err)
	}

	fmt.Fprintf(os.Stdout, "%v \n", values[0])
}
