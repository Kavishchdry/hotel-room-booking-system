# Hotel Room Booking System (DBMS Mini Project)

A MySQL-based Database Management System mini project for managing hotel customers, rooms, bookings, and payments.

## Technology

- MySQL
- MySQL Workbench
- SQL (DDL, DML, joins, aggregate functions, subqueries, constraints)

This repository focuses on database design and SQL. It does not require Python.

## Features

- Customer records with unique email addresses
- Room inventory and room types
- Booking records with customer/room foreign keys
- Check-in/check-out date validation
- Payment tracking linked to bookings
- Room availability query for a requested date range
- Booking reports, payment history, revenue totals, and customer booking counts

## Database tables

- `Customers` — customer contact information
- `Rooms` — room number, type, nightly price, and status
- `Bookings` — customer, room, stay dates, booking status, and total amount
- `Payments` — booking payment amount, method, status, and date

## Run the project in MySQL Workbench

1. Open MySQL Workbench and connect to your local MySQL server.
2. Open `01_schema.sql` and execute it.
3. Open `02_sample_data.sql` and execute it to load demonstration data.
4. Open `03_queries.sql` and run the individual queries you want to demonstrate.
5. Check the final count query. The demo dataset should contain 4 customers, 6 rooms, 4 bookings, and 4 payments.

> **Warning:** `02_sample_data.sql` is intended only for a demo database. It deletes existing rows from `Payments` and `Bookings` before loading the sample bookings again. Do not run it against real hotel data.

## ER relationships

- One customer can have many bookings.
- One room can appear in many bookings over time.
- One booking can have one or more payment records.
- `Bookings.customer_id` references `Customers.customer_id`.
- `Bookings.room_id` references `Rooms.room_id`.
- `Payments.booking_id` references `Bookings.booking_id`.

## Important SQL concepts demonstrated

- `CREATE DATABASE`, `CREATE TABLE`
- Primary keys and foreign keys
- `UNIQUE`, `NOT NULL`, `DEFAULT`, and `CHECK` constraints
- `INSERT`, `DELETE`, and `SELECT`
- `INNER JOIN` and `LEFT JOIN`
- `GROUP BY`, `COUNT`, `SUM`, `COALESCE`, and `DATEDIFF`
- `NOT EXISTS` subquery for room availability

## Suggested repository contents

```text
hotel-room-booking-system/
├── 01_schema.sql
├── 02_sample_data.sql
├── 03_queries.sql
├── README.md
├── ER-diagram.png
└── Project-Report.pdf
```

The ER diagram and college report can be added after preparing them for your submission.
