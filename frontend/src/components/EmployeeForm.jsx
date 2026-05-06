import { useState, useEffect } from "react";
import { createEmployee, updateEmployee } from "../services/api";

function EmployeeForm({ selected, refresh }) {
  const [form, setForm] = useState(
    selected || {
      full_name: "",
      job_title: "",
      country: "",
      salary: "",
    }
  );

  useEffect(() => {
    if (selected) {
      setForm(selected);
    }
  }, [selected]);

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (form.id) {
      await updateEmployee(form.id, form);
    } else {
      await createEmployee(form);
    }

    refresh();
    setForm({ full_name: "", job_title: "", country: "", salary: "" });
  };

  return (
    <form onSubmit={handleSubmit}>
      <input name="full_name" placeholder="Full Name" value={form.full_name} onChange={handleChange} />
      <input name="job_title" placeholder="Job Title" value={form.job_title} onChange={handleChange} />
      <input name="country" placeholder="Country" value={form.country} onChange={handleChange} />
      <input name="salary" placeholder="Salary" value={form.salary} onChange={handleChange} />

      <button type="submit">
        {form.id ? "Update" : "Add"} Employee
      </button>
    </form>
  );
}

export default EmployeeForm;