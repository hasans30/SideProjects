import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import EmployeesPage from './components/EmployeesPage'

class App extends Component {
  render() {
    return (
      <div className="App">
       <EmployeesPage/> 
      </div>
    );
  }
}

export default App;
