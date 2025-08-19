# SQL-Projects
This repository is a collection of my **daily SQL practice and projects**.  
It includes everything from basic queries to advanced automation using functions, procedures, triggers, and events.

---

## 📌 Features
- SQL Queries (Basic → Advanced)
- Database Design Examples
- Stored Functions & Procedures
- Triggers for logging & validation
- Events for scheduling & automation
- Real-world mini projects

---

## 🛠️ Featured Project: Archive Master
**Problem:** Large tables grow quickly (e.g., orders, logs, or sensor data). Old data needs to be archived or deleted to save space.  

**Solution:**  
- Move data older than 30 days from `orders` → `archive` table.  
- Maintain a `delete_log` table with timestamp.  
- Automate the process with **functions, procedures, triggers, and events**.  

**Workflow:**
1. Function calculates date difference.  
2. Procedure archives + deletes old rows.  
3. Trigger logs each delete action.  
4. Event runs procedure every 30 days.  

---
SQL-Projects/
│
├── ArchiveMaster/
│ ├── create_tables.sql
│ ├── functions.sql
│ ├── procedures.sql
│ ├── triggers.sql
│ └── events.sql
│
├── Daily-Practice/
│ ├── joins_practice.sql
│ ├── window_functions.sql
│ ├── indexing_examples.sql
│ └── ...
│
└── README.md

## 📂 Project Structure
