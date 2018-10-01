import React  from 'react';
import * as employeeActions from '../actions/employeeActions';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux'

class EmployeesPage extends React.Component 
{
    render()
    {
        const emps=this.props.employees; //this is how you access the store data. note that we got the props.employee as we set in mapStateToProps
        return (
            <div>
                <h1> hello </h1>
                <table className="table">
      <thead>
      <tr>
        <th>&nbsp;</th>
        <th>Name</th>
        <th>Address</th>
        <th>Phone</th>
        <th>Dept.</th>
      </tr>
      </thead>
      <tbody>
       { emps.map(emp =>
        <tr key={emp.name}>
          <td>{emp.name}</td>
          <td>{emp.Address}</td>
          <td>{emp.Phone}</td>
          <td>{emp.department}</td>
        </tr>
        ) }
        </tbody>
          </table>
            </div>
        );
    }
}

function mapStateToProps(state, ownProps) {
    return {
      employees : state.employees
    };
  }
  
  function mapDispatchToProps(dispatch) {
    return {
      actions: bindActionCreators(employeeActions, dispatch)
    };
  }
  
  export default connect(mapStateToProps, mapDispatchToProps)(EmployeesPage);