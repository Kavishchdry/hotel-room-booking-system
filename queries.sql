-- Hotel Room Booking System
-- File: 03_queries.sql
-- Run after 01_schema.sql and 02_sample_data.sql.

USE hotel_booking_db;

-- 1. View all customers.
SELECT * FROM Customers ORDER BY customer_id;

-- 2. View all rooms.
SELECT * FROM Rooms ORDER BY room_number;

-- 3. Booking details with customer and room information.
SELECT
    b.booking_id,
    c.full_name,
    c.phone,
    r.room_number,
    r.room_type,
    r.price_per_night,
    b.check_in,
    b.check_out,
    DATEDIFF(b.check_out, b.check_in) AS nights,
    b.booking_status,
    b.total_amount
FROM Bookings b
JOIN Customers c ON c.customer_id = b.customer_id
JOIN Rooms r ON r.room_id = b.room_id
ORDER BY b.check_in;

-- 4. Find rooms available for a requested date range.
-- Example dates: 2026-11-05 through 2026-11-08.
-- A booking overlaps when existing check_in < requested check_out
-- and existing check_out > requested check_in.
SELECT
    r.room_number,
    r.room_type,
    r.price_per_night
FROM Rooms r
WHERE r.room_status = 'Available'
  AND NOT EXISTS (
      SELECT 1
      FROM Bookings b
      WHERE b.room_id = r.room_id
        AND b.booking_status = 'Confirmed'
        AND b.check_in < '2026-11-08'
        AND b.check_out > '2026-11-05'
  )
ORDER BY r.price_per_night;

-- 5. Payment history with customer and booking details.
SELECT
    p.payment_id,
    b.booking_id,
    c.full_name,
    r.room_number,
    p.amount,
    p.payment_method,
    p.payment_status,
    p.payment_date
FROM Payments p
JOIN Bookings b ON b.booking_id = p.booking_id
JOIN Customers c ON c.customer_id = b.customer_id
JOIN Rooms r ON r.room_id = b.room_id
ORDER BY p.payment_date;

-- 6. Total revenue from payments marked Paid.
SELECT COALESCE(SUM(amount), 0.00) AS total_revenue
FROM Payments
WHERE payment_status = 'Paid';

-- 7. Booking count per customer, including customers with zero bookings.
SELECT
    c.customer_id,
    c.full_name,
    COUNT(b.booking_id) AS total_bookings
FROM Customers c
LEFT JOIN Bookings b ON b.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_bookings DESC, c.full_name;

-- 8. Total amount and paid amount by booking.
SELECT
    b.booking_id,
    c.full_name,
    b.total_amount AS booking_total,
    COALESCE(SUM(CASE WHEN p.payment_status = 'Paid' THEN p.amount ELSE 0 END), 0.00)
        AS amount_paid,
    b.total_amount -
    COALESCE(SUM(CASE WHEN p.payment_status = 'Paid' THEN p.amount ELSE 0 END), 0.00)
        AS balance_due
FROM Bookings b
JOIN Customers c ON c.customer_id = b.customer_id
LEFT JOIN Payments p ON p.booking_id = b.booking_id
GROUP BY b.booking_id, c.full_name, b.total_amount
ORDER BY b.booking_id;

-- 9. Count records in each table.
SELECT 'Customers' AS table_name, COUNT(*) AS total FROM Customers
UNION ALL
SELECT 'Rooms', COUNT(*) FROM Rooms
UNION ALL
SELECT 'Bookings', COUNT(*) FROM Bookings
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payments;
