package main

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/pgxpool"
)

var pool *pgxpool.Pool
var userCache map[string]string
var err string

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Missing URL argument")
		os.Exit(1)
	}
	uri := os.Args[1]

	ctx := context.Background()
	config, err := pgxpool.ParseConfig(uri)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	config.MaxConns = 40

	pool, err = pgxpool.ConnectConfig(ctx, config)
	userCache = make(map[string]string)

	// connection, err := pool.Acquire(ctx)
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	defer pool.Close()

}

func transferFunds(fromAcc int, toAcc int, amount float32) {
	conn, err := pool.Acquire(context.Background())
	defer conn.Release()
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}

	sql := `SELECT name FROM movr.users WHERE id=$1`
	rows, err := conn.Query(context.Background(), sql, userId)
	defer rows.Close()

	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	if !rows.Next() {
		return "Invalid userId"
	} else {
		var name string
		rows.Scan(&name)
		return (name)
	}
}

func getUserName(userId string) string {
	conn, err := pool.Acquire(context.Background())
	defer conn.Release()
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	sql := `SELECT name FROM movr.users WHERE id=$1`
	rows, err := conn.Query(context.Background(), sql, userId)
	defer rows.Close()
	if err != nil {
		fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
	}
	if !rows.Next() {
		return "Invalid userId"
	} else {
		var name string
		rows.Scan(&name)
		return (name)
	}
}

func getCachedUserName(userId string) string {

	name, nameFound := userCache[userId]
	if !nameFound {
		conn, err := pool.Acquire(context.Background())
		defer conn.Release()
		if err != nil {
			fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
		}
		fmt.Println("cache miss")
		sql := `SELECT name FROM movr.users WHERE id=$1`
		rows, err := conn.Query(context.Background(), sql, userId)
		defer rows.Close()
		if err != nil {
			fmt.Fprintf(os.Stderr, "CockroachDB error: %v\n", err)
		}
		if !rows.Next() {
			return "Invalid userId"
		} else {
			rows.Scan(&name)
			userCache[userId] = name
		}
	}
	return (name)
}
