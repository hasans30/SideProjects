import React  from 'react';
import * as employeeActions from '../actions/employeeActions';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux'

class EmployeesPage extends React.Component 
{

    render()
    {
        const {emps}=this.props;
        console.log('emps##')
        console.log(emps);
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
          </tbody>
          </table>
            </div>
        );
    }
}
//export default EmployeesPage;

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