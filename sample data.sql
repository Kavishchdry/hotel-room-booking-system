-- Hotel Room Booking System
-- File: 02_sample_data.sql
-- Run after 01_schema.sql.
--
-- DEMO DATA WARNING:
-- This script resets existing Bookings and Payments rows before adding
-- the four demonstration bookings. Use only for a project/demo database.
-- It preserves the Customers and Rooms tables.

USE hotel_booking_db;

-- Keep these sample customer records consistent if this file is rerun.
INSERT INTO Customers (full_name, phone, email)
VALUES
    ('Aarav Sharma', '9876543210', 'aarav@example.com'),
    ('Priya Verma',  '9876543211', 'priya@example.com'),
    ('Rahul Singh',  '9876543212', 'rahul@example.com'),
    ('Neha Gupta',   '9876543213', 'neha@example.com')
ON DUPLICATE KEY UPDATE
    full_name = VALUES(full_name),
    phone = VALUES(phone);

-- Keep these sample room records consistent if this file is rerun.
INSERT INTO Rooms (room_number, room_type, price_per_night, room_status)
VALUES
    ('101', 'Single', 1200.00, 'Available'),
    ('102', 'Single', 1200.00, 'Available'),
    ('201', 'Double', 2000.00, 'Available'),
    ('202', 'Double', 2000.00, 'Available'),
    ('301', 'Deluxe', 3500.00, 'Available'),
    ('401', 'Suite',  5500.00, 'Available')
ON DUPLICATE KEY UPDATE
    room_type = VALUES(room_type),
    price_per_night = VALUES(price_per_night),
    room_status = VALUES(room_status);

-- Clear only demo transaction rows, in child-to-parent order.
-- WHERE clauses use primary keys to work with Workbench safe-update mode.
DELETE FROM Payments WHERE payment_id > 0;
DELETE FROM Bookings WHERE booking_id > 0;

-- Create four demo bookings using lookups, not hard-coded auto-increment IDs.
INSERT INTO Bookings
    (customer_id, room_id, check_in, check_out, booking_status, total_amount)
SELECT c.customer_id, r.room_id, '2026-11-05', '2026-11-08', 'Confirmed', 3600.00
FROM Customers c JOIN Rooms r
WHERE c.email = 'aarav@example.com' AND r.room_number = '101';

INSERT INTO Bookings
    (customer_id, room_id, check_in, check_out, booking_status, total_amount)
SELECT c.customer_id, r.room_id, '2026-11-10', '2026-11-12', 'Confirmed', 4000.00
FROM Customers c JOIN Rooms r
WHERE c.email = 'priya@example.com' AND r.room_number = '201';

INSERT INTO Bookings
    (customer_id, room_id, check_in, check_out, booking_status, total_amount)
SELECT c.customer_id, r.room_id, '2026-11-15', '2026-11-18', 'Confirmed', 10500.00
FROM Customers c JOIN Rooms r
WHERE c.email = 'rahul@example.com' AND r.room_number = '301';

INSERT INTO Bookings
    (customer_id, room_id, check_in, check_out, booking_status, total_amount)
SELECT c.customer_id, r.room_id, '2026-11-20', '2026-11-22', 'Confirmed', 2400.00
FROM Customers c JOIN Rooms r
WHERE c.email = 'neha@example.com' AND r.room_number = '102';

-- Insert payments by finding each booking from its customer, room and dates.
-- Priya has a partial payment to demonstrate payment tracking.
INSERT INTO Payments
    (booking_id, amount, payment_method, payment_status, payment_date)
SELECT b.booking_id, 3600.00, 'UPI', 'Paid', '2026-11-01'
FROM Bookings b
JOIN Customers c ON c.customer_id = b.customer_id
JOIN Rooms r ON r.room_id = b.room_id
WHERE c.email = 'aarav@example.com'
  AND r.room_number = '101'
  AND b.check_in = '2026-11-05'
  AND b.check_out = '2026-11-08';

INSERT INTO Payments
    (booking_id, amount, payment_method, payment_status, payment_date)
SELECT b.booking_id, 2000.00, 'Card', 'Paid', '2026-11-02'
FROM Bookings b
JOIN Customers c ON c.customer_id = b.customer_id
JOIN Rooms r ON r.room_id = b.room_id
WHERE c.email = 'priya@example.com'
  AND r.room_number = '201'
  AND b.check_in = '2026-11-10'
  AND b.check_out = '2026-11-12';

INSERT INTO Payments
    (booking_id, amount, payment_method, payment_status, payment_date)
SELECT b.booking_id, 10500.00, 'Cash', 'Paid', '2026-11-03'
FROM Bookings b
JOIN Customers c ON c.customer_id = b.customer_id
JOIN Rooms r ON r.room_id = b.room_id
WHERE c.email = 'rahul@example.com'
  AND r.room_number = '301'
  AND b.check_in = '2026-11-15'
  AND b.check_out = '2026-11-18';

INSERT INTO Payments
    (booking_id, amount, payment_method, payment_status, payment_date)
SELECT b.booking_id, 2400.00, 'UPI', 'Paid', '2026-11-04'
FROM Bookings b
JOIN Customers c ON c.customer_id = b.customer_id
JOIN Rooms r ON r.room_id = b.room_id
WHERE c.email = 'neha@example.com'
  AND r.room_number = '102'
  AND b.check_in = '2026-11-20'
  AND b.check_out = '2026-11-22';

-- Verify row counts. Expected: Customers 4, Rooms 6, Bookings 4, Payments 4.
SELECT 'Customers' AS table_name, COUNT(*) AS total FROM Customers
UNION ALL
SELECT 'Rooms', COUNT(*) FROM Rooms
UNION ALL
SELECT 'Bookings', COUNT(*) FROM Bookings
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payments;
