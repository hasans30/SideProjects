import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import EmployeesPage from './components/EmployeesPage'
import {BrowserRouter ,Route} from 'react-router-dom'
import EmployeeForm from './components/EmployeeForm';

class App extends Component {
  render() {
    return (
      <BrowserRouter>
      <div className="App">
      <Route path="/" exact component={EmployeesPage} />
      <Route path="/new" exact component={EmployeeForm} />
      </div>
      </BrowserRouter>
    );
  }
}

export default App;
