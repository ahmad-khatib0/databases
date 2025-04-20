
### **MySQL Replication: Not Distributed by Default**
MySQL is **not a distributed database system by design**, but it does support **replication** 
(a simpler form of data copying). Here's the proper way to think about it:

---

### **1. Replication ≠ Distributed Database**
| **Replication** | **Distributed Database** |
|-----------------|--------------------------|
| One **primary (master)** node with one or more **replicas (secondaries)**. | True peer-to-peer nodes (e.g., Cassandra, CockroachDB). |
| Replicas are **read-only copies** (with eventual consistency). | All nodes can **read/write** (strong/eventual consistency). |
| **No automatic failover** (without tools like Orchestrator). | Built-in **partition tolerance** and failover. |
| Replica lag is a **side effect**, not a feature. | Lag is **managed explicitly** (e.g., quorum writes). |

---

### **2. Correct Terminology for MySQL**
- **Avoid "slave"**: Modern systems use **replica** (inclusive language).  
- **Nodes**:  
  - **Primary (master)**: Accepts writes.  
  - **Replica (secondary)**: Copies data from the primary (read-only).  

---

### **3. How MySQL Replication Works**
1. **Primary Node**  
   - Writes changes to **binary log (binlog)**.  
2. **Replica Node**  
   - Connects to primary and pulls binlog events.  
   - Applies changes **asynchronously** → causes **replica lag**.  

```sql
-- On replica:
SHOW REPLICA STATUS;  -- Checks sync status (formerly SLAVE STATUS)
```

---

### **4. Why People Confuse It with "Distributed"**
- **Horizontal Scaling**: Replicas can **offload reads**.  
- **High Availability**: Manual failover to a replica is possible.  
But critically:  
- **No automatic sharding** (unlike MongoDB, Cassandra).  
- **No consensus protocol** (e.g., Raft, Paxos).  

---

### **5. True Distributed SQL Databases**
If you need **native distribution**, consider:  
| Database       | Protocol  | Features                          |
|---------------|-----------|-----------------------------------|
| **CockroachDB** | Raft     | Auto-sharding, ACID across nodes. |
| **TiDB**      | Raft      | MySQL-compatible, distributed.    |
| **YugabyteDB** | Raft      | PostgreSQL-compatible.            |

---

### **Key Takeaways**
1. MySQL **replication** ≠ **distribution**.  
2. Use **"primary/replica"** (not master/slave).  
3. For true distribution, explore **CockroachDB/TiDB**.  

