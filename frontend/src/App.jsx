import { useRef, useState } from "react";
import EmployeeList from "./components/EmployeeList";
import EmployeeForm from "./components/EmployeeForm";
import SalaryInsights from "./components/SalaryInsights";
import "./style.css";

function App() {
  const [selected, setSelected] = useState(null);
  const formRef = useRef(null);

  const handleEdit = (employee) => {
    setSelected(employee);

    // scroll to form
    formRef.current?.scrollIntoView({
      behavior: "smooth",
      block: "start",
    });
  };

  return (
    <div className="container">
      <h1>Employee Manager</h1>

      <div ref={formRef}>
        <EmployeeForm selected={selected} setSelected={setSelected} />
      </div>

      <EmployeeList onEdit={handleEdit} />

      <SalaryInsights />
    </div>
  );
}

export default App;