**PL/pgSQL**, which stands for **Procedural Language/PostgreSQL Structured Query Language**.

It’s a **procedural extension** for SQL used by **PostgreSQL**, allowing you to write
**complex functions, loops, conditionals, and blocks** inside SQL.

---

## 🧠 PL/pgSQL Cheat Sheet (for PostgreSQL)

---

### 📌 **Basic Syntax**

```sql
DO $$
DECLARE
    -- variable declarations
BEGIN
    -- procedural logic
END;
$$ LANGUAGE plpgsql;
```

---

### 🔤 **Variable Declarations**

```sql
DECLARE
    my_var INTEGER;
    name TEXT := 'default';
    count INT DEFAULT 0;
```

---

### 🔁 **Control Structures**

#### IF/THEN/ELSE

```sql
IF some_condition THEN
    -- do something
ELSIF other_condition THEN
    -- something else
ELSE
    -- fallback
END IF;
```

#### CASE

```sql
CASE my_var
    WHEN 1 THEN 'One'
    WHEN 2 THEN 'Two'
    ELSE 'Other'
END;
```

#### LOOP / WHILE / FOR

```sql
-- Simple loop
LOOP
    EXIT WHEN done;
END LOOP;

-- WHILE loop
WHILE count < 10 LOOP
    count := count + 1;
END LOOP;

-- FOR loop (numeric)
FOR i IN 1..10 LOOP
    RAISE NOTICE 'i = %', i;
END LOOP;

-- FOR over query
FOR row IN SELECT * FROM users LOOP
    RAISE NOTICE '%', row.name;
END LOOP;
```

---

### 📋 **Function Definition**

```sql
CREATE OR REPLACE FUNCTION update_user()
RETURNS void AS $$
BEGIN
    UPDATE users SET active = true;
END;
$$ LANGUAGE plpgsql;
```

---

### 🔄 **Trigger Function Example**

```sql
CREATE OR REPLACE FUNCTION log_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_table(user_id, change_time)
    VALUES (NEW.id, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

### 🧪 **Exception Handling**

```sql
BEGIN
    -- some logic
EXCEPTION
    WHEN division_by_zero THEN
        RAISE NOTICE 'Division by zero!';
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error!';
END;
```

---

### 🔀 **Labels & Nested Blocks**

```sql
<<my_block>>
BEGIN
    -- labeled block
    EXIT my_block WHEN something;
END my_block;
```

---

### 📦 **DO Block vs Function**

| `DO` Block              | Function            |
| ----------------------- | ------------------- |
| Anonymous               | Named & reusable    |
| Cannot return values    | Can return values   |
| Good for one-time logic | Good for procedures |

---

### 🧠 **Built-in Functions**

| Function             | Description                              |
| -------------------- | ---------------------------------------- |
| `RAISE NOTICE 'msg'` | Debug output                             |
| `PERFORM`            | Execute a query without returning result |
| `FOUND`              | True if last query returned rows         |
| `EXECUTE`            | Run dynamic SQL                          |

---

### 🧱 **Data Types**

| Type                | Description       |
| ------------------- | ----------------- |
| `INTEGER`, `BIGINT` | Numbers           |
| `TEXT`, `VARCHAR`   | Strings           |
| `BOOLEAN`           | True/false        |
| `RECORD`, `ROWTYPE` | Generic row types |

---

### 🔐 **Security & Permissions**

```sql
CREATE FUNCTION my_func() RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER;  -- run as function creator, not caller
```

---

### 📌 Example: Version Check Logic

```sql
DO $$
DECLARE
    current_version TEXT;
BEGIN
    SELECT value INTO current_version
    FROM systems
    WHERE name = 'Version';

    IF (string_to_array(current_version, '.') < string_to_array('4.10.0', '.')) THEN
        UPDATE users SET authdata = LOWER(authdata) WHERE authservice = 'saml';
    END IF;
END;
$$ LANGUAGE plpgsql;
```

---

### 🛠️ When to Use PL/pgSQL?

- Complex business logic inside the DB
- Data validation
- Automation (e.g. daily updates, maintenance)
- Triggers and event logging

---
