## ✅ Why PL/pgSQL Is Specific to PostgreSQL

**PL/pgSQL** is a **proprietary procedural language** built **specifically for PostgreSQL**
to extend SQL with logic like loops, conditionals, and variables.

Just like SQL lets you ask **"what"** data you want, PL/pgSQL lets you describe **"how"**
to get or manipulate that data with **procedural steps**.

> 🔑 Think of it as:
> **SQL** = Declarative
> **PL/pgSQL** = Imperative logic (control flow, variables, etc.)

---

## 🔁 But Isn’t SQL a Standard?

Yes, **SQL (Structured Query Language)** _is_ standardized — mainly by **ISO/IEC** — but
only the **core syntax** is standardized:

| Standard SQL                           | Examples                   |
| -------------------------------------- | -------------------------- |
| `SELECT`, `INSERT`, `UPDATE`, `DELETE` | Supported across all RDBMS |
| `JOIN`, `GROUP BY`, `ORDER BY`         | Standard                   |
| Basic transactions (`BEGIN`, `COMMIT`) | Mostly standard            |

---

## 🛠 Procedural SQL: Not Standardized

The **procedural extensions** — like what you see in PL/pgSQL — are **not part of standard SQL**,
and each database implements its **own version**.

---

## ⚙️ Procedural SQL Languages by RDBMS

| Database            | Procedural Language                                           | Notes                                            |
| ------------------- | ------------------------------------------------------------- | ------------------------------------------------ |
| **PostgreSQL**      | `PL/pgSQL`                                                    | Native procedural language                       |
| **Oracle**          | `PL/SQL`                                                      | Very powerful, slightly older                    |
| **SQL Server**      | `T-SQL` (Transact-SQL)                                        | Microsoft-specific                               |
| **MySQL / MariaDB** | Basic procedural SQL in stored procedures (not full-featured) | Has `BEGIN ... END`, loops, etc.                 |
| **SQLite**          | No procedural language                                        | Logic must be in host language (Python, C, etc.) |

---

## 🧠 Key Differences

| Feature                       | PL/pgSQL      | PL/SQL (Oracle) | T-SQL (SQL Server) |
| ----------------------------- | ------------- | --------------- | ------------------ |
| Full procedural logic         | ✅            | ✅              | ✅                 |
| `RAISE NOTICE`                | ✅ (Postgres) | ❌              | ❌                 |
| Custom exceptions             | ✅            | ✅              | ✅                 |
| `RETURN NEXT`, `RETURN QUERY` | ✅            | ❌              | ❌                 |
| JSON/Array manipulation       | Strong        | Weaker          | Weaker             |

---

## 📌 TL;DR Summary

- **PL/pgSQL is specific to PostgreSQL**.
- There’s **no universal procedural SQL standard** — just **standard declarative SQL**.
- Each database has its **own procedural dialect** (like programming languages having their own syntax).

---

If you're building cross-platform apps, you'd generally:

- Use **standard SQL** for portability.
- Use procedural SQL **only when you're tied to a specific database** and want logic
  _inside_ the database (triggers, stored procedures, etc.).

---
