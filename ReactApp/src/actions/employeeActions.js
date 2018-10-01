import * as types from './actionTypes'
import employeeApi from '../api/mockEmployees'
import {beginAjaxCall, ajaxCallError} from './ajaxStatusActions';

export function loadEmployee() {
    return function(dispatch) {
      dispatch(beginAjaxCall());
      return employeeApi.getAllEmployees().then(courses => {
        dispatch(loadEmployeesSuccess(courses));
      }).catch(error => {
        throw(error);
      });
    };
  }

  export function loadEmployeesSuccess(employees) {
    console.log('successfully loaded employees');
    console.log(employees);
  return { type: types.LOAD_EMPLOYEES_SUCCESS, employees};
}
