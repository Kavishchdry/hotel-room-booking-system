-- Hotel Room Booking System
-- File: 01_schema.sql
-- Run this file first in MySQL Workbench.

CREATE DATABASE IF NOT EXISTS hotel_booking_db;
USE hotel_booking_db;

CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type VARCHAR(30) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    room_status VARCHAR(20) NOT NULL DEFAULT 'Available',
    CONSTRAINT chk_room_price CHECK (price_per_night >= 0),
    CONSTRAINT chk_room_status CHECK (room_status IN ('Available', 'Maintenance', 'Inactive'))
);

CREATE TABLE IF NOT EXISTS Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    booking_status VARCHAR(20) NOT NULL DEFAULT 'Confirmed',
    total_amount DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_bookings_customer
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_bookings_room
        FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    CONSTRAINT chk_booking_dates CHECK (check_out > check_in),
    CONSTRAINT chk_booking_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_booking_status CHECK (booking_status IN ('Confirmed', 'Cancelled', 'Completed'))
);

CREATE TABLE IF NOT EXISTS Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    payment_date DATE,
    CONSTRAINT fk_payments_booking
        FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id),
    CONSTRAINT chk_payment_amount CHECK (amount >= 0),
    CONSTRAINT chk_payment_status CHECK (payment_status IN ('Pending', 'Paid', 'Failed', 'Refunded'))
);

SHOW TABLES;
