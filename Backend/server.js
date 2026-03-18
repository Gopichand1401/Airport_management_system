const express = require('express');
const cors = require('cors');   // ✅ ADD THIS
const app = express();
const pool = require('./db');

app.use(cors());                // ✅ ADD THIS

app.get('/', (req, res) => {
  res.send('Backend is working');
});

// NEW ROUTE
app.get('/flights', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM flights');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error fetching data');
  }
});

app.listen(5000, () => {
  console.log('Server running on port 5000');
});