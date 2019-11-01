// authentication tutorial from  https://dzone.com/articles/add-user-authentication-to-your-react-app
import React, { useState, useEffect } from 'react';
import logo from './chuuuck-norris.png';
import { decode } from 'he';
import './App.css';

function App() {
  const [joke, setJoke] = useState('');
  const fetchJoke = async signal => {
    const url = new URL('https://api.icndb.com/jokes/random');
    const response = await fetch(url, { signal });
    const { value } = await response.json();
    setJoke(decode(value.joke));

  };

  useEffect(() => {
    if (!joke) {
      const controller = new AbortController();
      fetchJoke(controller.signal);
      return () => controller.abort();
    }
  }, [joke]);
  return (
       <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>{joke || '...'}</p>
        <button className="App-link" onClick={() => setJoke('')}>
          Get a new joke
        </button>
      </header>
    </div> 
  );
}

export default App;
