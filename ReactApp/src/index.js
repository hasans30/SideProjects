import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import configureStore from './store/configureStore'
import registerServiceWorker from './registerServiceWorker';
import {loadEmployee} from './actions/employeeActions';
import {Provider} from 'react-redux';

//create store
const store = configureStore();
store.dispatch(loadEmployee());

//ReactDOM.render(<App store/>, document.getElementById('root'));
ReactDOM.render(
    <Provider store={store}>
    <App/>
    </Provider>,
    document.getElementById('root')
);
registerServiceWorker();
