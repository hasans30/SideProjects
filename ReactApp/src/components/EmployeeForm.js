import React from 'react';
import TextInput from './TextInput';
import SelectInput from './SelectInput';

const EmployeeForm = ({employee, allAuthors, onSave, onChange, saving, errors}) => {
  return (
    <form>
      <h1>Manage Employee</h1>
      <TextInput
        name="name"
        label="Name"
        value={employee.name}
        onChange={onChange}
        error={errors.title}/>
      <TextInput
        name="Address"
        label="Address"
        value={employee.Address}
        onChange={onChange}
        error={errors.category}/>

      <TextInput
        name="phone"
        label="Phone"
        value={employee.phone}
        onChange={onChange}
        error={errors.length}/>

      <input
        type="submit"
        disabled={saving}
        value={saving ? 'Saving...' : 'Save'}
        className="btn btn-primary"
        onClick={onSave}/>
    </form>
  );
};


export default EmployeeForm;
