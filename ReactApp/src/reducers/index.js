import {combineReducers} from 'redux';
import employees from './employeeReducer';
import ajaxCallsInProgress from './ajaxStatusReducer';

const rootReducer = combineReducers({
  employees,
  ajaxCallsInProgress
});

export default rootReducer;
