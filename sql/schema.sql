-- ============================================================
--  Online Ticket Booking System - Database Schema
-- ============================================================

CREATE DATABASE IF NOT EXISTS ticket_booking_db;
USE ticket_booking_db;

-- Users table
CREATE TABLE users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name     VARCHAR(100) NOT NULL,
    phone         VARCHAR(15),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Routes / Venues (Bus stops, Train stations, Movie theatres)
CREATE TABLE routes (
    route_id    INT AUTO_INCREMENT PRIMARY KEY,
    route_type  ENUM('BUS','TRAIN','MOVIE') NOT NULL,
    source      VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    operator    VARCHAR(100) NOT NULL   -- Operator / Theatre name
);

-- Schedule / Show times
CREATE TABLE schedules (
    schedule_id    INT AUTO_INCREMENT PRIMARY KEY,
    route_id       INT NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time   DATETIME,
    price          DECIMAL(10,2) NOT NULL,
    total_seats    INT NOT NULL DEFAULT 50,
    available_seats INT NOT NULL DEFAULT 50,
    status         ENUM('ACTIVE','CANCELLED','COMPLETED') DEFAULT 'ACTIVE',
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- Seats
CREATE TABLE seats (
    seat_id     INT AUTO_INCREMENT PRIMARY KEY,
    schedule_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    seat_type   ENUM('WINDOW','AISLE','MIDDLE','VIP') DEFAULT 'AISLE',
    is_booked   BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id)
);

-- Bookings
CREATE TABLE bookings (
    booking_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT NOT NULL,
    schedule_id    INT NOT NULL,
    seat_id        INT NOT NULL,
    booking_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount   DECIMAL(10,2) NOT NULL,
    status         ENUM('CONFIRMED','CANCELLED','PENDING') DEFAULT 'PENDING',
    payment_status ENUM('PAID','REFUNDED','PENDING') DEFAULT 'PENDING',
    booking_ref    VARCHAR(20) NOT NULL UNIQUE,
    FOREIGN KEY (user_id)     REFERENCES users(user_id),
    FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id),
    FOREIGN KEY (seat_id)     REFERENCES seats(seat_id)
);

-- Payments
CREATE TABLE payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    booking_id     INT NOT NULL,
    amount         DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CREDIT_CARD','DEBIT_CARD','UPI','NET_BANKING') NOT NULL,
    transaction_id VARCHAR(50) UNIQUE,
    payment_time   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status         ENUM('SUCCESS','FAILED','REFUNDED') DEFAULT 'SUCCESS',
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- ============================================================
--  Seed Data
-- ============================================================

INSERT INTO routes (route_type, source, destination, operator) VALUES
('BUS',   'Bangalore', 'Mysore',   'KSRTC Airavat'),
('BUS',   'Bangalore', 'Chennai',  'VRL Travels'),
('BUS',   'Bangalore', 'Hyderabad','SRS Travels'),
('TRAIN', 'Bangalore', 'Mumbai',   'Indian Railways'),
('TRAIN', 'Bangalore', 'Delhi',    'Indian Railways'),
('MOVIE', 'N/A',       'N/A',      'PVR Cinemas - Bangalore'),
('MOVIE', 'N/A',       'N/A',      'INOX - Koramangala');

INSERT INTO schedules (route_id, departure_time, arrival_time, price, total_seats, available_seats) VALUES
(1, '2025-07-10 06:00:00', '2025-07-10 09:30:00',  250.00, 40, 40),
(1, '2025-07-10 14:00:00', '2025-07-10 17:30:00',  250.00, 40, 40),
(2, '2025-07-10 20:00:00', '2025-07-11 06:00:00',  650.00, 45, 45),
(3, '2025-07-10 22:00:00', '2025-07-11 10:00:00',  800.00, 45, 45),
(4, '2025-07-10 08:00:00', '2025-07-11 06:00:00', 1200.00, 60, 60),
(5, '2025-07-10 18:00:00', '2025-07-12 10:00:00', 2500.00, 60, 60),
(6, '2025-07-10 10:00:00', '2025-07-10 12:30:00',  350.00, 100,100),
(6, '2025-07-10 14:00:00', '2025-07-10 16:30:00',  350.00, 100,100),
(7, '2025-07-10 11:00:00', '2025-07-10 13:30:00',  300.00, 80, 80);

-- Generate seats for each schedule (stored procedure approach)
DELIMITER $$
CREATE PROCEDURE generate_seats()
BEGIN
    DECLARE sid INT;
    DECLARE snum INT;
    DECLARE seat_types VARCHAR(10);
    DECLARE cur CURSOR FOR SELECT schedule_id FROM schedules;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET sid = NULL;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO sid;
        IF sid IS NULL THEN LEAVE read_loop; END IF;
        SET snum = 1;
        WHILE snum <= 50 DO
            IF snum % 3 = 1 THEN SET seat_types = 'WINDOW';
            ELSEIF snum % 3 = 2 THEN SET seat_types = 'AISLE';
            ELSE SET seat_types = 'MIDDLE';
            END IF;
            INSERT INTO seats (schedule_id, seat_number, seat_type)
            VALUES (sid, CONCAT(CHAR(65 + FLOOR((snum-1)/5)), ((snum-1) % 5)+1), seat_types);
            SET snum = snum + 1;
        END WHILE;
    END LOOP;
    CLOSE cur;
END$$
DELIMITER ;

CALL generate_seats();
DROP PROCEDURE IF EXISTS generate_seats;
