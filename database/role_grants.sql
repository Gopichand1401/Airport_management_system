 --CREATE ROLE checkin_staff LOGIN PASSWORD 'check123';
-- CREATE ROLE security_staff LOGIN PASSWORD 'secure123';
-- CREATE ROLE ground_staff LOGIN PASSWORD 'ground123';
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
-- GRANT SELECT, INSERT ON Passenger TO checkin_staff;
-- GRANT SELECT, INSERT ON Bookings TO checkin_staff;
-- GRANT SELECT ON Boarding_Pass TO checkin_staff;
-- GRANT SELECT, UPDATE ON Luggage TO security_staff;
-- GRANT SELECT ON Boarding_Pass TO security_staff;
-- GRANT SELECT, UPDATE ON Scheduled_Flight TO ground_staff;
-- GRANT SELECT, UPDATE ON Gates TO ground_staff;
-- GRANT EXECUTE ON FUNCTION GetBoardingPass(INT) TO checkin_staff, security_staff;

-- GRANT EXECUTE ON FUNCTION BookFlight(INT, INT, INT, DATE) TO checkin_staff;

-- GRANT EXECUTE ON FUNCTION AssignGate(INT, INT, DATE, INT) TO admin, ground_staff;

-- GRANT EXECUTE ON FUNCTION UpdateLuggageStatus(INT, VARCHAR) TO security_staff;
-- GRANT SELECT ON PassengerBookingSummary TO checkin_staff;
-- GRANT SELECT ON FlightGateStatus TO ground_staff, admin;
-- GRANT SELECT ON LuggageSecurityView TO security_staff;

-- CREATE ROLE admin;
-- GRANT ALL PRIVILEGES ON DATABASE "AirportManagementsystem" TO admin;
-- GRANT CREATE, CONNECT ON DATABASE "AirportManagementsystem" TO admin;
-- CREATE ROLE ramesh_k LOGIN PASSWORD 'hash1';
-- GRANT admin TO ramesh_k;


-- -- ============================================
-- -- GRANT PERMISSIONS ON NEW VIEWS
-- -- ============================================

-- GRANT SELECT ON StaffFlightView   TO admin, ground_staff;
-- GRANT SELECT ON FlightRouteView   TO admin, ground_staff, checkin_staff;
-- GRANT SELECT ON BookingDetailsView TO admin, checkin_staff;
-- GRANT SELECT ON LuggageSummaryView TO admin, security_staff;


-- -- ============================================
-- -- SECTION 1: REVOKE ALL TABLE PRIVILEGES
-- -- ============================================

-- REVOKE ALL PRIVILEGES ON Passenger         FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Staff             FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Airport           FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Airroutes         FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Gates             FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Flights           FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Scheduled_Flight  FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Bookings          FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Boarding_Pass     FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Luggage           FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Staff_Manages     FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON Flight_Status_Log FROM admin, checkin_staff, security_staff, ground_staff;


-- -- ============================================
-- -- SECTION 2: REVOKE ALL VIEW PRIVILEGES
-- -- ============================================

-- REVOKE ALL PRIVILEGES ON PassengerBookingSummary FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON FlightGateStatus        FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON LuggageSecurityView     FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON StaffFlightView         FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON FlightRouteView         FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON BookingDetailsView      FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL PRIVILEGES ON LuggageSummaryView      FROM admin, checkin_staff, security_staff, ground_staff;


-- -- ============================================
-- -- SECTION 3: REVOKE ALL FUNCTION PRIVILEGES
-- -- ============================================

-- REVOKE ALL ON PROCEDURE RegisterPassenger(VARCHAR,VARCHAR,VARCHAR,VARCHAR)    FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION GetPassengerByID(INT)                                 FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION SearchPassenger(VARCHAR)                              FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION StaffLogin(VARCHAR,TEXT)                              FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION BookFlight(INT,INT,INT,DATE)                          FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION GetBookingsByPassenger(INT)                           FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION SearchBooking(INT,VARCHAR,DATE)                       FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION GetBoardingPass(INT)                                  FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION UpdateLuggageStatus(INT,VARCHAR)                      FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION SearchLuggage(INT,VARCHAR)                            FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION GetLuggageByBooking(INT)                              FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION GetFlightsByDate(DATE)                                FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION SearchScheduledFlight(DATE,VARCHAR,INT)               FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION AssignGate(INT,INT,DATE,INT)                          FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION SearchStaffFlight(INT,DATE)                           FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION SearchStaff(VARCHAR)                                  FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION GetAllAirports()                                      FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION SearchAirport(VARCHAR)                                FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION GetGatesByAirport(INT)                                FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION GetAllFlights()                                       FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION SearchFlight(VARCHAR)                                 FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION GetRoutesByOrigin(INT)                                FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON FUNCTION SearchRoutes(INT,INT)                                 FROM admin, checkin_staff, security_staff, ground_staff;


-- -- ============================================
-- -- SECTION 4: REVOKE ALL PROCEDURE PRIVILEGES
-- -- ============================================

-- REVOKE ALL ON PROCEDURE UpdatePassenger(INT,VARCHAR,VARCHAR,VARCHAR,VARCHAR) FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON PROCEDURE CancelBooking(INT)                                   FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON PROCEDURE AddLuggage(INT,DECIMAL,VARCHAR)                      FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON PROCEDURE ScheduleFlight(INT,INT,DATE,TIME,TIME,INT,VARCHAR)   FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON PROCEDURE UpdateFlightStatus(INT,INT,DATE,VARCHAR)             FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON PROCEDURE AssignStaffToFlight(INT,INT,INT,DATE)                FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE ALL ON PROCEDURE UpdateGateStatus(INT,VARCHAR)                        FROM admin, checkin_staff, security_staff, ground_staff;


-- -- ============================================
-- -- SECTION 5: REVOKE SEQUENCE & SCHEMA
-- -- ============================================

-- REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE USAGE ON SCHEMA public                FROM admin, checkin_staff, security_staff, ground_staff;
-- REVOKE CONNECT ON DATABASE "AirportManagementsystem" FROM admin, checkin_staff, security_staff, ground_staff;


-- -- ============================================
-- -- SECTION 6: REVOKE ROLE MEMBERSHIPS
-- -- ============================================

-- REVOKE admin          FROM ramesh_k;
-- REVOKE ground_staff   FROM prakash_n, mohan_d, arun_m;
-- REVOKE security_staff FROM sunita_s, preethi_n;
-- REVOKE checkin_staff  FROM kavitha_r;


-- ============================================
-- SECTION 7: DROP LOGIN USERS
-- ============================================

-- DROP ROLE IF EXISTS ramesh_k;
-- DROP ROLE IF EXISTS anita_r;
-- DROP ROLE IF EXISTS rekha_i;
-- DROP ROLE IF EXISTS prakash_n;
-- DROP ROLE IF EXISTS mohan_d;
-- DROP ROLE IF EXISTS arun_m;
-- DROP ROLE IF EXISTS sunita_s;
-- DROP ROLE IF EXISTS preethi_n;
-- DROP ROLE IF EXISTS kavitha_r;
-- DROP ROLE IF EXISTS vijay_p;
-- DROP ROLE IF EXISTS kavitha_r;


-- ============================================
-- SECTION 8: DROP ROLES
-- ============================================

-- DROP ROLE IF EXISTS checkin_staff;
-- DROP ROLE IF EXISTS security_staff;
-- DROP ROLE IF EXISTS ground_staff;
-- DROP ROLE IF EXISTS admin;
-- ============================================
-- Airport Management System
-- Roles Creation + Grants
-- Based on Report Tables 7.2 and 7.3
-- PostgreSQL
-- ============================================


-- ============================================
-- SECTION 1: DROP EXISTING ROLES (if any)
-- ============================================

-- DROP ROLE IF EXISTS checkin_staff;
-- DROP ROLE IF EXISTS security_staff;
-- DROP ROLE IF EXISTS ground_staff;
-- DROP ROLE IF EXISTS admin;


-- ============================================
-- SECTION 2: CREATE ROLES
-- ============================================

-- CREATE ROLE admin;
-- CREATE ROLE checkin_staff;
-- CREATE ROLE security_staff;
-- CREATE ROLE ground_staff;


-- ============================================
-- SECTION 3: CREATE LOGIN USERS PER ROLE
-- ============================================

-- -- Admin users
-- CREATE ROLE ramesh_k  LOGIN PASSWORD 'hash001';
-- CREATE ROLE anita_r   LOGIN PASSWORD 'hash004';
-- CREATE ROLE rekha_i   LOGIN PASSWORD 'hash006';

-- -- Checkin staff users (no specific login user in data, using generic)
-- -- Ground staff users
-- CREATE ROLE prakash_n LOGIN PASSWORD 'hash003';
-- CREATE ROLE mohan_d   LOGIN PASSWORD 'hash007';
-- CREATE ROLE arun_m    LOGIN PASSWORD 'hash009';

-- -- Security staff users
-- CREATE ROLE sunita_s  LOGIN PASSWORD 'hash002';
-- CREATE ROLE preethi_n LOGIN PASSWORD 'hash008';
-- CREATE ROLE kavitha_r LOGIN PASSWORD 'hash010';

-- -- Assign roles to users
-- GRANT admin         TO ramesh_k, anita_r, rekha_i;
-- GRANT ground_staff  TO prakash_n, mohan_d, arun_m;
-- GRANT security_staff TO sunita_s, preethi_n;
-- GRANT checkin_staff TO kavitha_r;


-- -- ============================================
-- -- SECTION 4: TABLE-LEVEL PRIVILEGES
-- -- Based on Table 7.2 in Report
-- -- ============================================

-- -- ── Passenger ────────────────────────────────
-- -- admin: ALL | checkin: SEL, INS | security: SEL | ground: —
-- GRANT ALL PRIVILEGES             ON Passenger      TO admin;
-- GRANT SELECT, INSERT             ON Passenger      TO checkin_staff;
-- GRANT SELECT                     ON Passenger      TO security_staff;

-- -- ── Staff ─────────────────────────────────────
-- -- admin: ALL | checkin: — | security: — | ground: SEL
-- GRANT ALL PRIVILEGES             ON Staff          TO admin;
-- GRANT SELECT                     ON Staff          TO ground_staff;

-- -- ── Airport ───────────────────────────────────
-- -- admin: ALL | checkin: SEL | security: — | ground: SEL
-- GRANT ALL PRIVILEGES             ON Airport        TO admin;
-- GRANT SELECT                     ON Airport        TO checkin_staff;
-- GRANT SELECT                     ON Airport        TO ground_staff;

-- -- ── Airroutes ─────────────────────────────────
-- -- admin: ALL | checkin: SEL | security: — | ground: SEL
-- GRANT ALL PRIVILEGES             ON Airroutes      TO admin;
-- GRANT SELECT                     ON Airroutes      TO checkin_staff;
-- GRANT SELECT                     ON Airroutes      TO ground_staff;

-- -- ── Gates ─────────────────────────────────────
-- -- admin: ALL | checkin: — | security: — | ground: SEL, UPD
-- GRANT ALL PRIVILEGES             ON Gates          TO admin;
-- GRANT SELECT, UPDATE             ON Gates          TO ground_staff;

-- -- ── Flights ───────────────────────────────────
-- -- admin: ALL | checkin: SEL | security: — | ground: SEL
-- GRANT ALL PRIVILEGES             ON Flights        TO admin;
-- GRANT SELECT                     ON Flights        TO checkin_staff;
-- GRANT SELECT                     ON Flights        TO ground_staff;

-- -- ── Scheduled_Flight ──────────────────────────
-- -- admin: ALL | checkin: SEL | security: SEL | ground: SEL, UPD
-- GRANT ALL PRIVILEGES             ON Scheduled_Flight TO admin;
-- GRANT SELECT                     ON Scheduled_Flight TO checkin_staff;
-- GRANT SELECT                     ON Scheduled_Flight TO security_staff;
-- GRANT SELECT, UPDATE             ON Scheduled_Flight TO ground_staff;

-- -- ── Bookings ──────────────────────────────────
-- -- admin: ALL | checkin: SEL, INS, UPD | security: SEL | ground: —
-- GRANT ALL PRIVILEGES             ON Bookings       TO admin;
-- GRANT SELECT, INSERT, UPDATE     ON Bookings       TO checkin_staff;
-- GRANT SELECT                     ON Bookings       TO security_staff;

-- -- ── Boarding_Pass ─────────────────────────────
-- -- admin: ALL | checkin: SEL | security: SEL | ground: —
-- GRANT ALL PRIVILEGES             ON Boarding_Pass  TO admin;
-- GRANT SELECT                     ON Boarding_Pass  TO checkin_staff;
-- GRANT SELECT                     ON Boarding_Pass  TO security_staff;

-- -- ── Luggage ───────────────────────────────────
-- -- admin: ALL | checkin: SEL, INS | security: SEL, UPD | ground: —
-- GRANT ALL PRIVILEGES             ON Luggage        TO admin;
-- GRANT SELECT, INSERT             ON Luggage        TO checkin_staff;
-- GRANT SELECT, UPDATE             ON Luggage        TO security_staff;

-- -- ── Staff_Manages ─────────────────────────────
-- -- admin: ALL | checkin: — | security: — | ground: SEL
-- GRANT ALL PRIVILEGES             ON Staff_Manages  TO admin;
-- GRANT SELECT                     ON Staff_Manages  TO ground_staff;

-- -- ── Flight_Status_Log ─────────────────────────
-- -- admin: ALL | ground: SEL (for monitoring)
-- GRANT ALL PRIVILEGES             ON Flight_Status_Log TO admin;
-- GRANT SELECT                     ON Flight_Status_Log TO ground_staff;

-- -- ── Sequences (for SERIAL columns) ───────────
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO admin;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO checkin_staff;


-- -- ============================================
-- -- SECTION 5: FUNCTION EXECUTION PRIVILEGES
-- -- Based on Table 7.3 in Report
-- -- ============================================

-- -- ── RegisterPassenger ─────────────────────────
-- -- admin: EXEC | checkin: EXEC
-- GRANT EXECUTE ON FUNC RegisterPassenger(VARCHAR,VARCHAR,VARCHAR,VARCHAR)
--     TO admin, checkin_staff;

-- -- ── GetPassengerByID ──────────────────────────
-- -- admin: EXEC | checkin: EXEC
-- GRANT EXECUTE ON FUNCTION GetPassengerByID(INT)
--     TO admin, checkin_staff;

-- -- ── UpdatePassenger ───────────────────────────
-- -- admin: EXEC | checkin: EXEC
-- GRANT EXECUTE ON PROCEDURE UpdatePassenger(INT,VARCHAR,VARCHAR,VARCHAR,VARCHAR)
--     TO admin, checkin_staff;

-- -- ── SearchPassenger ───────────────────────────
-- -- admin: EXEC | checkin: EXEC
-- GRANT EXECUTE ON FUNCTION SearchPassenger(VARCHAR)
--     TO admin, checkin_staff;

-- -- ── StaffLogin ────────────────────────────────
-- -- All roles: EXEC
-- GRANT EXECUTE ON FUNCTION StaffLogin(VARCHAR, TEXT)
--     TO admin, checkin_staff, security_staff, ground_staff;

-- -- ── BookFlight ────────────────────────────────
-- -- admin: EXEC | checkin: EXEC
-- GRANT EXECUTE ON FUNCTION BookFlight(INT,INT,INT,DATE)
--     TO admin, checkin_staff;

-- -- ── CancelBooking ─────────────────────────────
-- -- admin: EXEC | checkin: EXEC
-- GRANT EXECUTE ON PROCEDURE CancelBooking(INT)
--     TO admin, checkin_staff;

-- -- ── GetBookingsByPassenger ────────────────────
-- -- admin: EXEC | checkin: EXEC
-- GRANT EXECUTE ON FUNCTION GetBookingsByPassenger(INT)
--     TO admin, checkin_staff;

-- -- ── SearchBooking ─────────────────────────────
-- -- admin: EXEC | checkin: EXEC
-- GRANT EXECUTE ON FUNCTION SearchBooking(INT,VARCHAR,DATE)
--     TO admin, checkin_staff;

-- -- ── GetBoardingPass ───────────────────────────
-- -- admin: EXEC | checkin: EXEC | security: EXEC
-- GRANT EXECUTE ON FUNCTION GetBoardingPass(INT)
--     TO admin, checkin_staff, security_staff;

-- -- ── AddLuggage ────────────────────────────────
-- -- admin: EXEC | checkin: EXEC
-- GRANT EXECUTE ON PROCEDURE AddLuggage(INT,DECIMAL,VARCHAR)
--     TO admin, checkin_staff;

-- -- ── UpdateLuggageStatus ───────────────────────
-- -- admin: EXEC | security: EXEC
-- GRANT EXECUTE ON FUNCTION UpdateLuggageStatus(INT,VARCHAR)
--     TO admin, security_staff;

-- -- ── SearchLuggage ─────────────────────────────
-- -- admin: EXEC | checkin: EXEC | security: EXEC
-- GRANT EXECUTE ON FUNCTION SearchLuggage(INT,VARCHAR)
--     TO admin, checkin_staff, security_staff;

-- -- ── GetLuggageByBooking ───────────────────────
-- -- admin: EXEC | checkin: EXEC | security: EXEC
-- GRANT EXECUTE ON FUNCTION GetLuggageByBooking(INT)
--     TO admin, checkin_staff, security_staff;

-- -- ── ScheduleFlight ────────────────────────────
-- -- admin: EXEC only
-- GRANT EXECUTE ON PROCEDURE ScheduleFlight(INT,INT,DATE,TIME,TIME,INT,VARCHAR)
--     TO admin;

-- -- ── UpdateFlightStatus ────────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON PROCEDURE UpdateFlightStatus(INT,INT,DATE,VARCHAR)
--     TO admin, ground_staff;

-- -- ── GetFlightsByDate ──────────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION GetFlightsByDate(DATE)
--     TO admin, ground_staff;

-- -- ── SearchScheduledFlight ─────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION SearchScheduledFlight(DATE,VARCHAR,INT)
--     TO admin, ground_staff;

-- -- ── AssignGate ────────────────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION AssignGate(INT,INT,DATE,INT)
--     TO admin, ground_staff;

-- -- ── AssignStaffToFlight ───────────────────────
-- -- admin: EXEC only
-- GRANT EXECUTE ON PROCEDURE AssignStaffToFlight(INT,INT,INT,DATE)
--     TO admin;

-- -- ── SearchStaffFlight ─────────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION SearchStaffFlight(INT,DATE)
--     TO admin, ground_staff;

-- -- ── SearchStaff ───────────────────────────────
-- -- admin: EXEC only
-- GRANT EXECUTE ON FUNCTION SearchStaff(VARCHAR)
--     TO admin;

-- -- ── GetAllAirports ────────────────────────────
-- -- admin: EXEC | checkin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION GetAllAirports()
--     TO admin, checkin_staff, ground_staff;

-- -- ── SearchAirport ─────────────────────────────
-- -- admin: EXEC | checkin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION SearchAirport(VARCHAR)
--     TO admin, checkin_staff, ground_staff;

-- -- ── GetGatesByAirport ─────────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION GetGatesByAirport(INT)
--     TO admin, ground_staff;

-- -- ── UpdateGateStatus ──────────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON PROCEDURE UpdateGateStatus(INT,VARCHAR)
--     TO admin, ground_staff;

-- -- ── GetAllFlights ─────────────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION GetAllFlights()
--     TO admin, ground_staff;

-- -- ── SearchFlight ──────────────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION SearchFlight(VARCHAR)
--     TO admin, ground_staff;

-- -- ── GetRoutesByOrigin ─────────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION GetRoutesByOrigin(INT)
--     TO admin, ground_staff;

-- -- ── SearchRoutes ──────────────────────────────
-- -- admin: EXEC | ground: EXEC
-- GRANT EXECUTE ON FUNCTION SearchRoutes(INT,INT)
--     TO admin, ground_staff;


-- -- ============================================
-- -- SECTION 6: VIEW PRIVILEGES
-- -- ============================================

-- GRANT SELECT ON PassengerBookingSummary  TO admin, checkin_staff;
-- GRANT SELECT ON FlightGateStatus         TO admin, ground_staff;
-- GRANT SELECT ON LuggageSecurityView      TO admin, security_staff;
-- GRANT SELECT ON StaffFlightView          TO admin, ground_staff;
-- GRANT SELECT ON FlightRouteView          TO admin, ground_staff, checkin_staff;
-- GRANT SELECT ON BookingDetailsView       TO admin, checkin_staff;
-- GRANT SELECT ON LuggageSummaryView       TO admin, security_staff;


-- -- ============================================
-- -- SECTION 7: DATABASE LEVEL
-- -- ============================================

-- GRANT CONNECT ON DATABASE "AirportManagementsystem" TO
--     admin, checkin_staff, security_staff, ground_staff;

-- GRANT USAGE ON SCHEMA public TO
--     admin, checkin_staff, security_staff, ground_staff;
