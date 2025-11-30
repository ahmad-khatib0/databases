
---

# Documentation: Understanding `GROUP BY` in SQL

## Why We Need to Group By All Columns When Using an Aggregate Function

When writing SQL queries that use aggregate functions like `SUM()`, `COUNT()`, `AVG()`, etc.,
you must include every non-aggregated column from your `SELECT` list in the `GROUP BY` clause.
This is a fundamental rule of SQL that ensures query results are deterministic and unambiguous.

### 1. The Fundamental Rule: Eliminating Ambiguity

**Rule:** Any column in the `SELECT` list that is *not* part of an aggregate function
  must be included in the `GROUP BY` clause.

**Why?** An aggregate function takes multiple rows and collapses them into a single
  summary value (e.g., `SUM()` adds all values into one). The database needs to know
  *how* to group the rows before it can perform this calculation. The `GROUP BY` clause
  provides these instructions.

Consider our scenario:

- A `products` table with columns `id`, `title`, `media`, `offer`.
- An `inventory_items` table where a single product can have multiple rows (one for each variant).

When we run:

```sql
SELECT
    p.id,
    p.title,          -- Non-aggregated
    p.media,          -- Non-aggregated
    p.offer,          -- Non-aggregated
    SUM(ii.quantity_reserved) -- Aggregated
FROM products AS p
LEFT JOIN inventory_items AS ii ON ii.product_id = p.id
```

The `LEFT JOIN` might produce a temporary result set like this:

| p.id | p.title | p.media | p.offer | ii.quantity_reserved |
|-------|----------|----------|----------|---------------------|
| 'A'   | 'Product A' | {...}   | {...}     | 10                  |
| 'A'   | 'Product A' | {...}   | {...}     | 5                   |
| 'B'   | 'Product B' | {...}   | {...}     | 20                  |

Now, the database must apply `SUM()`. If you only wrote `GROUP BY p.id`, the database
would group the two rows for 'Product A' together. But then it faces a logical problem:

> "I have two rows for product 'A'. The `id` is the same, so I can group them. But which `title`,
`media`, and `offer` should I display for this group? They are identical in this example,
but the database can't assume that."

To resolve this ambiguity, SQL requires you to be explicit. By writing
`GROUP BY p.id, p.title, p.media, p.offer`, you are telling the database:

> "Create a unique group for each specific combination of `id`, `title`, `media`,
  and `offer`. Only then, for each of those unique groups, calculate the `SUM()`."

Since a product should only have one `title`, one `media`, and one `offer`, this
correctly creates one group per product, resolving the ambiguity.

---

### 2. Performance: `GROUP BY` vs. Correlated Subqueries

You could achieve a similar result without `GROUP BY` by using a subquery,
but this is often much less performant.

#### The Slow Way: Correlated Subquery

```sql
SELECT
    p.id,
    p.title,
    p.media,
    p.offer,
    (SELECT COALESCE(SUM(ii.quantity_reserved), 0) 
     FROM inventory_items ii 
     WHERE ii.product_id = p.id) as sold_count -- This subquery runs for EACH product
FROM products AS p
```

**How the Database Processes This:**
This is a "row-by-row" operation. For **every single row** in the outer `products`
table, the database must pause and execute the entire inner `SELECT SUM(...)` query.
If you have 10,000 products, this is conceptually like running 10,001 separate queries.
This breaks the set-based model that relational databases are optimized for and is
extremely inefficient.

#### The Fast Way: `JOIN` with `GROUP BY`

```sql
SELECT
    p.id,
    p.title,
    p.media,
    p.offer,
    COALESCE(SUM(ii.quantity_reserved), 0) as sold_count
FROM products AS p
LEFT JOIN inventory_items AS ii ON ii.product_id = p.id
GROUP BY p.id, p.title, p.media, p.offer
```

**How the Database Processes This:**
This is a "set-based" operation. The query planner can use highly optimized strategies:

1. It can scan both tables once.
2. It might use a **Hash Join**: building an in-memory hash table on the smaller table
   (`inventory_items`) and then probing it for each row in the larger table (`products`).
3. As it builds the final joined result set, it can simultaneously stream the rows into
   an aggregation engine that calculates the `SUM()` for each group.

The database performs a single, continuous operation on the entire dataset, which
is orders of magnitude faster than the nested, row-by-row execution of a correlated subquery.

---

### 3. Practical Examples

#### Example 1: Correct and Efficient (Your Query)

This query is correct, unambiguous, and performant. It correctly aggregates
the inventory for each product.

```sql
SELECT
    p.id,
    p.title,
    p.media,
    p.offer,
    COALESCE(SUM(ii.quantity_reserved), 0) as sold_count
FROM products AS p
LEFT JOIN inventory_items AS ii ON ii.product_id = p.id
GROUP BY
    p.id,       -- Required
    p.title,     -- Required
    p.media,     -- Required
    p.offer       -- Required
ORDER BY p.id DESC;
```

#### Example 2: Incorrect and Ambiguous

This query would fail in PostgreSQL and other strict databases.

```sql
-- THIS QUERY IS INCORRECT
SELECT
    p.id,
    p.title, -- Not in GROUP BY!
    SUM(ii.quantity_reserved) as sold_count
FROM products AS p
LEFT JOIN inventory_items AS ii ON ii.product_id = p.id
GROUP BY p.id; -- Only grouping by id
```

**Error:** `column "p.title" must appear in the GROUP BY clause or be used in an
  aggregate function`. The database refuses to guess which title to show.

#### Example 3: Correct but Slow (The Subquery)

This query works but will perform poorly on any reasonably sized dataset.

```sql
SELECT
    p.id,
    p.title,
    p.media,
    p.offer,
    (SELECT COALESCE(SUM(ii.quantity_reserved), 0) 
     FROM inventory_items ii 
     WHERE ii.product_id = p.id) as sold_count
FROM products AS p
ORDER BY p.id DESC;
```

---

### Conclusion and Best Practices

- **Always include non-aggregated columns:** It's not just a syntax rule; it's a logical
  requirement to write correct and predictable queries.
- **Prefer `JOIN` with `GROUP BY`:** For aggregating data from related tables, this is
  the standard, most efficient pattern. Embrace set-based thinking.
- **Avoid correlated subqueries:** Be very cautious with subqueries that reference the
  outer query. They are a common source of performance bottlenecks.
- **Understand what your database is doing:** Knowing the difference between a
  set-based operation and a row-by-row operation is key to writing high-performance SQL.
