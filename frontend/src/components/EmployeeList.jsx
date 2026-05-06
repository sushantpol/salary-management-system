import { useEffect, useState } from "react";
import { getEmployees, deleteEmployee } from "../services/api";

function EmployeeList({ onEdit }) {
  const [employees, setEmployees] = useState([]);

  const fetchData = async () => {
    const res = await getEmployees();
    setEmployees(res.data);
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleDelete = async (id) => {
    await deleteEmployee(id);
    fetchData();
  };

  return (
    <div>
      <h2>Employees</h2>
      {employees.map((emp) => (
        <div key={emp.id} className="card">
          <p>{emp.full_name} - {emp.job_title} - {emp.country} - ₹{emp.salary}</p>
          <button onClick={() => onEdit(emp)}>Edit</button>
          <button onClick={() => handleDelete(emp.id)}>Delete</button>
        </div>
      ))}
    </div>
  );
}

export default EmployeeList;