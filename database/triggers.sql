-- CREATE OR REPLACE FUNCTION generate_boarding_pass()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     INSERT INTO Boarding_Pass(
--         Booking_ID, Seat_Number, Boarding_Group, Boarding_Time
--     )
--     VALUES (
--         NEW.Booking_ID,
--         'A' || FLOOR(RANDOM()*30 + 1),
--         'Group' || FLOOR(RANDOM()*3 + 1),
--         CURRENT_TIME + INTERVAL '1 hour'
--     );

--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER trg_generate_boarding_pass
-- AFTER INSERT ON Bookings
-- FOR EACH ROW
-- EXECUTE FUNCTION generate_boarding_pass();

-- CREATE OR REPLACE FUNCTION check_capacity()
-- RETURNS TRIGGER AS $$
-- DECLARE
--     total INT;
--     cap INT;
-- BEGIN
--     SELECT COUNT(*) INTO total
--     FROM Bookings
--     WHERE Flight_ID = NEW.Flight_ID
--       AND Flight_Date = NEW.Flight_Date;

--     SELECT Capacity INTO cap
--     FROM Flights
--     WHERE Flight_ID = NEW.Flight_ID;

--     IF total >= cap THEN
--         RAISE EXCEPTION 'Flight is full!';
--     END IF;

--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER trg_check_capacity
-- BEFORE INSERT ON Bookings
-- FOR EACH ROW
-- EXECUTE FUNCTION check_capacity();

-- CREATE OR REPLACE FUNCTION free_gate()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     UPDATE Gates
--     SET Status = 'Available'
--     WHERE Gate_ID = OLD.Gate_ID;

--     RETURN OLD;
-- END;
-- $$ LANGUAGE plpgsql;



-- CREATE TRIGGER trg_free_gate
-- AFTER UPDATE ON Scheduled_Flight
-- FOR EACH ROW
-- WHEN (OLD.Status = 'On Time' AND NEW.Status = 'Departed')
-- EXECUTE FUNCTION free_gate();

-- CREATE OR REPLACE FUNCTION check_luggage_weight()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     IF NEW.Weight > 30 THEN
--         RAISE EXCEPTION 'Luggage exceeds allowed weight!';
--     END IF;

--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER trg_luggage_weight
-- BEFORE INSERT ON Luggage
-- FOR EACH ROW
-- EXECUTE FUNCTION check_luggage_weight();

-- -- -- ============================================
-- -- -- TRIGGER 1: Cancel Boarding Pass when Booking is Cancelled
-- -- -- Table   : Bookings
-- -- -- When    : AFTER UPDATE
-- -- -- Purpose : Delete boarding pass if booking status changed to Cancelled
-- -- -- ============================================

-- -- CREATE OR REPLACE FUNCTION cancel_boarding_pass()
-- -- RETURNS TRIGGER AS $$
-- -- BEGIN
-- --     IF NEW.Booking_Status = 'Cancelled' AND OLD.Booking_Status != 'Cancelled' THEN
-- --         DELETE FROM Boarding_Pass
-- --         WHERE Booking_ID = OLD.Booking_ID;

-- --         RAISE NOTICE 'Boarding pass for Booking % has been removed.', OLD.Booking_ID;
-- --     END IF;

-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER trg_cancel_boarding_pass
-- -- AFTER UPDATE ON Bookings
-- -- FOR EACH ROW
-- -- EXECUTE FUNCTION cancel_boarding_pass();


-- -- -- ============================================
-- -- -- TRIGGER 2: Prevent Double Booking
-- -- -- Table   : Bookings
-- -- -- When    : BEFORE INSERT
-- -- -- Purpose : Prevent same passenger booking same flight on same date twice
-- -- -- ============================================

-- -- CREATE OR REPLACE FUNCTION prevent_double_booking()
-- -- RETURNS TRIGGER AS $$
-- -- BEGIN
-- --     IF EXISTS (
-- --         SELECT 1 FROM Bookings
-- --         WHERE Passenger_ID   = NEW.Passenger_ID
-- --           AND Flight_ID      = NEW.Flight_ID
-- --           AND Flight_Date    = NEW.Flight_Date
-- --           AND Booking_Status != 'Cancelled'
-- --     ) THEN
-- --         RAISE EXCEPTION 'Passenger % already has an active booking for this flight on %.', 
-- --             NEW.Passenger_ID, NEW.Flight_Date;
-- --     END IF;

-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER trg_prevent_double_booking
-- -- BEFORE INSERT ON Bookings
-- -- FOR EACH ROW
-- -- EXECUTE FUNCTION prevent_double_booking();


-- -- -- ============================================
-- -- -- TRIGGER 3: Log Flight Status Changes
-- -- -- Table   : Scheduled_Flight
-- -- -- When    : AFTER UPDATE
-- -- -- Purpose : Log whenever flight status changes (requires log table)
-- -- -- ============================================

-- -- -- Log table for flight status history
-- -- CREATE TABLE IF NOT EXISTS Flight_Status_Log (
-- --     Log_ID        SERIAL PRIMARY KEY,
-- --     Route_ID      INT,
-- --     Flight_ID     INT,
-- --     Flight_Date   DATE,
-- --     Old_Status    VARCHAR(20),
-- --     New_Status    VARCHAR(20),
-- --     Changed_At    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- -- );

-- -- CREATE OR REPLACE FUNCTION log_flight_status_change()
-- -- RETURNS TRIGGER AS $$
-- -- BEGIN
-- --     IF OLD.Status != NEW.Status THEN
-- --         INSERT INTO Flight_Status_Log(
-- --             Route_ID, Flight_ID, Flight_Date,
-- --             Old_Status, New_Status, Changed_At
-- --         )
-- --         VALUES (
-- --             OLD.Route_ID, OLD.Flight_ID, OLD.Flight_Date,
-- --             OLD.Status, NEW.Status, CURRENT_TIMESTAMP
-- --         );

-- --         RAISE NOTICE 'Flight status changed from % to % for Flight % on Route % dated %.', 
-- --             OLD.Status, NEW.Status, OLD.Flight_ID, OLD.Route_ID, OLD.Flight_Date;
-- --     END IF;

-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER trg_flight_status_update
-- -- AFTER UPDATE ON Scheduled_Flight
-- -- FOR EACH ROW
-- -- EXECUTE FUNCTION log_flight_status_change();


-- -- -- ============================================
-- -- -- TRIGGER 4: Prevent Gate Conflict
-- -- -- Table   : Scheduled_Flight
-- -- -- When    : BEFORE INSERT
-- -- -- Purpose : Prevent two flights using same gate at overlapping times on same date
-- -- -- ============================================

-- -- CREATE OR REPLACE FUNCTION check_gate_conflict()
-- -- RETURNS TRIGGER AS $$
-- -- DECLARE
-- --     conflict_count INT;
-- -- BEGIN
-- --     SELECT COUNT(*) INTO conflict_count
-- --     FROM Scheduled_Flight
-- --     WHERE Gate_ID     = NEW.Gate_ID
-- --       AND Flight_Date = NEW.Flight_Date
-- --       AND Status     != 'Cancelled'
-- --       AND (
-- --             NEW.Departure_Time < Arrival_Time
-- --         AND NEW.Arrival_Time   > Departure_Time
-- --       );

-- --     IF conflict_count > 0 THEN
-- --         RAISE EXCEPTION 'Gate % is already in use during this time slot on %.', 
-- --             NEW.Gate_ID, NEW.Flight_Date;
-- --     END IF;

-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER trg_gate_conflict
-- -- BEFORE INSERT ON Scheduled_Flight
-- -- FOR EACH ROW
-- -- EXECUTE FUNCTION check_gate_conflict();


-- -- -- ============================================
-- -- -- TRIGGER 5: Auto Set Luggage Checkin Timestamp
-- -- -- Table   : Luggage
-- -- -- When    : BEFORE INSERT
-- -- -- Purpose : Automatically set checkin time to current timestamp
-- -- -- ============================================

-- -- CREATE OR REPLACE FUNCTION set_luggage_checkin_time()
-- -- RETURNS TRIGGER AS $$
-- -- BEGIN
-- --     NEW.Checkin_Time := CURRENT_TIMESTAMP;
-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER trg_luggage_checkin_time
-- -- BEFORE INSERT ON Luggage
-- -- FOR EACH ROW
-- -- EXECUTE FUNCTION set_luggage_checkin_time();


-- -- -- ============================================
-- -- -- TRIGGER 6: Auto Set Booking Date
-- -- -- Table   : Bookings
-- -- -- When    : BEFORE INSERT
-- -- -- Purpose : Automatically set booking date to current date
-- -- -- ============================================

-- -- CREATE OR REPLACE FUNCTION set_booking_date()
-- -- RETURNS TRIGGER AS $$
-- -- BEGIN
-- --     NEW.Booking_Date := CURRENT_DATE;
-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER trg_booking_date
-- -- BEFORE INSERT ON Bookings
-- -- FOR EACH ROW
-- -- EXECUTE FUNCTION set_booking_date();


-- -- -- ============================================
-- -- -- TRIGGER 7: Staff Role Check for Flight Assignment
-- -- -- Table   : Staff_Manages
-- -- -- When    : BEFORE INSERT
-- -- -- Purpose : Only Ground_Staff or Admin can be assigned to manage flights
-- -- -- ============================================

-- -- CREATE OR REPLACE FUNCTION check_staff_role()
-- -- RETURNS TRIGGER AS $$
-- -- DECLARE
-- --     v_role VARCHAR(50);
-- -- BEGIN
-- --     SELECT Role INTO v_role
-- --     FROM Staff
-- --     WHERE Staff_ID = NEW.Staff_ID;

-- --     IF v_role NOT IN ('Ground_Staff', 'Admin') THEN
-- --         RAISE EXCEPTION 'Staff % has role %. Only Ground_Staff or Admin can be assigned to flights.', 
-- --             NEW.Staff_ID, v_role;
-- --     END IF;

-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER trg_staff_role_check
-- -- BEFORE INSERT ON Staff_Manages
-- -- FOR EACH ROW
-- -- EXECUTE FUNCTION check_staff_role();


-- -- -- ============================================
-- -- -- TRIGGER 8: Prevent Duplicate Passport on Insert
-- -- -- Table   : Passenger
-- -- -- When    : BEFORE INSERT
-- -- -- Purpose : Raise a clear error if passport number already exists
-- -- -- ============================================

-- -- CREATE OR REPLACE FUNCTION check_passport_duplicate()
-- -- RETURNS TRIGGER AS $$
-- -- BEGIN
-- --     IF EXISTS (
-- --         SELECT 1 FROM Passenger
-- --         WHERE Passport_Number = NEW.Passport_Number
-- --     ) THEN
-- --         RAISE EXCEPTION 'Passport number % is already registered.', NEW.Passport_Number;
-- --     END IF;

-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER trg_passport_duplicate
-- -- BEFORE INSERT ON Passenger
-- -- FOR EACH ROW
-- -- EXECUTE FUNCTION check_passport_duplicate();


-- -- -- ============================================
-- -- -- TRIGGER 9: Prevent Assigning Flight to Gate Under Maintenance
-- -- -- Table   : Scheduled_Flight
-- -- -- When    : BEFORE INSERT
-- -- -- Purpose : Block scheduling if gate status is Maintenance
-- -- -- ============================================

-- -- CREATE OR REPLACE FUNCTION check_gate_maintenance()
-- -- RETURNS TRIGGER AS $$
-- -- DECLARE
-- --     v_gate_status VARCHAR(20);
-- -- BEGIN
-- --     SELECT Status INTO v_gate_status
-- --     FROM Gates
-- --     WHERE Gate_ID = NEW.Gate_ID;

-- --     IF v_gate_status = 'Maintenance' THEN
-- --         RAISE EXCEPTION 'Gate % is currently under maintenance and cannot be assigned.', NEW.Gate_ID;
-- --     END IF;

-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER trg_gate_maintenance
-- -- BEFORE INSERT ON Scheduled_Flight
-- -- FOR EACH ROW
-- -- EXECUTE FUNCTION check_gate_maintenance();


-- -- -- ============================================
-- -- -- TRIGGER 10: Prevent Booking on Cancelled Flight
-- -- -- Table   : Bookings
-- -- -- When    : BEFORE INSERT
-- -- -- Purpose : Block booking if the scheduled flight is Cancelled or Departed
-- -- -- ============================================

-- -- CREATE OR REPLACE FUNCTION check_flight_available_for_booking()
-- -- RETURNS TRIGGER AS $$
-- -- DECLARE
-- --     v_flight_status VARCHAR(20);
-- -- BEGIN
-- --     SELECT Status INTO v_flight_status
-- --     FROM Scheduled_Flight
-- --     WHERE Route_ID    = NEW.Route_ID
-- --       AND Flight_ID   = NEW.Flight_ID
-- --       AND Flight_Date = NEW.Flight_Date;

-- --     IF v_flight_status IS NULL THEN
-- --         RAISE EXCEPTION 'No scheduled flight found for the given Route, Flight, and Date.';
-- --     END IF;

-- --     IF v_flight_status IN ('Cancelled', 'Departed') THEN
-- --         RAISE EXCEPTION 'Cannot book. Flight status is %.', v_flight_status;
-- --     END IF;

-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER trg_flight_departure_check
-- -- BEFORE INSERT ON Bookings
-- -- FOR EACH ROW
-- -- EXECUTE FUNCTION check_flight_available_for_booking();

- ============================================
-- TRIGGER 1: AFTER INSERT ON Staff
-- When admin adds a new staff member,
-- automatically:
--   1. Create a LOGIN role with their username
--   2. Grant the appropriate group role
-- ============================================
 
-- CREATE OR REPLACE FUNCTION auto_create_staff_role()
-- RETURNS TRIGGER AS $$
-- DECLARE
--     v_group_role VARCHAR(50);
-- BEGIN
--     -- Map Staff.Role to group role name
--     v_group_role := CASE NEW.Role
--         WHEN 'Admin'        THEN 'admin'
--         WHEN 'Ground_Staff' THEN 'ground_staff'
--         WHEN 'Security'     THEN 'security_staff'
--         WHEN 'Checkin'      THEN 'checkin_staff'
--         ELSE NULL
--     END;
 
--     IF v_group_role IS NULL THEN
--         RAISE EXCEPTION 'Unknown role: %. Use Admin, Ground_Staff, Security, or Checkin.', NEW.Role;
--     END IF;
 
--     -- Check if login role already exists
--     IF EXISTS (
--         SELECT 1 FROM pg_roles WHERE rolname = NEW.Username
--     ) THEN
--         RAISE NOTICE 'Login role % already exists. Skipping creation.', NEW.Username;
--     ELSE
--         -- Create login role with username and password_hash as password
--         EXECUTE format(
--             'CREATE ROLE %I LOGIN PASSWORD %L',
--             NEW.Username,
--             NEW.Password_Hash
--         );
--         RAISE NOTICE 'Created login role: %', NEW.Username;
--     END IF;
 
--     -- Grant the group role to the login role
--     EXECUTE format(
--         'GRANT %I TO %I',
--         v_group_role,
--         NEW.Username
--     );
 
--     RAISE NOTICE 'Granted role % to %', v_group_role, NEW.Username;
 
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
 
-- -- Create the trigger
-- CREATE TRIGGER trg_auto_create_staff_role
-- AFTER INSERT ON Staff
-- FOR EACH ROW
-- EXECUTE FUNCTION auto_create_staff_role();
 
 
-- -- ============================================
-- -- TRIGGER 2: AFTER DELETE ON Staff
-- -- When admin deletes a staff member,
-- -- automatically:
-- --   1. Revoke the group role from their login role
-- --   2. Drop their login role
-- -- ============================================
 
-- CREATE OR REPLACE FUNCTION auto_drop_staff_role()
-- RETURNS TRIGGER AS $$
-- DECLARE
--     v_group_role VARCHAR(50);
-- BEGIN
--     -- Map Staff.Role to group role name
--     v_group_role := CASE OLD.Role
--         WHEN 'Admin'        THEN 'admin'
--         WHEN 'Ground_Staff' THEN 'ground_staff'
--         WHEN 'Security'     THEN 'security_staff'
--         WHEN 'Checkin'      THEN 'checkin_staff'
--         ELSE NULL
--     END;
 
--     -- Check if login role exists before trying to drop
--     IF NOT EXISTS (
--         SELECT 1 FROM pg_roles WHERE rolname = OLD.Username
--     ) THEN
--         RAISE NOTICE 'Login role % does not exist. Skipping drop.', OLD.Username;
--         RETURN OLD;
--     END IF;
 
--     -- Revoke group role first
--     IF v_group_role IS NOT NULL THEN
--         EXECUTE format(
--             'REVOKE %I FROM %I',
--             v_group_role,
--             OLD.Username
--         );
--         RAISE NOTICE 'Revoked role % from %', v_group_role, OLD.Username;
--     END IF;
 
--     -- Terminate any active sessions for this role
--     PERFORM pg_terminate_backend(pid)
--     FROM pg_stat_activity
--     WHERE usename = OLD.Username;
 
--     -- Drop the login role
--     EXECUTE format('DROP ROLE IF EXISTS %I', OLD.Username);
 
--     RAISE NOTICE 'Dropped login role: %', OLD.Username;
 
--     RETURN OLD;
-- END;
-- $$ LANGUAGE plpgsql;
 
-- -- Create the trigger
-- CREATE TRIGGER trg_auto_drop_staff_role
-- AFTER DELETE ON Staff
-- FOR EACH ROW
-- EXECUTE FUNCTION auto_drop_staff_role();
 
 
-- -- ============================================
-- -- TRIGGER 3: AFTER UPDATE ON Staff (Role change)
-- -- When admin updates a staff member's role,
-- -- automatically:
-- --   1. Revoke old group role
-- --   2. Grant new group role
-- -- ============================================
 
-- CREATE OR REPLACE FUNCTION auto_update_staff_role()
-- RETURNS TRIGGER AS $$
-- DECLARE
--     v_old_group VARCHAR(50);
--     v_new_group VARCHAR(50);
-- BEGIN
--     -- Only fire if Role or Username changed
--     IF OLD.Role = NEW.Role AND OLD.Username = NEW.Username THEN
--         RETURN NEW;
--     END IF;
 
--     -- Map old role
--     v_old_group := CASE OLD.Role
--         WHEN 'Admin'        THEN 'admin'
--         WHEN 'Ground_Staff' THEN 'ground_staff'
--         WHEN 'Security'     THEN 'security_staff'
--         WHEN 'Checkin'      THEN 'checkin_staff'
--         ELSE NULL
--     END;
 
--     -- Map new role
--     v_new_group := CASE NEW.Role
--         WHEN 'Admin'        THEN 'admin'
--         WHEN 'Ground_Staff' THEN 'ground_staff'
--         WHEN 'Security'     THEN 'security_staff'
--         WHEN 'Checkin'      THEN 'checkin_staff'
--         ELSE NULL
--     END;
 
--     IF v_new_group IS NULL THEN
--         RAISE EXCEPTION 'Unknown role: %. Use Admin, Ground_Staff, Security, or Checkin.', NEW.Role;
--     END IF;
 
--     -- Check login role exists
--     IF NOT EXISTS (
--         SELECT 1 FROM pg_roles WHERE rolname = NEW.Username
--     ) THEN
--         -- Create it if it doesn't exist
--         EXECUTE format(
--             'CREATE ROLE %I LOGIN PASSWORD %L',
--             NEW.Username,
--             NEW.Password_Hash
--         );
--         RAISE NOTICE 'Created login role: %', NEW.Username;
--     END IF;
 
--     -- Revoke old group role
--     IF v_old_group IS NOT NULL THEN
--         EXECUTE format('REVOKE %I FROM %I', v_old_group, NEW.Username);
--         RAISE NOTICE 'Revoked old role % from %', v_old_group, NEW.Username;
--     END IF;
 
--     -- Grant new group role
--     EXECUTE format('GRANT %I TO %I', v_new_group, NEW.Username);
--     RAISE NOTICE 'Granted new role % to %', v_new_group, NEW.Username;
 
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
 
-- -- Create the trigger
-- CREATE TRIGGER trg_auto_update_staff_role
-- AFTER UPDATE ON Staff
-- FOR EACH ROW
-- EXECUTE FUNCTION auto_update_staff_role();
