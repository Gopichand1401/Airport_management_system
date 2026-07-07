-- CREATE INDEX idx_passenger_email ON Passenger(Email);
-- CREATE INDEX idx_booking_passenger ON Bookings(Passenger_ID);
-- CREATE INDEX idx_flight_route ON Scheduled_Flight(Route_ID, Flight_ID);

-- ============================================
-- SECTION 1: INDICES (10 Total)
-- ============================================


-- -----------------------------------------------
-- B-TREE INDICES (4)
-- Best for: range queries, sorting, ordering,
--           multi-column searches, dates
-- -----------------------------------------------

-- 1. Search scheduled flights by date
CREATE INDEX idx_flight_date
    ON Scheduled_Flight USING BTREE (Flight_Date);

-- 2. Search routes by origin + destination
CREATE INDEX idx_route_origin_dest
    ON Airroutes USING BTREE (Origin_Airport, Destination_Airport);

-- 3. Search bookings by passenger
CREATE INDEX idx_booking_passenger
    ON Bookings USING BTREE (Passenger_ID);

-- 4. Scheduled_Flight composite for route+flight lookups
CREATE INDEX idx_flight_route
    ON Scheduled_Flight USING BTREE (Route_ID, Flight_ID);


-- -----------------------------------------------
-- HASH INDICES (3)
-- Best for: exact equality (=) only
-- -----------------------------------------------

-- 5. Filter bookings by status (Confirmed/Cancelled/Waitlisted)
CREATE INDEX idx_booking_status
    ON Bookings USING HASH (Booking_Status);

-- 6. Filter luggage by security status (Cleared/Flagged)
CREATE INDEX idx_luggage_status
    ON Luggage USING HASH (Security_Status);

-- 7. Filter gates by status (Available/Occupied/Maintenance)
-- CREATE INDEX idx_gate_status
--     ON Gates USING HASH (Status);


-- -- -----------------------------------------------
-- -- GIN INDICES (3)
-- -- Best for: ILIKE, full text pattern matching
-- -- -----------------------------------------------

-- -- Enable pg_trgm extension for GIN ILIKE support
-- CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- -- 8. Full text search on passenger name
-- CREATE INDEX idx_passenger_name_gin
--     ON Passenger USING GIN (Name gin_trgm_ops);

-- -- 9. Full text search on airport name
-- CREATE INDEX idx_airport_name_gin
--     ON Airport USING GIN (Airport_Name gin_trgm_ops);

-- -- 10. Full text search on staff name
-- CREATE INDEX idx_staff_name_gin
--     ON Staff USING GIN (Name gin_trgm_ops);

