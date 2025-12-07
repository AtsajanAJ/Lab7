import React, { useState, useEffect } from 'react';
import './App.css';

// Production: Use relative path (API Gateway handles routing)
// Development: Use full URL
const API_URL = process.env.REACT_APP_API_URL || (process.env.NODE_ENV === 'production' ? '/api' : 'http://localhost:3002');

function App() {
  const [count, setCount] = useState(0);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');

  useEffect(() => {
    // Load initial count (optional)
    setMessage('Ready to click! Each click increments by 2 (via Plugin)');
  }, []);

  const handleClick = async () => {
    setLoading(true);
    setMessage('Processing...');

    try {
      const response = await fetch(`${API_URL}${API_URL.startsWith('/') ? '' : '/api'}/click`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          currentCount: count,
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to process click');
      }

      const data = await response.json();
      setCount(data.newCount);
      setMessage(`✅ Click processed! Count: ${data.newCount} (incremented by 2 via Plugin)`);
    } catch (error) {
      console.error('Error:', error);
      setMessage(`❌ Error: ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleReset = () => {
    setCount(0);
    setMessage('Counter reset!');
  };

  return (
    <div className="App">
      <div className="container">
        <h1>Clicker App</h1>
        <p className="subtitle">Microkernel Architecture Pattern</p>
        
        <div className="counter-display">
          <div className="counter-value">{count}</div>
          <p className="counter-label">Current Count</p>
        </div>

        <div className="button-group">
          <button 
            className="click-button" 
            onClick={handleClick}
            disabled={loading}
          >
            {loading ? 'Processing...' : 'Click Me!'}
          </button>
          <button 
            className="reset-button" 
            onClick={handleReset}
            disabled={loading}
          >
            Reset
          </button>
        </div>

        <div className="message-box">
          <p>{message}</p>
        </div>

        <div className="info-box">
          <h3>Architecture Flow:</h3>
          <p>Frontend (React) → Backend (Express) → Plugin (gRPC)</p>
          <p className="plugin-info">✨ Plugin Logic: Increment by 2 (not 1)</p>
        </div>
      </div>
    </div>
  );
}

export default App;

