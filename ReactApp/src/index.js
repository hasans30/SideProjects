import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import configureStore from './store/configureStore'
import registerServiceWorker from './registerServiceWorker';
import {loadEmployee} from './actions/employeeActions';

//create store
const store = configureStore();
debugger;
store.dispatch(loadEmployee());

ReactDOM.render(<App />, document.getElementById('root'));
registerServiceWorker();
