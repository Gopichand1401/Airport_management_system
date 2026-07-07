// ============================================
// Airport Management System - Backend Server
// Express + PostgreSQL
// ============================================

const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// ── DB Connection ─────────────────────────────
// Update these with your PostgreSQL credentials
const pool = new Pool({
    host:     process.env.DB_HOST     || 'localhost',
    port:     process.env.DB_PORT     || 5432,
    database: process.env.DB_NAME     || 'AirportManagementsystem',
    user:     process.env.DB_USER     || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
});

// Helper
const query = (text, params) => pool.query(text, params);

// ── Auth ──────────────────────────────────────
app.post('/api/login', async (req, res) => {
    const { username, password_hash } = req.body;
    try {
        const result = await query(
            `SELECT * FROM StaffLogin($1, $2)`,
            [username, password_hash]
        );
        if (result.rows.length === 0)
            return res.status(401).json({ error: 'Invalid credentials' });
        res.json(result.rows[0]);
    } catch (err) {
        res.status(401).json({ error: err.message });
    }
});

// ── Passengers ────────────────────────────────
app.get('/api/passengers/search', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM SearchPassenger($1)`, [req.query.q || '']);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/passengers/:id', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM GetPassengerByID($1)`, [req.params.id]);
        res.json(result.rows[0] || null);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/passengers/register', async (req, res) => {
    const { name, email, phone, passport } = req.body;
    try {
        await query(`CALL RegisterPassenger($1,$2,$3,$4)`, [name, email, phone, passport]);
        res.json({ success: true, message: 'Passenger registered successfully' });
    } catch (err) { res.status(400).json({ error: err.message }); }
});

app.put('/api/passengers/:id', async (req, res) => {
    const { name, email, phone, passport } = req.body;
    try {
        await query(`CALL UpdatePassenger($1,$2,$3,$4,$5)`,
            [req.params.id, name, email, phone, passport]);
        res.json({ success: true, message: 'Passenger updated successfully' });
    } catch (err) { res.status(400).json({ error: err.message }); }
});

// ── Flights ───────────────────────────────────
app.get('/api/flights', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM GetAllFlights()`);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/flights/search', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM SearchFlight($1)`, [req.query.q || '']);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/flights/by-date', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM GetFlightsByDate($1)`, [req.query.date]);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/flights/scheduled', async (req, res) => {
    const { date, status, route } = req.query;
    try {
        const result = await query(
            `SELECT * FROM SearchScheduledFlight($1,$2,$3)`,
            [date || null, status || null, route || null]
        );
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/flights/route-view', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM FlightRouteView ORDER BY flight_date, departure_time`);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/flights/schedule', async (req, res) => {
    const { route_id, flight_id, flight_date, departure, arrival, gate_id, status } = req.body;
    try {
        await query(`CALL ScheduleFlight($1,$2,$3,$4,$5,$6,$7)`,
            [route_id, flight_id, flight_date, departure, arrival, gate_id, status]);
        res.json({ success: true, message: 'Flight scheduled successfully' });
    } catch (err) { res.status(400).json({ error: err.message }); }
});

app.put('/api/flights/status', async (req, res) => {
    const { route_id, flight_id, flight_date, status } = req.body;
    try {
        await query(`CALL UpdateFlightStatus($1,$2,$3,$4)`,
            [route_id, flight_id, flight_date, status]);
        res.json({ success: true, message: 'Flight status updated' });
    } catch (err) { res.status(400).json({ error: err.message }); }
});

// ── Bookings ──────────────────────────────────
app.get('/api/bookings/passenger/:id', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM GetBookingsByPassenger($1)`, [req.params.id]);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/bookings/search', async (req, res) => {
    const { passenger_id, status, date } = req.query;
    try {
        const result = await query(`SELECT * FROM SearchBooking($1,$2,$3)`,
            [passenger_id || null, status || null, date || null]);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/bookings/details', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM BookingDetailsView ORDER BY booking_date DESC`);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/bookings', async (req, res) => {
    const { passenger_id, route_id, flight_id, flight_date } = req.body;
    try {
        const result = await query(`SELECT BookFlight($1,$2,$3,$4) AS booking_id`,
            [passenger_id, route_id, flight_id, flight_date]);
        res.json({ success: true, booking_id: result.rows[0].booking_id });
    } catch (err) { res.status(400).json({ error: err.message }); }
});

app.put('/api/bookings/:id/cancel', async (req, res) => {
    try {
        await query(`CALL CancelBooking($1)`, [req.params.id]);
        res.json({ success: true, message: 'Booking cancelled successfully' });
    } catch (err) { res.status(400).json({ error: err.message }); }
});

// ── Boarding Pass ─────────────────────────────
app.get('/api/boarding-pass/:booking_id', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM GetBoardingPass($1)`, [req.params.booking_id]);
        res.json(result.rows[0] || null);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Luggage ───────────────────────────────────
app.get('/api/luggage/booking/:id', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM GetLuggageByBooking($1)`, [req.params.id]);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/luggage/search', async (req, res) => {
    const { booking_id, status } = req.query;
    try {
        const result = await query(`SELECT * FROM SearchLuggage($1,$2)`,
            [booking_id || null, status || null]);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/luggage/summary', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM LuggageSummaryView ORDER BY flight_date DESC`);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/luggage', async (req, res) => {
    const { booking_id, weight, status } = req.body;
    try {
        await query(`CALL AddLuggage($1,$2,$3)`, [booking_id, weight, status]);
        res.json({ success: true, message: 'Luggage added successfully' });
    } catch (err) { res.status(400).json({ error: err.message }); }
});

app.put('/api/luggage/:id/status', async (req, res) => {
    try {
        await query(`SELECT UpdateLuggageStatus($1,$2)`, [req.params.id, req.body.status]);
        res.json({ success: true, message: 'Luggage status updated' });
    } catch (err) { res.status(400).json({ error: err.message }); }
});

// ── Gates ─────────────────────────────────────
app.get('/api/gates/airport/:id', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM GetGatesByAirport($1)`, [req.params.id]);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/gates/search', async (req, res) => {
    const { airport_id, status } = req.query;
    try {
        const result = await query(`SELECT * FROM SearchGate($1,$2)`,
            [airport_id || null, status || null]);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/gates/status-view', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM FlightGateStatus`);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.put('/api/gates/:id/status', async (req, res) => {
    try {
        await query(`CALL UpdateGateStatus($1,$2)`, [req.params.id, req.body.status]);
        res.json({ success: true, message: 'Gate status updated' });
    } catch (err) { res.status(400).json({ error: err.message }); }
});

// ── Airports ──────────────────────────────────
app.get('/api/airports', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM GetAllAirports()`);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/airports/search', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM SearchAirport($1)`, [req.query.q || '']);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Routes ────────────────────────────────────
app.get('/api/routes/search', async (req, res) => {
    const { origin, destination } = req.query;
    try {
        const result = await query(`SELECT * FROM SearchRoutes($1,$2)`, [origin, destination]);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/routes/origin/:id', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM GetRoutesByOrigin($1)`, [req.params.id]);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

// ── Staff ─────────────────────────────────────
app.get('/api/staff/search', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM SearchStaff($1)`, [req.query.q || '']);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/staff/flights', async (req, res) => {
    const { staff_id, date } = req.query;
    try {
        const result = await query(`SELECT * FROM SearchStaffFlight($1,$2)`,
            [staff_id || null, date || null]);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/staff/flight-view', async (req, res) => {
    try {
        const result = await query(`SELECT * FROM StaffFlightView ORDER BY flight_date DESC`);
        res.json(result.rows);
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.post('/api/staff/assign', async (req, res) => {
    const { staff_id, route_id, flight_id, flight_date } = req.body;
    try {
        await query(`CALL AssignStaffToFlight($1,$2,$3,$4)`,
            [staff_id, route_id, flight_id, flight_date]);
        res.json({ success: true, message: 'Staff assigned successfully' });
    } catch (err) { res.status(400).json({ error: err.message }); }
});

// ── Start ─────────────────────────────────────
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`\n✈  Airport Management System`);
    console.log(`   Server running at http://localhost:${PORT}\n`);
});
