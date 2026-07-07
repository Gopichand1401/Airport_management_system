-- CREATE OR REPLACE FUNCTION BookFlight(
--     p_passenger_id INT,
--     p_route_id INT,
--     p_flight_id INT,
--     p_flight_date DATE
-- )
-- RETURNS INT AS $$
-- DECLARE
--     new_booking_id INT;
-- BEGIN
--     INSERT INTO Bookings (
--         Passenger_ID, Route_ID, Flight_ID, Flight_Date,
--         Booking_Date, Booking_Status
--     )
--     VALUES (
--         p_passenger_id, p_route_id, p_flight_id, p_flight_date,
--         CURRENT_DATE, 'Confirmed'
--     )
--     RETURNING Booking_ID INTO new_booking_id;

--     RETURN new_booking_id;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION AssignGate(
--     p_route_id INT,
--     p_flight_id INT,
--     p_flight_date DATE,
--     p_gate_id INT
-- )
-- RETURNS VOID AS $$
-- BEGIN
--     UPDATE Scheduled_Flight
--     SET Gate_ID = p_gate_id
--     WHERE Route_ID = p_route_id
--       AND Flight_ID = p_flight_id
--       AND Flight_Date = p_flight_date;

--     UPDATE Gates
--     SET Status = 'Occupied'
--     WHERE Gate_ID = p_gate_id;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION UpdateLuggageStatus(
--     p_luggage_id INT,
--     p_status VARCHAR
-- )
-- RETURNS VOID AS $$
-- BEGIN
--     UPDATE Luggage
--     SET Security_Status = p_status
--     WHERE Luggage_ID = p_luggage_id;
-- END;
-- $$ LANGUAGE plpgsql;






-- CREATE OR REPLACE PROCEDURE RegisterPassenger(
--     p_name VARCHAR(100),
--     p_email VARCHAR(100),
--     p_phone VARCHAR(15),
--     p_passport VARCHAR(20)
-- )
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
--     new_id INT;
-- BEGIN

--     IF EXISTS (SELECT 1 FROM Passenger WHERE Email = p_email) THEN
--         RAISE EXCEPTION 'Error: Email already registered.';

--     ELSIF EXISTS (SELECT 1 FROM Passenger WHERE Passport_Number = p_passport) THEN
--         RAISE EXCEPTION 'Error: Passport number already registered.';

--     ELSE
--         INSERT INTO Passenger (Name, Email, Phone, Passport_Number)
--         VALUES (p_name, p_email, p_phone, p_passport)
--         RETURNING Passenger_ID INTO new_id;

--         RAISE NOTICE 'New Passenger ID: %', new_id;
--     END IF;

-- END;
-- $$;

-- 3.2 Get boarding pass details
-- CREATE OR REPLACE FUNCTION GetBoardingPass(p_booking_id INT)
-- RETURNS TABLE(
--     Booking_ID INT,
--     Passenger_Name VARCHAR,
--     Passport_Number VARCHAR,
--     Flight_No VARCHAR,
--     From_Airport VARCHAR,
--     To_Airport VARCHAR,
--     Flight_Date DATE,
--     Departure_Time TIME,
--     Arrival_Time TIME,
--     Gate_Number VARCHAR,
--     Seat_Number VARCHAR,
--     Boarding_Group VARCHAR,
--     Boarding_Time TIME
-- )
-- AS $$
-- BEGIN
--     RETURN QUERY
--     SELECT
--         bp.Booking_ID,
--         p.Name,
--         p.Passport_Number,
--         f.Flight_No,
--         a1.Airport_Name,
--         a2.Airport_Name,
--         sf.Flight_Date,
--         sf.Departure_Time,
--         sf.Arrival_Time,
--         g.Gate_Number,
--         bp.Seat_Number,
--         bp.Boarding_Group,
--         bp.Boarding_Time
--     FROM Boarding_Pass bp
--     JOIN Bookings b        ON bp.Booking_ID = b.Booking_ID
--     JOIN Passenger p       ON b.Passenger_ID = p.Passenger_ID
--     JOIN Flights f         ON b.Flight_ID = f.Flight_ID
--     JOIN Scheduled_Flight sf ON b.Flight_ID = sf.Flight_ID
--                              AND b.Route_ID = sf.Route_ID
--                              AND b.Flight_Date = sf.Flight_Date
--     JOIN Gates g           ON sf.Gate_ID = g.Gate_ID
--     JOIN Airroutes ar      ON b.Route_ID = ar.Route_ID
--     JOIN Airport a1        ON ar.Origin_Airport = a1.Airport_ID
--     JOIN Airport a2        ON ar.Destination_Airport = a2.Airport_ID
--     WHERE bp.Booking_ID = p_booking_id;
-- END;
-- $$ LANGUAGE plpgsql;

-- -- -- -- ============================================
-- -- -- -- PASSENGER FUNCTIONS
-- -- -- -- ============================================
-- -- -- -- 2. GetPassengerByID
-- -- -- CREATE OR REPLACE FUNCTION GetPassengerByID(p_id INT)
-- -- -- RETURNS TABLE(
-- -- --     Passenger_ID INT,
-- -- --     Name VARCHAR,
-- -- --     Email VARCHAR,
-- -- --     Phone VARCHAR,
-- -- --     Passport_Number VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT p.Passenger_ID, p.Name, p.Email, p.Phone, p.Passport_Number
-- -- --     FROM Passenger p
-- -- --     WHERE p.Passenger_ID = p_id;
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;

-- -- -- -- 3. UpdatePassenger
-- -- -- CREATE OR REPLACE PROCEDURE UpdatePassenger(
-- -- --     p_id INT,
-- -- --     p_name VARCHAR(100),
-- -- --     p_email VARCHAR(100),
-- -- --     p_phone VARCHAR(20),
-- -- --     p_passport VARCHAR(50)
-- -- -- )
-- -- -- LANGUAGE plpgsql AS $$
-- -- -- BEGIN
-- -- --     IF NOT EXISTS (SELECT 1 FROM Passenger WHERE Passenger_ID = p_id) THEN
-- -- --         RAISE EXCEPTION 'Passenger ID % not found.', p_id;
-- -- --     END IF;

-- -- --     UPDATE Passenger
-- -- --     SET Name            = COALESCE(p_name,     Name),
-- -- --         Email           = COALESCE(p_email,    Email),
-- -- --         Phone           = COALESCE(p_phone,    Phone),
-- -- --         Passport_Number = COALESCE(p_passport, Passport_Number)
-- -- --     WHERE Passenger_ID = p_id;

-- -- --     RAISE NOTICE 'Passenger % updated successfully.', p_id;
-- -- -- END;
-- -- -- $$;

-- -- -- -- 4. SearchPassenger
-- -- -- CREATE OR REPLACE FUNCTION SearchPassenger(p_keyword VARCHAR)
-- -- -- RETURNS TABLE(
-- -- --     Passenger_ID INT,
-- -- --     Name VARCHAR,
-- -- --     Email VARCHAR,
-- -- --     Phone VARCHAR,
-- -- --     Passport_Number VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT p.Passenger_ID, p.Name, p.Email, p.Phone, p.Passport_Number
-- -- --     FROM Passenger p
-- -- --     WHERE p.Name            ILIKE '%' || p_keyword || '%'
-- -- --        OR p.Email           ILIKE '%' || p_keyword || '%'
-- -- --        OR p.Passport_Number ILIKE '%' || p_keyword || '%';
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;


-- -- -- -- ============================================
-- -- -- -- STAFF FUNCTIONS
-- -- -- -- ============================================

-- -- -- -- 5. StaffLogin
-- -- -- CREATE OR REPLACE FUNCTION StaffLogin(
-- -- --     p_username VARCHAR,
-- -- --     p_password_hash TEXT
-- -- -- )
-- -- -- RETURNS TABLE(
-- -- --     Staff_ID INT,
-- -- --     Name VARCHAR,
-- -- --     Role VARCHAR,
-- -- --     Address VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT s.Staff_ID, s.Name, s.Role, s.Address
-- -- --     FROM Staff s
-- -- --     WHERE s.Username      = p_username
-- -- --       AND s.Password_Hash = p_password_hash;

-- -- --     IF NOT FOUND THEN
-- -- --         RAISE EXCEPTION 'Invalid username or password.';
-- -- --     END IF;
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;

-- -- -- -- 6. SearchStaff
-- -- -- CREATE OR REPLACE FUNCTION SearchStaff(p_keyword VARCHAR)
-- -- -- RETURNS TABLE(
-- -- --     Staff_ID INT,
-- -- --     Name VARCHAR,
-- -- --     Username VARCHAR,
-- -- --     Role VARCHAR,
-- -- --     Address VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT s.Staff_ID, s.Name, s.Username, s.Role, s.Address
-- -- --     FROM Staff s
-- -- --     WHERE s.Name     ILIKE '%' || p_keyword || '%'
-- -- --        OR s.Role     ILIKE '%' || p_keyword || '%'
-- -- --        OR s.Username ILIKE '%' || p_keyword || '%';
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;


-- -- -- -- ============================================
-- -- -- -- AIRPORT FUNCTIONS
-- -- -- -- ============================================

-- -- -- -- 7. GetAllAirports
-- -- -- CREATE OR REPLACE FUNCTION GetAllAirports()
-- -- -- RETURNS TABLE(
-- -- --     Airport_ID INT,
-- -- --     Airport_Name VARCHAR,
-- -- --     City VARCHAR,
-- -- --     State VARCHAR,
-- -- --     Country VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT a.Airport_ID, a.Airport_Name, a.City, a.State, a.Country
-- -- --     FROM Airport a
-- -- --     ORDER BY a.Airport_Name;
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;

-- -- -- -- 8. SearchAirport
-- -- -- CREATE OR REPLACE FUNCTION SearchAirport(p_keyword VARCHAR)
-- -- -- RETURNS TABLE(
-- -- --     Airport_ID INT,
-- -- --     Airport_Name VARCHAR,
-- -- --     City VARCHAR,
-- -- --     State VARCHAR,
-- -- --     Country VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT a.Airport_ID, a.Airport_Name, a.City, a.State, a.Country
-- -- --     FROM Airport a
-- -- --     WHERE a.Airport_Name ILIKE '%' || p_keyword || '%'
-- -- --        OR a.City         ILIKE '%' || p_keyword || '%'
-- -- --        OR a.Country      ILIKE '%' || p_keyword || '%';
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;


-- -- -- -- ============================================
-- -- -- -- AIRROUTES FUNCTIONS
-- -- -- -- ============================================

-- -- -- -- 9. GetRoutesByOrigin
-- -- -- CREATE OR REPLACE FUNCTION GetRoutesByOrigin(p_origin_airport_id INT)
-- -- -- RETURNS TABLE(
-- -- --     Route_ID INT,
-- -- --     Origin_Airport_Name VARCHAR,
-- -- --     Destination_Airport_Name VARCHAR,
-- -- --     Distance_KM INT
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT
-- -- --         ar.Route_ID,
-- -- --         a1.Airport_Name AS Origin,
-- -- --         a2.Airport_Name AS Destination,
-- -- --         ar.Distance_KM
-- -- --     FROM Airroutes ar
-- -- --     JOIN Airport a1 ON ar.Origin_Airport      = a1.Airport_ID
-- -- --     JOIN Airport a2 ON ar.Destination_Airport = a2.Airport_ID
-- -- --     WHERE ar.Origin_Airport = p_origin_airport_id;
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;

-- -- -- -- 10. SearchRoutes
-- -- -- CREATE OR REPLACE FUNCTION SearchRoutes(
-- -- --     p_origin INT,
-- -- --     p_destination INT
-- -- -- )
-- -- -- RETURNS TABLE(
-- -- --     Route_ID INT,
-- -- --     Origin_Airport_Name VARCHAR,
-- -- --     Destination_Airport_Name VARCHAR,
-- -- --     Distance_KM INT
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT
-- -- --         ar.Route_ID,
-- -- --         a1.Airport_Name AS Origin,
-- -- --         a2.Airport_Name AS Destination,
-- -- --         ar.Distance_KM
-- -- --     FROM Airroutes ar
-- -- --     JOIN Airport a1 ON ar.Origin_Airport      = a1.Airport_ID
-- -- --     JOIN Airport a2 ON ar.Destination_Airport = a2.Airport_ID
-- -- --     WHERE ar.Origin_Airport      = p_origin
-- -- --       AND ar.Destination_Airport = p_destination;
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;


-- -- -- -- ============================================
-- -- -- -- GATES FUNCTIONS
-- -- -- -- ============================================

-- -- -- -- 11. GetGatesByAirport
-- -- -- CREATE OR REPLACE FUNCTION GetGatesByAirport(p_airport_id INT)
-- -- -- RETURNS TABLE(
-- -- --     Gate_ID INT,
-- -- --     Gate_Number VARCHAR,
-- -- --     Status VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT g.Gate_ID, g.Gate_Number, g.Status
-- -- --     FROM Gates g
-- -- --     WHERE g.Airport_ID = p_airport_id
-- -- --     ORDER BY g.Gate_Number;
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;

-- -- -- -- 12. UpdateGateStatus
-- -- -- CREATE OR REPLACE PROCEDURE UpdateGateStatus(
-- -- --     p_gate_id INT,
-- -- --     p_status VARCHAR(20)
-- -- -- )
-- -- -- LANGUAGE plpgsql AS $$
-- -- -- BEGIN
-- -- --     IF NOT EXISTS (SELECT 1 FROM Gates WHERE Gate_ID = p_gate_id) THEN
-- -- --         RAISE EXCEPTION 'Gate ID % not found.', p_gate_id;
-- -- --     END IF;

-- -- --     IF p_status NOT IN ('Available', 'Occupied', 'Maintenance') THEN
-- -- --         RAISE EXCEPTION 'Invalid status. Use Available, Occupied, or Maintenance.';
-- -- --     END IF;

-- -- --     UPDATE Gates
-- -- --     SET Status = p_status
-- -- --     WHERE Gate_ID = p_gate_id;

-- -- --     RAISE NOTICE 'Gate % status updated to %.', p_gate_id, p_status;
-- -- -- END;
-- -- -- $$;

-- -- -- -- 13. SearchGate
-- -- -- CREATE OR REPLACE FUNCTION SearchGate(
-- -- --     p_airport_id INT,
-- -- --     p_status VARCHAR
-- -- -- )
-- -- -- RETURNS TABLE(
-- -- --     Gate_ID INT,
-- -- --     Gate_Number VARCHAR,
-- -- --     Airport_ID INT,
-- -- --     Status VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT g.Gate_ID, g.Gate_Number, g.Airport_ID, g.Status
-- -- --     FROM Gates g
-- -- --     WHERE (p_airport_id IS NULL OR g.Airport_ID = p_airport_id)
-- -- --       AND (p_status     IS NULL OR g.Status ILIKE p_status);
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;


-- -- -- -- ============================================
-- -- -- -- FLIGHTS FUNCTIONS
-- -- -- -- ============================================

-- -- -- -- 14. GetAllFlights
-- -- -- CREATE OR REPLACE FUNCTION GetAllFlights()
-- -- -- RETURNS TABLE(
-- -- --     Flight_ID INT,
-- -- --     Flight_No VARCHAR,
-- -- --     Aircraft_Type VARCHAR,
-- -- --     Capacity INT
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT f.Flight_ID, f.Flight_No, f.Aircraft_Type, f.Capacity
-- -- --     FROM Flights f
-- -- --     ORDER BY f.Flight_No;
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;

-- -- -- -- 15. SearchFlight
-- -- -- CREATE OR REPLACE FUNCTION SearchFlight(p_keyword VARCHAR)
-- -- -- RETURNS TABLE(
-- -- --     Flight_ID INT,
-- -- --     Flight_No VARCHAR,
-- -- --     Aircraft_Type VARCHAR,
-- -- --     Capacity INT
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT f.Flight_ID, f.Flight_No, f.Aircraft_Type, f.Capacity
-- -- --     FROM Flights f
-- -- --     WHERE f.Flight_No     ILIKE '%' || p_keyword || '%'
-- -- --        OR f.Aircraft_Type ILIKE '%' || p_keyword || '%';
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;


-- -- -- -- ============================================
-- -- -- -- SCHEDULED_FLIGHT FUNCTIONS
-- -- -- -- ============================================

-- -- -- -- 16. ScheduleFlight
-- -- -- CREATE OR REPLACE PROCEDURE ScheduleFlight(
-- -- --     p_route_id      INT,
-- -- --     p_flight_id     INT,
-- -- --     p_flight_date   DATE,
-- -- --     p_departure     TIME,
-- -- --     p_arrival       TIME,
-- -- --     p_gate_id       INT,
-- -- --     p_status        VARCHAR(20)
-- -- -- )
-- -- -- LANGUAGE plpgsql AS $$
-- -- -- BEGIN
-- -- --     IF EXISTS (
-- -- --         SELECT 1 FROM Scheduled_Flight
-- -- --         WHERE Route_ID    = p_route_id
-- -- --           AND Flight_ID   = p_flight_id
-- -- --           AND Flight_Date = p_flight_date
-- -- --     ) THEN
-- -- --         RAISE EXCEPTION 'This flight is already scheduled on this route and date.';
-- -- --     END IF;

-- -- --     IF NOT EXISTS (SELECT 1 FROM Gates WHERE Gate_ID = p_gate_id AND Status = 'Available') THEN
-- -- --         RAISE EXCEPTION 'Gate % is not available.', p_gate_id;
-- -- --     END IF;

-- -- --     INSERT INTO Scheduled_Flight(
-- -- --         Route_ID, Flight_ID, Flight_Date,
-- -- --         Departure_Time, Arrival_Time, Gate_ID, Status
-- -- --     )
-- -- --     VALUES (
-- -- --         p_route_id, p_flight_id, p_flight_date,
-- -- --         p_departure, p_arrival, p_gate_id, p_status
-- -- --     );

-- -- --     UPDATE Gates SET Status = 'Occupied' WHERE Gate_ID = p_gate_id;

-- -- --     RAISE NOTICE 'Flight scheduled successfully.';
-- -- -- END;
-- -- -- $$;

-- -- -- -- 17. GetFlightsByDate
-- -- -- CREATE OR REPLACE FUNCTION GetFlightsByDate(p_date DATE)
-- -- -- RETURNS TABLE(
-- -- --     Route_ID INT,
-- -- --     Flight_ID INT,
-- -- --     Flight_No VARCHAR,
-- -- --     Origin VARCHAR,
-- -- --     Destination VARCHAR,
-- -- --     Flight_Date DATE,
-- -- --     Departure_Time TIME,
-- -- --     Arrival_Time TIME,
-- -- --     Gate_Number VARCHAR,
-- -- --     Status VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT
-- -- --         sf.Route_ID,
-- -- --         sf.Flight_ID,
-- -- --         f.Flight_No,
-- -- --         a1.Airport_Name AS Origin,
-- -- --         a2.Airport_Name AS Destination,
-- -- --         sf.Flight_Date,
-- -- --         sf.Departure_Time,
-- -- --         sf.Arrival_Time,
-- -- --         g.Gate_Number,
-- -- --         sf.Status
-- -- --     FROM Scheduled_Flight sf
-- -- --     JOIN Flights    f  ON sf.Flight_ID           = f.Flight_ID
-- -- --     JOIN Airroutes  ar ON sf.Route_ID             = ar.Route_ID
-- -- --     JOIN Airport    a1 ON ar.Origin_Airport       = a1.Airport_ID
-- -- --     JOIN Airport    a2 ON ar.Destination_Airport  = a2.Airport_ID
-- -- --     JOIN Gates      g  ON sf.Gate_ID              = g.Gate_ID
-- -- --     WHERE sf.Flight_Date = p_date
-- -- --     ORDER BY sf.Departure_Time;
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;

-- -- -- -- 18. UpdateFlightStatus
-- -- -- CREATE OR REPLACE PROCEDURE UpdateFlightStatus(
-- -- --     p_route_id    INT,
-- -- --     p_flight_id   INT,
-- -- --     p_flight_date DATE,
-- -- --     p_status      VARCHAR(20)
-- -- -- )
-- -- -- LANGUAGE plpgsql AS $$
-- -- -- BEGIN
-- -- --     IF NOT EXISTS (
-- -- --         SELECT 1 FROM Scheduled_Flight
-- -- --         WHERE Route_ID    = p_route_id
-- -- --           AND Flight_ID   = p_flight_id
-- -- --           AND Flight_Date = p_flight_date
-- -- --     ) THEN
-- -- --         RAISE EXCEPTION 'Scheduled flight not found.';
-- -- --     END IF;

-- -- --     IF p_status NOT IN ('On_Time', 'Delayed', 'Cancelled', 'Departed') THEN
-- -- --         RAISE EXCEPTION 'Invalid status. Use On_Time, Delayed, Cancelled, or Departed.';
-- -- --     END IF;

-- -- --     UPDATE Scheduled_Flight
-- -- --     SET Status = p_status
-- -- --     WHERE Route_ID    = p_route_id
-- -- --       AND Flight_ID   = p_flight_id
-- -- --       AND Flight_Date = p_flight_date;

-- -- --     RAISE NOTICE 'Flight status updated to %.', p_status;
-- -- -- END;
-- -- -- $$;

-- -- -- -- 19. SearchScheduledFlight
-- -- -- CREATE OR REPLACE FUNCTION SearchScheduledFlight(
-- -- --     p_date   DATE    DEFAULT NULL,
-- -- --     p_status VARCHAR DEFAULT NULL,
-- -- --     p_route  INT     DEFAULT NULL
-- -- -- )
-- -- -- RETURNS TABLE(
-- -- --     Route_ID INT,
-- -- --     Flight_ID INT,
-- -- --     Flight_No VARCHAR,
-- -- --     Origin VARCHAR,
-- -- --     Destination VARCHAR,
-- -- --     Flight_Date DATE,
-- -- --     Departure_Time TIME,
-- -- --     Arrival_Time TIME,
-- -- --     Status VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT
-- -- --         sf.Route_ID,
-- -- --         sf.Flight_ID,
-- -- --         f.Flight_No,
-- -- --         a1.Airport_Name AS Origin,
-- -- --         a2.Airport_Name AS Destination,
-- -- --         sf.Flight_Date,
-- -- --         sf.Departure_Time,
-- -- --         sf.Arrival_Time,
-- -- --         sf.Status
-- -- --     FROM Scheduled_Flight sf
-- -- --     JOIN Flights   f  ON sf.Flight_ID           = f.Flight_ID
-- -- --     JOIN Airroutes ar ON sf.Route_ID             = ar.Route_ID
-- -- --     JOIN Airport   a1 ON ar.Origin_Airport       = a1.Airport_ID
-- -- --     JOIN Airport   a2 ON ar.Destination_Airport  = a2.Airport_ID
-- -- --     WHERE (p_date   IS NULL OR sf.Flight_Date = p_date)
-- -- --       AND (p_status IS NULL OR sf.Status      ILIKE p_status)
-- -- --       AND (p_route  IS NULL OR sf.Route_ID    = p_route);
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;


-- -- -- -- ============================================
-- -- -- -- BOOKINGS FUNCTIONS
-- -- -- -- ============================================

-- -- -- -- 20. CancelBooking
-- -- -- CREATE OR REPLACE PROCEDURE CancelBooking(p_booking_id INT)
-- -- -- LANGUAGE plpgsql AS $$
-- -- -- BEGIN
-- -- --     IF NOT EXISTS (SELECT 1 FROM Bookings WHERE Booking_ID = p_booking_id) THEN
-- -- --         RAISE EXCEPTION 'Booking ID % not found.', p_booking_id;
-- -- --     END IF;

-- -- --     IF (SELECT Booking_Status FROM Bookings WHERE Booking_ID = p_booking_id) = 'Cancelled' THEN
-- -- --         RAISE EXCEPTION 'Booking % is already cancelled.', p_booking_id;
-- -- --     END IF;

-- -- --     UPDATE Bookings
-- -- --     SET Booking_Status = 'Cancelled'
-- -- --     WHERE Booking_ID = p_booking_id;

-- -- --     RAISE NOTICE 'Booking % cancelled successfully.', p_booking_id;
-- -- -- END;
-- -- -- $$;

-- -- -- -- 21. GetBookingsByPassenger
-- -- -- CREATE OR REPLACE FUNCTION GetBookingsByPassenger(p_passenger_id INT)
-- -- -- RETURNS TABLE(
-- -- --     Booking_ID INT,
-- -- --     Flight_No VARCHAR,
-- -- --     Origin VARCHAR,
-- -- --     Destination VARCHAR,
-- -- --     Flight_Date DATE,
-- -- --     Booking_Date DATE,
-- -- --     Booking_Status VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT
-- -- --         b.Booking_ID,
-- -- --         f.Flight_No,
-- -- --         a1.Airport_Name AS Origin,
-- -- --         a2.Airport_Name AS Destination,
-- -- --         b.Flight_Date,
-- -- --         b.Booking_Date,
-- -- --         b.Booking_Status
-- -- --     FROM Bookings b
-- -- --     JOIN Flights   f  ON b.Flight_ID            = f.Flight_ID
-- -- --     JOIN Airroutes ar ON b.Route_ID              = ar.Route_ID
-- -- --     JOIN Airport   a1 ON ar.Origin_Airport       = a1.Airport_ID
-- -- --     JOIN Airport   a2 ON ar.Destination_Airport  = a2.Airport_ID
-- -- --     WHERE b.Passenger_ID = p_passenger_id
-- -- --     ORDER BY b.Flight_Date DESC;
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;

-- -- -- -- 22. SearchBooking
-- -- -- CREATE OR REPLACE FUNCTION SearchBooking(
-- -- --     p_passenger_id INT     DEFAULT NULL,
-- -- --     p_status       VARCHAR DEFAULT NULL,
-- -- --     p_date         DATE    DEFAULT NULL
-- -- -- )
-- -- -- RETURNS TABLE(
-- -- --     Booking_ID INT,
-- -- --     Passenger_ID INT,
-- -- --     Flight_No VARCHAR,
-- -- --     Flight_Date DATE,
-- -- --     Booking_Date DATE,
-- -- --     Booking_Status VARCHAR
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT
-- -- --         b.Booking_ID,
-- -- --         b.Passenger_ID,
-- -- --         f.Flight_No,
-- -- --         b.Flight_Date,
-- -- --         b.Booking_Date,
-- -- --         b.Booking_Status
-- -- --     FROM Bookings b
-- -- --     JOIN Flights f ON b.Flight_ID = f.Flight_ID
-- -- --     WHERE (p_passenger_id IS NULL OR b.Passenger_ID   = p_passenger_id)
-- -- --       AND (p_status       IS NULL OR b.Booking_Status ILIKE p_status)
-- -- --       AND (p_date         IS NULL OR b.Flight_Date    = p_date);
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;


-- -- -- -- ============================================
-- -- -- -- LUGGAGE FUNCTIONS
-- -- -- -- ============================================

-- -- -- -- 23. AddLuggage
-- -- -- CREATE OR REPLACE PROCEDURE AddLuggage(
-- -- --     p_booking_id INT,
-- -- --     p_weight     DECIMAL(5,2),
-- -- --     p_status     VARCHAR(20)
-- -- -- )
-- -- -- LANGUAGE plpgsql AS $$
-- -- -- BEGIN
-- -- --     IF NOT EXISTS (SELECT 1 FROM Bookings WHERE Booking_ID = p_booking_id) THEN
-- -- --         RAISE EXCEPTION 'Booking ID % not found.', p_booking_id;
-- -- --     END IF;

-- -- --     IF p_weight > 30 THEN
-- -- --         RAISE EXCEPTION 'Luggage weight exceeds 30kg limit.';
-- -- --     END IF;

-- -- --     INSERT INTO Luggage(Booking_ID, Weight, Security_Status, Checkin_Time)
-- -- --     VALUES (p_booking_id, p_weight, p_status, CURRENT_TIMESTAMP);

-- -- --     RAISE NOTICE 'Luggage added successfully for Booking %.', p_booking_id;
-- -- -- END;
-- -- -- $$;

-- -- -- -- 24. GetLuggageByBooking
-- -- -- CREATE OR REPLACE FUNCTION GetLuggageByBooking(p_booking_id INT)
-- -- -- RETURNS TABLE(
-- -- --     Luggage_ID INT,
-- -- --     Booking_ID INT,
-- -- --     Weight DECIMAL,
-- -- --     Security_Status VARCHAR,
-- -- --     Checkin_Time TIMESTAMP
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT l.Luggage_ID, l.Booking_ID, l.Weight, l.Security_Status, l.Checkin_Time
-- -- --     FROM Luggage l
-- -- --     WHERE l.Booking_ID = p_booking_id;
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;

-- -- -- -- 25. SearchLuggage
-- -- -- CREATE OR REPLACE FUNCTION SearchLuggage(
-- -- --     p_booking_id INT     DEFAULT NULL,
-- -- --     p_status     VARCHAR DEFAULT NULL
-- -- -- )
-- -- -- RETURNS TABLE(
-- -- --     Luggage_ID INT,
-- -- --     Booking_ID INT,
-- -- --     Weight DECIMAL,
-- -- --     Security_Status VARCHAR,
-- -- --     Checkin_Time TIMESTAMP
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT l.Luggage_ID, l.Booking_ID, l.Weight, l.Security_Status, l.Checkin_Time
-- -- --     FROM Luggage l
-- -- --     WHERE (p_booking_id IS NULL OR l.Booking_ID       = p_booking_id)
-- -- --       AND (p_status     IS NULL OR l.Security_Status ILIKE p_status);
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;


-- -- -- -- ============================================
-- -- -- -- STAFF_MANAGES FUNCTIONS
-- -- -- -- ============================================

-- -- -- -- 26. AssignStaffToFlight
-- -- -- CREATE OR REPLACE PROCEDURE AssignStaffToFlight(
-- -- --     p_staff_id    INT,
-- -- --     p_route_id    INT,
-- -- --     p_flight_id   INT,
-- -- --     p_flight_date DATE
-- -- -- )
-- -- -- LANGUAGE plpgsql AS $$
-- -- -- BEGIN
-- -- --     IF NOT EXISTS (SELECT 1 FROM Staff WHERE Staff_ID = p_staff_id) THEN
-- -- --         RAISE EXCEPTION 'Staff ID % not found.', p_staff_id;
-- -- --     END IF;

-- -- --     IF NOT EXISTS (
-- -- --         SELECT 1 FROM Scheduled_Flight
-- -- --         WHERE Route_ID    = p_route_id
-- -- --           AND Flight_ID   = p_flight_id
-- -- --           AND Flight_Date = p_flight_date
-- -- --     ) THEN
-- -- --         RAISE EXCEPTION 'Scheduled flight not found.';
-- -- --     END IF;

-- -- --     IF EXISTS (
-- -- --         SELECT 1 FROM Staff_Manages
-- -- --         WHERE Staff_ID    = p_staff_id
-- -- --           AND Route_ID    = p_route_id
-- -- --           AND Flight_ID   = p_flight_id
-- -- --           AND Flight_Date = p_flight_date
-- -- --     ) THEN
-- -- --         RAISE EXCEPTION 'Staff % is already assigned to this flight.', p_staff_id;
-- -- --     END IF;

-- -- --     INSERT INTO Staff_Manages(Staff_ID, Route_ID, Flight_ID, Flight_Date)
-- -- --     VALUES (p_staff_id, p_route_id, p_flight_id, p_flight_date);

-- -- --     RAISE NOTICE 'Staff % assigned to flight successfully.', p_staff_id;
-- -- -- END;
-- -- -- $$;

-- -- -- -- 27. SearchStaffFlight
-- -- -- CREATE OR REPLACE FUNCTION SearchStaffFlight(
-- -- --     p_staff_id    INT  DEFAULT NULL,
-- -- --     p_flight_date DATE DEFAULT NULL
-- -- -- )
-- -- -- RETURNS TABLE(
-- -- --     Staff_ID INT,
-- -- --     Staff_Name VARCHAR,
-- -- --     Role VARCHAR,
-- -- --     Flight_No VARCHAR,
-- -- --     Origin VARCHAR,
-- -- --     Destination VARCHAR,
-- -- --     Flight_Date DATE
-- -- -- ) AS $$
-- -- -- BEGIN
-- -- --     RETURN QUERY
-- -- --     SELECT
-- -- --         s.Staff_ID,
-- -- --         s.Name      AS Staff_Name,
-- -- --         s.Role,
-- -- --         f.Flight_No,
-- -- --         a1.Airport_Name AS Origin,
-- -- --         a2.Airport_Name AS Destination,
-- -- --         sm.Flight_Date
-- -- --     FROM Staff_Manages sm
-- -- --     JOIN Staff     s  ON sm.Staff_ID              = s.Staff_ID
-- -- --     JOIN Flights   f  ON sm.Flight_ID             = f.Flight_ID
-- -- --     JOIN Airroutes ar ON sm.Route_ID              = ar.Route_ID
-- -- --     JOIN Airport   a1 ON ar.Origin_Airport        = a1.Airport_ID
-- -- --     JOIN Airport   a2 ON ar.Destination_Airport   = a2.Airport_ID
-- -- --     WHERE (p_staff_id    IS NULL OR sm.Staff_ID    = p_staff_id)
-- -- --       AND (p_flight_date IS NULL OR sm.Flight_Date = p_flight_date);
-- -- -- END;
-- -- -- $$ LANGUAGE plpgsql;

