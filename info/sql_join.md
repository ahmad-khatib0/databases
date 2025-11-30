# SQL Joins Comprehensive Cheat Sheet with Real Examples

## 📚 Join Types Overview

### 1. INNER JOIN
**Returns only matching rows from both tables**

```sql
SELECT columns
FROM table1
INNER JOIN table2 ON table1.column = table2.column;
```

**Example with Products & Inventory:**
```sql
SELECT p.id, p.name, i.quantity_available
FROM products p
INNER JOIN inventory_items i ON p.id = i.product_id;
```

**What this returns:**
- ✅ Products that HAVE inventory items
- ❌ Products with NO inventory items
- ❌ Inventory items with NO product (shouldn't happen with FK)

**Sample Data:**
```
products table:           inventory_items table:
id | name                id | product_id | quantity_available
1  | Laptop              1  | 1          | 50
2  | Mouse               2  | 2          | 100
3  | Keyboard            3  | 4          | 25  (orphaned - no product)
4  | Monitor

RESULT:
id | name     | quantity_available
1  | Laptop   | 50
2  | Mouse    | 100
```

### 2. LEFT JOIN (LEFT OUTER JOIN)
**Returns ALL rows from left table + matching rows from right table**

```sql
SELECT columns
FROM table1
LEFT JOIN table2 ON table1.column = table2.column;
```

**Example:**
```sql
SELECT p.id, p.name, i.quantity_available
FROM products p
LEFT JOIN inventory_items i ON p.id = i.product_id;
```

**What this returns:**
- ✅ ALL Products (even with no inventory)
- ✅ Inventory data for products that have it
- ❌ Orphaned inventory items (no product)

**Sample Result:**
```
id | name     | quantity_available
1  | Laptop   | 50
2  | Mouse    | 100
3  | Keyboard | NULL
4  | Monitor  | NULL
```

### 3. RIGHT JOIN (RIGHT OUTER JOIN)
**Returns ALL rows from right table + matching rows from left table**

```sql
SELECT columns
FROM table1
RIGHT JOIN table2 ON table1.column = table2.column;
```

**Example:**
```sql
SELECT p.id, p.name, i.quantity_available
FROM products p
RIGHT JOIN inventory_items i ON p.id = i.product_id;
```

**What this returns:**
- ✅ ALL Inventory items (even orphaned ones)
- ✅ Product data for inventory that has it
- ❌ Products with no inventory

**Sample Result:**
```
id | name   | quantity_available
1  | Laptop | 50
2  | Mouse  | 100
NULL| NULL  | 25  (orphaned inventory item)
```

### 4. FULL OUTER JOIN
**Returns ALL rows when there's a match in either table**

```sql
SELECT columns
FROM table1
FULL OUTER JOIN table2 ON table1.column = table2.column;
```

**Example:**
```sql
SELECT p.id, p.name, i.quantity_available
FROM products p
FULL OUTER JOIN inventory_items i ON p.id = i.product_id;
```

**What this returns:**
- ✅ ALL Products
- ✅ ALL Inventory items
- ✅ Everything from both tables

**Sample Result:**
```
id | name     | quantity_available
1  | Laptop   | 50
2  | Mouse    | 100
3  | Keyboard | NULL
4  | Monitor  | NULL
NULL| NULL    | 25  (orphaned inventory)
```

### 5. CROSS JOIN
**Returns Cartesian product (all possible combinations)**

```sql
SELECT columns
FROM table1
CROSS JOIN table2;
```

**Example:**
```sql
SELECT p.name, w.warehouse_name
FROM products p
CROSS JOIN warehouses w;
```

**What this returns:**
- ✅ Every product combined with every warehouse
- Useful for generating all possible combinations

**Sample Result:**
```
name     | warehouse_name
Laptop   | NY Warehouse
Laptop   | CA Warehouse
Mouse    | NY Warehouse
Mouse    | CA Warehouse
Keyboard | NY Warehouse
Keyboard | CA Warehouse
```

### 6. SELF JOIN
**Join a table with itself**

```sql
SELECT a.column, b.column
FROM table a
JOIN table b ON a.column = b.column;
```

**Example: Employee Hierarchy**
```sql
SELECT 
    emp.name AS employee_name,
    mgr.name AS manager_name
FROM employees emp
LEFT JOIN employees mgr ON emp.manager_id = mgr.id;
```

## 🔧 Advanced Join Examples

### Multiple Table Joins (E-commerce Scenario)
```sql
-- Get complete order details
SELECT 
    c.name AS customer_name,
    o.id AS order_id,
    p.name AS product_name,
    oli.quantity,
    oli.unit_price_cents
FROM customers c
INNER JOIN orders o ON c.id = o.user_id
INNER JOIN order_line_items oli ON o.id = oli.order_id
INNER JOIN products p ON oli.product_id = p.id
WHERE o.created_at > '2024-01-01';
```

**What this returns:**
- Only customers who have orders
- Only orders that have line items
- Only line items for existing products
- Only data from 2024 onwards

### LEFT JOIN to Find Missing Data
```sql
-- Find products with no inventory
SELECT p.id, p.name
FROM products p
LEFT JOIN inventory_items i ON p.id = i.product_id
WHERE i.product_id IS NULL;
```

**What this returns:**
- Products that exist but have NO inventory records
- Useful for data validation

### JOIN with Aggregate Functions
```sql
-- Customer order summary
SELECT 
    c.name,
    COUNT(o.id) AS order_count,
    SUM(oli.total_cents) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.user_id
LEFT JOIN order_line_items oli ON o.id = oli.order_id
GROUP BY c.id, c.name;
```

**What this returns:**
- ALL customers (even those with no orders)
- Order count and total spent per customer
- Customers with no orders show as 0/NULL

## 🎯 Real-World Scenarios

### Scenario 1: Inventory Management Report
```sql
-- Products with their inventory levels and locations
SELECT 
    p.name AS product_name,
    p.sku,
    i.quantity_available,
    i.quantity_reserved,
    w.name AS warehouse_name,
    (i.quantity_available - i.quantity_reserved) AS net_available
FROM products p
INNER JOIN inventory_items i ON p.id = i.product_id
LEFT JOIN warehouses w ON i.warehouse_id = w.id
WHERE i.quantity_available > 0;
```

### Scenario 2: Sales Analysis with Missing Products
```sql
-- All products with their sales data (including unsold products)
SELECT 
    p.name,
    p.category,
    COUNT(oli.id) AS times_ordered,
    COALESCE(SUM(oli.quantity), 0) AS total_units_sold
FROM products p
LEFT JOIN order_line_items oli ON p.id = oli.product_id
LEFT JOIN orders o ON oli.order_id = o.id AND o.status = 'CONFIRMED'
GROUP BY p.id, p.name, p.category
ORDER BY total_units_sold DESC;
```

### Scenario 3: Customer Order History (Including New Customers)
```sql
-- All customers with their order history
SELECT 
    c.name AS customer_name,
    c.email,
    o.id AS order_id,
    o.total_cents,
    o.created_at AS order_date,
    CASE 
        WHEN o.id IS NULL THEN 'No orders'
        ELSE 'Has orders'
    END AS order_status
FROM customers c
LEFT JOIN orders o ON c.id = o.user_id
ORDER BY c.name, o.created_at DESC;
```

## ⚡ Performance Tips with Examples

### 1. Filter Before Joining
```sql
-- Good: Filter orders first, then join
SELECT c.name, filtered_orders.total_cents
FROM customers c
INNER JOIN (
    SELECT user_id, total_cents 
    FROM orders 
    WHERE created_at > '2024-01-01'
) filtered_orders ON c.id = filtered_orders.user_id;

-- Bad: Join all orders then filter
SELECT c.name, o.total_cents
FROM customers c
INNER JOIN orders o ON c.id = o.user_id
WHERE o.created_at > '2024-01-01';
```

### 2. Be Specific with SELECT
```sql
-- Good: Only needed columns
SELECT p.id, p.name, i.quantity_available
FROM products p
JOIN inventory_items i ON p.id = i.product_id;

-- Bad: SELECT * (returns unnecessary data)
SELECT *
FROM products p
JOIN inventory_items i ON p.id = i.product_id;
```

## 📊 Quick Decision Guide

| Use Case | Recommended Join | Example |
|----------|------------------|---------|
| **Find related data** | INNER JOIN | Products with inventory |
| **Include all primary records** | LEFT JOIN | All customers + their orders |
| **Find missing relationships** | LEFT JOIN + WHERE NULL | Products with no inventory |
| **Complete data merge** | FULL OUTER JOIN | All products + all inventory |
| **Generate combinations** | CROSS JOIN | All product-warehouse pairs |
| **Compare within table** | SELF JOIN | Employee-manager relationships |

## 🚨 Common Mistakes with Examples

### 1. Accidental Cross Join
```sql
-- WRONG: Creates millions of rows!
SELECT p.name, i.quantity_available
FROM products p, inventory_items i;

-- CORRECT: Explicit join condition
SELECT p.name, i.quantity_available
FROM products p
INNER JOIN inventory_items i ON p.id = i.product_id;
```

### 2. Column Ambiguity
```sql
-- WRONG: Which id??
SELECT id, name, quantity_available
FROM products p
JOIN inventory_items i ON p.id = i.product_id;

-- CORRECT: Specify table
SELECT p.id AS product_id, p.name, i.quantity_available
FROM products p
JOIN inventory_items i ON p.id = i.product_id;
```

### 3. Wrong Join Type for Business Logic
```sql
-- WRONG: Using INNER JOIN when you want all products
SELECT p.name, COUNT(oli.id) as order_count
FROM products p
INNER JOIN order_line_items oli ON p.id = oli.product_id
GROUP BY p.name;  -- Missing products with no orders!

-- CORRECT: Use LEFT JOIN
SELECT p.name, COUNT(oli.id) as order_count
FROM products p
LEFT JOIN order_line_items oli ON p.id = oli.product_id
GROUP BY p.name;  -- Includes all products
```

This cheat sheet now includes practical examples showing exactly what data each join returns and when to use them!
