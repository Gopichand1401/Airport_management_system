-- -- CREATE TABLE Passenger (
-- --     Passenger_ID SERIAL PRIMARY KEY,
-- --     Name VARCHAR(100) NOT NULL,
-- --     Email VARCHAR(100) UNIQUE,
-- --     Phone VARCHAR(20),
-- --     Passport_Number VARCHAR(50) UNIQUE
-- -- );

-- -- CREATE TABLE Staff (
-- --     Staff_ID SERIAL PRIMARY KEY,
-- --     Name VARCHAR(100) NOT NULL,
-- --     Username VARCHAR(50) UNIQUE,
-- --     Password_Hash TEXT,
-- --     Role VARCHAR(50),
-- --     Street VARCHAR(100),
-- --     City VARCHAR(50),
-- --     State VARCHAR(50)
-- -- );


-- -- CREATE TABLE Airport (
-- --     Airport_ID SERIAL PRIMARY KEY,
-- --     Airport_Name VARCHAR(100),
-- --     City VARCHAR(50),
-- --     State VARCHAR(50),
-- --     Country VARCHAR(50)
-- -- );


-- -- CREATE TABLE Airroutes (
-- --     Route_ID SERIAL PRIMARY KEY,
-- --     Origin_Airport INT,
-- --     Destination_Airport INT,
-- --     Distance_KM INT,
    
-- --     FOREIGN KEY (Origin_Airport) REFERENCES Airport(Airport_ID),
-- --     FOREIGN KEY (Destination_Airport) REFERENCES Airport(Airport_ID)
-- -- );

-- -- CREATE TABLE Gates (
-- --     Gate_ID SERIAL PRIMARY KEY,
-- --     Gate_Number VARCHAR(10),
-- --     Airport_ID INT,
-- --     Status VARCHAR(20),
    
-- --     FOREIGN KEY (Airport_ID) REFERENCES Airport(Airport_ID)
-- -- );

-- -- CREATE TABLE Flights (
-- --     Flight_ID SERIAL PRIMARY KEY,
-- --     Flight_No VARCHAR(20) UNIQUE,
-- --     Aircraft_Type VARCHAR(50),
-- --     Capacity INT
-- -- );


-- -- CREATE TABLE Scheduled_Flight (
-- --     Route_ID INT,
-- --     Flight_ID INT,
-- --     Flight_Date DATE,
-- --     Departure_Time TIME,
-- --     Arrival_Time TIME,
-- --     Gate_ID INT,
-- --     Status VARCHAR(20),

-- --     PRIMARY KEY (Route_ID, Flight_ID, Flight_Date),

-- --     FOREIGN KEY (Route_ID) REFERENCES Airroutes(Route_ID),
-- --     FOREIGN KEY (Flight_ID) REFERENCES Flights(Flight_ID),
-- --     FOREIGN KEY (Gate_ID) REFERENCES Gates(Gate_ID)
-- -- );


-- -- CREATE TABLE Bookings (
-- --     Booking_ID SERIAL PRIMARY KEY,
-- --     Passenger_ID INT,
-- --     Route_ID INT,
-- --     Flight_ID INT,
-- --     Flight_Date DATE,
-- --     Booking_Date DATE,
-- --     Booking_Status VARCHAR(30),

-- --     FOREIGN KEY (Passenger_ID) REFERENCES Passenger(Passenger_ID),
-- --     FOREIGN KEY (Route_ID, Flight_ID, Flight_Date) 
-- --         REFERENCES Scheduled_Flight(Route_ID, Flight_ID, Flight_Date)
-- -- );

-- -- CREATE TABLE Boarding_Pass (
-- --     Booking_ID INT PRIMARY KEY,
-- --     Seat_Number VARCHAR(10),
-- --     Boarding_Group VARCHAR(10),
-- --     Boarding_Time TIME,

-- --     FOREIGN KEY (Booking_ID) REFERENCES Bookings(Booking_ID)
-- -- );

-- -- CREATE TABLE Luggage (
-- --     Luggage_ID SERIAL PRIMARY KEY,
-- --     Booking_ID INT,
-- --     Weight DECIMAL(5,2),
-- --     Security_Status VARCHAR(20),
-- --     Checkin_Time TIMESTAMP,

-- --     FOREIGN KEY (Booking_ID) REFERENCES Bookings(Booking_ID)
-- -- );

-- -- CREATE TABLE Staff_Manages (
-- --     Staff_ID INT,
-- --     Route_ID INT,
-- --     Flight_ID INT,
-- --     Flight_Date DATE,

-- --     PRIMARY KEY (Staff_ID, Route_ID, Flight_ID, Flight_Date),

-- --     FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
-- --     FOREIGN KEY (Route_ID, Flight_ID, Flight_Date) 
-- --         REFERENCES Scheduled_Flight(Route_ID, Flight_ID, Flight_Date)


-- -- ============================================
-- -- Airport Management System - Sample Data
-- -- ============================================

-- -- 1. Passenger
-- INSERT INTO Passenger VALUES
-- (1, 'Rahul Sharma', 'rahul@gmail.com', '9876543210', 'P1234567'),
-- (2, 'Priya Nair', 'priya@gmail.com', '9876543211', 'P1234568'),
-- (3, 'Amit Patel', 'amit@gmail.com', '9876543212', 'P1234569'),
-- (4, 'Sneha Reddy', 'sneha@gmail.com', '9876543213', 'P1234570'),
-- (5, 'Kiran Kumar', 'kiran@gmail.com', '9876543214', 'P1234571'),
-- (6, 'Divya Menon', 'divya@gmail.com', '9876543215', 'P1234572'),
-- (7, 'Arjun Singh', 'arjun@gmail.com', '9876543216', 'P1234573'),
-- (8, 'Meera Joshi', 'meera@gmail.com', '9876543217', 'P1234574'),
-- (9, 'Suresh Babu', 'suresh@gmail.com', '9876543218', 'P1234575'),
-- (10, 'Ananya Das', 'ananya@gmail.com', '9876543219', 'P1234576'),
-- (11, 'Vikram Iyer', 'vikram@gmail.com', '9876543220', 'P1234577'),
-- (12, 'Pooja Gupta', 'pooja@gmail.com', '9876543221', 'P1234578'),
-- (13, 'Ravi Verma', 'ravi@gmail.com', '9876543222', 'P1234579'),
-- (14, 'Lakshmi Rao', 'lakshmi@gmail.com', '9876543223', 'P1234580'),
-- (15, 'Nikhil Chopra', 'nikhil@gmail.com', '9876543224', 'P1234581'),
-- (16, 'Kavya Pillai', 'kavya@gmail.com', '9876543225', 'P1234582'),
-- (17, 'Sanjay Mehta', 'sanjay@gmail.com', '9876543226', 'P1234583'),
-- (18, 'Deepa Krishnan', 'deepa@gmail.com', '9876543227', 'P1234584'),
-- (19, 'Ajay Tiwari', 'ajay@gmail.com', '9876543228', 'P1234585'),
-- (20, 'Nisha Bose', 'nisha@gmail.com', '9876543229', 'P1234586');

-- -- 2. Staff
-- INSERT INTO Staff VALUES
-- (1, 'Ramesh Kumar', 'ramesh_k', 'hash001', 'Admin', '12 MG Road', 'Bangalore', 'Karnataka'),
-- (2, 'Sunita Sharma', 'sunita_s', 'hash002', 'Security', '45 Anna Salai', 'Chennai', 'Tamil Nadu'),
-- (3, 'Prakash Nair', 'prakash_n', 'hash003', 'Ground_Staff', '78 Nehru St', 'Kochi', 'Kerala'),
-- (4, 'Anita Rao', 'anita_r', 'hash004', 'Security', '23 Park Ave', 'Hyderabad', 'Telangana'),
-- (5, 'Vijay Patel', 'vijay_p', 'hash005', 'Ground_Staff', '56 Ring Road', 'Ahmedabad', 'Gujarat'),
-- (6, 'Rekha Iyer', 'rekha_i', 'hash006', 'Admin', '90 Linking Rd', 'Mumbai', 'Maharashtra'),
-- (7, 'Mohan Das', 'mohan_d', 'hash007', 'Ground_Staff', '34 Civil Lines', 'Delhi', 'Delhi'),
-- (8, 'Preethi Nair', 'preethi_n', 'hash008', 'Security', '67 Lake View', 'Pune', 'Maharashtra'),
-- (9, 'Arun Menon', 'arun_m', 'hash009', 'Ground_Staff', '11 Hill St', 'Trivandrum', 'Kerala'),
-- (10, 'Kavitha Reddy', 'kavitha_r', 'hash010', 'Admin', '88 Tank Bund', 'Hyderabad', 'Telangana');

-- -- 3. Airports
-- INSERT INTO Airport VALUES
-- (1, 'Indira Gandhi International', 'Delhi', 'Delhi', 'India'),
-- (2, 'Chhatrapati Shivaji Maharaj', 'Mumbai', 'Maharashtra', 'India'),
-- (3, 'Kempegowda International', 'Bangalore', 'Karnataka', 'India'),
-- (4, 'Chennai International', 'Chennai', 'Tamil Nadu', 'India'),
-- (5, 'Rajiv Gandhi International', 'Hyderabad', 'Telangana', 'India'),
-- (6, 'Cochin International', 'Kochi', 'Kerala', 'India'),
-- (7, 'Netaji Subhas Chandra Bose', 'Kolkata', 'West Bengal', 'India'),
-- (8, 'Sardar Vallabhbhai Patel', 'Ahmedabad', 'Gujarat', 'India'),
-- (9, 'Pune Airport', 'Pune', 'Maharashtra', 'India'),
-- (10, 'Trivandrum International', 'Trivandrum', 'Kerala', 'India');

-- -- 4. Airroutes
-- INSERT INTO Airroutes VALUES
-- (1, 1, 2, 1150),
-- (2, 1, 3, 1740),
-- (3, 1, 4, 2180),
-- (4, 1, 5, 1250),
-- (5, 2, 3, 980),
-- (6, 2, 4, 1330),
-- (7, 2, 6, 1200),
-- (8, 3, 4, 1060),
-- (9, 3, 5, 570),
-- (10, 4, 5, 630),
-- (11, 4, 6, 690),
-- (12, 5, 6, 740),
-- (13, 6, 7, 1890),
-- (14, 7, 1, 1480),
-- (15, 8, 1, 950),
-- (16, 8, 2, 530),
-- (17, 9, 1, 1410),
-- (18, 9, 3, 840),
-- (19, 10, 4, 680),
-- (20, 10, 6, 220);

-- -- 5. Gates
-- INSERT INTO Gates VALUES
-- (1, 'A1', 1, 'Available'),
-- (2, 'A2', 1, 'Occupied'),
-- (3, 'A3', 1, 'Maintenance'),
-- (4, 'B1', 2, 'Available'),
-- (5, 'B2', 2, 'Occupied'),
-- (6, 'B3', 2, 'Available'),
-- (7, 'C1', 3, 'Available'),
-- (8, 'C2', 3, 'Occupied'),
-- (9, 'D1', 4, 'Available'),
-- (10, 'D2', 4, 'Maintenance'),
-- (11, 'E1', 5, 'Available'),
-- (12, 'E2', 5, 'Occupied'),
-- (13, 'F1', 6, 'Available'),
-- (14, 'F2', 6, 'Available'),
-- (15, 'G1', 7, 'Occupied'),
-- (16, 'G2', 7, 'Available'),
-- (17, 'H1', 8, 'Available'),
-- (18, 'H2', 8, 'Maintenance'),
-- (19, 'I1', 9, 'Available'),
-- (20, 'I2', 10, 'Available');

-- -- 6. Flights
-- INSERT INTO Flights VALUES
-- (1, 'AI101', 'Boeing 737', 180),
-- (2, 'AI102', 'Airbus A320', 160),
-- (3, 'AI103', 'Boeing 777', 300),
-- (4, 'AI104', 'Airbus A380', 400),
-- (5, 'AI105', 'Boeing 737', 180),
-- (6, 'AI106', 'Airbus A320', 160),
-- (7, 'AI107', 'Boeing 737', 180),
-- (8, 'AI108', 'Airbus A321', 200),
-- (9, 'AI109', 'Boeing 737', 180),
-- (10, 'AI110', 'Airbus A320', 160),
-- (11, '6E201', 'Airbus A320', 180),
-- (12, '6E202', 'Airbus A321', 200),
-- (13, '6E203', 'Boeing 737', 180),
-- (14, 'SG301', 'Boeing 737-800', 189),
-- (15, 'SG302', 'Boeing 737-800', 189),
-- (16, 'UK401', 'ATR 72', 70),
-- (17, 'UK402', 'ATR 72', 70),
-- (18, 'G8501', 'Boeing 737', 180),
-- (19, 'G8502', 'Airbus A320', 160),
-- (20, 'IX601', 'Airbus A320', 180);

-- -- 7. Scheduled_Flight
-- INSERT INTO Scheduled_Flight VALUES
-- (1, 1, '2024-01-15', '06:00', '08:00', 1, 'On_Time'),
-- (1, 2, '2024-01-15', '09:00', '11:30', 2, 'On_Time'),
-- (2, 3, '2024-01-15', '07:00', '09:45', 7, 'Delayed'),
-- (3, 4, '2024-01-15', '10:00', '14:00', 9, 'On_Time'),
-- (4, 5, '2024-01-15', '11:00', '13:30', 11, 'On_Time'),
-- (5, 6, '2024-01-15', '08:00', '09:45', 4, 'On_Time'),
-- (6, 7, '2024-01-15', '13:00', '15:20', 13, 'Cancelled'),
-- (7, 8, '2024-01-15', '14:00', '17:00', 15, 'On_Time'),
-- (8, 9, '2024-01-15', '06:30', '08:15', 7, 'On_Time'),
-- (9, 10, '2024-01-15', '09:30', '11:00', 9, 'Delayed'),
-- (10, 11, '2024-01-15', '16:00', '17:10', 11, 'On_Time'),
-- (11, 12, '2024-01-15', '17:00', '19:30', 13, 'On_Time'),
-- (12, 13, '2024-01-15', '18:00', '19:45', 1, 'On_Time'),
-- (13, 14, '2024-01-15', '19:00', '21:30', 4, 'On_Time'),
-- (14, 15, '2024-01-15', '20:00', '21:35', 7, 'Delayed'),
-- (15, 16, '2024-01-15', '07:30', '09:00', 17, 'On_Time'),
-- (16, 17, '2024-01-15', '10:30', '12:00', 19, 'On_Time'),
-- (17, 18, '2024-01-15', '12:00', '14:00', 1, 'On_Time'),
-- (18, 19, '2024-01-15', '15:00', '16:45', 7, 'On_Time'),
-- (19, 20, '2024-01-15', '21:00', '22:10', 9, 'On_Time'),
-- (20, 1, '2024-01-16', '06:00', '08:00', 1, 'On_Time');

-- -- 8. Bookings
-- INSERT INTO Bookings VALUES
-- (1, 1, 1, 1, '2024-01-15', '2024-01-01', 'Confirmed'),
-- (2, 2, 1, 2, '2024-01-15', '2024-01-02', 'Confirmed'),
-- (3, 3, 2, 3, '2024-01-15', '2024-01-02', 'Confirmed'),
-- (4, 4, 3, 4, '2024-01-15', '2024-01-03', 'Cancelled'),
-- (5, 5, 4, 5, '2024-01-15', '2024-01-03', 'Confirmed'),
-- (6, 6, 5, 6, '2024-01-15', '2024-01-04', 'Confirmed'),
-- (7, 7, 6, 7, '2024-01-15', '2024-01-04', 'Confirmed'),
-- (8, 8, 7, 8, '2024-01-15', '2024-01-05', 'Confirmed'),
-- (9, 9, 8, 9, '2024-01-15', '2024-01-05', 'Confirmed'),
-- (10, 10, 9, 10, '2024-01-15', '2024-01-06', 'Confirmed'),
-- (11, 11, 10, 11, '2024-01-15', '2024-01-06', 'Confirmed'),
-- (12, 12, 11, 12, '2024-01-15', '2024-01-07', 'Confirmed'),
-- (13, 13, 12, 13, '2024-01-15', '2024-01-07', 'Confirmed'),
-- (14, 14, 13, 14, '2024-01-15', '2024-01-08', 'Waitlisted'),
-- (15, 15, 14, 15, '2024-01-15', '2024-01-08', 'Confirmed'),
-- (16, 16, 15, 16, '2024-01-15', '2024-01-09', 'Confirmed'),
-- (17, 17, 16, 17, '2024-01-15', '2024-01-09', 'Confirmed'),
-- (18, 18, 17, 18, '2024-01-15', '2024-01-10', 'Confirmed'),
-- (19, 19, 18, 19, '2024-01-15', '2024-01-10', 'Confirmed'),
-- (20, 20, 19, 20, '2024-01-15', '2024-01-11', 'Confirmed');

-- -- 9. Boarding_Pass
-- INSERT INTO Boarding_Pass VALUES
-- (1, '12A', 'Group1', '05:30'),
-- (2, '14B', 'Group2', '08:30'),
-- (3, '22C', 'Group1', '06:30'),
-- (5, '8D', 'Group1', '10:30'),
-- (6, '5A', 'Group2', '07:30'),
-- (7, '18B', 'Group3', '12:30'),
-- (8, '25C', 'Group1', '13:30'),
-- (9, '3A', 'Group2', '06:00'),
-- (10, '11D', 'Group3', '09:00'),
-- (11, '7B', 'Group1', '15:30'),
-- (12, '19A', 'Group2', '16:30'),
-- (13, '2C', 'Group1', '17:30'),
-- (15, '16B', 'Group2', '19:30'),
-- (16, '9A', 'Group1', '07:00'),
-- (17, '21D', 'Group2', '10:00'),
-- (18, '4B', 'Group1', '11:30'),
-- (19, '13C', 'Group2', '14:30'),
-- (20, '6A', 'Group3', '20:30');

-- -- 10. Luggage
-- INSERT INTO Luggage VALUES
-- (1, 1, 23.5, 'Cleared', '2024-01-15 04:30:00'),
-- (2, 2, 18.0, 'Cleared', '2024-01-15 07:45:00'),
-- (3, 3, 30.0, 'Flagged', '2024-01-15 05:30:00'),
-- (4, 5, 15.5, 'Cleared', '2024-01-15 09:00:00'),
-- (5, 6, 22.0, 'Cleared', '2024-01-15 06:30:00'),
-- (6, 7, 10.0, 'Cleared', '2024-01-15 11:00:00'),
-- (7, 8, 28.5, 'Cleared', '2024-01-15 12:00:00'),
-- (8, 9, 20.0, 'Cleared', '2024-01-15 05:00:00'),
-- (9, 10, 17.5, 'Flagged', '2024-01-15 08:00:00'),
-- (10, 11, 25.0, 'Cleared', '2024-01-15 14:30:00'),
-- (11, 12, 19.0, 'Cleared', '2024-01-15 15:30:00'),
-- (12, 13, 12.5, 'Cleared', '2024-01-15 16:30:00'),
-- (13, 15, 23.0, 'Cleared', '2024-01-15 18:30:00'),
-- (14, 16, 16.0, 'Cleared', '2024-01-15 06:00:00'),
-- (15, 17, 21.5, 'Cleared', '2024-01-15 09:30:00'),
-- (16, 18, 14.0, 'Flagged', '2024-01-15 11:00:00'),
-- (17, 19, 26.0, 'Cleared', '2024-01-15 13:30:00'),
-- (18, 20, 18.5, 'Cleared', '2024-01-15 19:30:00');

-- -- 11. Staff_Manages
-- INSERT INTO Staff_Manages VALUES
-- (1, 1, 1, '2024-01-15'),
-- (2, 1, 2, '2024-01-15'),
-- (3, 2, 3, '2024-01-15'),
-- (4, 3, 4, '2024-01-15'),
-- (5, 4, 5, '2024-01-15'),
-- (6, 5, 6, '2024-01-15'),
-- (7, 6, 7, '2024-01-15'),
-- (8, 7, 8, '2024-01-15'),
-- (9, 8, 9, '2024-01-15'),
-- (10, 9, 10, '2024-01-15'),
-- (1, 10, 11, '2024-01-15'),
-- (2, 11, 12, '2024-01-15'),
-- (3, 12, 13, '2024-01-15'),
-- (4, 13, 14, '2024-01-15'),
-- (5, 14, 15, '2024-01-15'),
-- (6, 15, 16, '2024-01-15'),
-- (7, 16, 17, '2024-01-15'),
-- (8, 17, 18, '2024-01-15'),
-- (9, 18, 19, '2024-01-15'),
-- (10, 19, 20, '2024-01-15');


-- select * from airport

-- select * from airroutes

-- select * from boarding_pass

-- select * from  bookings   

-- select * from  flights   

-- select * from  gates 

-- ALTER TABLE Gates
-- DROP COLUMN Airport_ID;

-- select * from  luggage

-- select * from  passenger

-- select * from  scheduled_flight

-- select * from  staff

-- select * from  staff_manages



-- SELECT * FROM GetBoardingPass(1);



-- -- SELECT setval('passenger_passenger_id_seq', (SELECT MAX(passenger_id) FROM Passenger));
-- -- CALL RegisterPassenger(
-- --     'Rohit Agarwal',
-- --     'rohit.agarwal@gmail.com',
-- --     '919876543210',
-- --     'P2234587'
-- -- );
-- select * from passenger

-- ALTER TABLE staff
-- ADD COLUMN address VARCHAR(200);

-- UPDATE staff
-- SET address = street || ', ' || city || ', ' || state;

-- SELECT staff_id, name, address FROM staff;

-- ALTER TABLE staff
-- DROP COLUMN street,
-- DROP COLUMN city,
-- DROP COLUMN state;

-- ALTER TABLE bookings ADD COLUMN traveller_name VARCHAR(100);
-- ALTER TABLE bookings ADD COLUMN traveller_email VARCHAR(100);
-- ALTER TABLE bookings ADD COLUMN traveller_phone VARCHAR(20);
-- ALTER TABLE bookings ADD COLUMN traveller_passport VARCHAR(20);