import "./App.css";

function App() {
  return (
    <div className="hero">

      {/* Navbar */}
      <div className="navbar">
        <div className="logo">✈️ AMS</div>
        <button className="login-btn">Staff Login</button>
      </div>

      {/* Center Content */}
      <div className="hero-content">
        <h1>Airport Management System</h1>
        <p>Seamless travel. Smart management.</p>

        <div className="actions">
          <button className="primary">Book Ticket</button>
          <button className="secondary">Cancel Ticket</button>
        </div>
      </div>

    </div>
  );
}

export default App;