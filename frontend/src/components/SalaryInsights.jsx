import { useState } from "react";
import { getCountryMetrics, getJobTitleMetrics } from "../services/api";

function SalaryInsights() {
  // Separate states (important)
  const [countryForCountryMetrics, setCountryForCountryMetrics] = useState("");
  const [jobTitle, setJobTitle] = useState("");
  const [countryForJobMetrics, setCountryForJobMetrics] = useState("");

  const [countryData, setCountryData] = useState(null);
  const [jobData, setJobData] = useState(null);

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  // Fetch country metrics
  const fetchCountryData = async () => {
    if (!countryForCountryMetrics) {
      setError("Country is required");
      return;
    }

    try {
      setLoading(true);
      setError("");
      const res = await getCountryMetrics(countryForCountryMetrics);
      setCountryData(res.data);
    } catch (err) {
      setError("Failed to fetch country metrics");
    } finally {
      setLoading(false);
    }
  };

  // Fetch job title metrics (with optional country)
  const fetchJobData = async () => {
    if (!jobTitle) {
      setError("Job title is required");
      return;
    }

    try {
      setLoading(true);
      setError("");
      const res = await getJobTitleMetrics(jobTitle, countryForJobMetrics);
      setJobData(res.data);
    } catch (err) {
      setError("Failed to fetch job metrics");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <h2>Salary Insights</h2>

      {error && <p style={{ color: "red" }}>{error}</p>}
      {loading && <p>Loading...</p>}

      {/* -------- Country Metrics -------- */}
      <div className="section">
        <h3>Country Metrics</h3>

        <input
          placeholder="Enter country"
          value={countryForCountryMetrics}
          onChange={(e) => setCountryForCountryMetrics(e.target.value)}
        />

        <button onClick={fetchCountryData}>
          Get Country Stats
        </button>

        {countryData && (
          <div>
            {countryData.employee_count === 0 ? (
              <p>No data found</p>
            ) : (
              <>
                <p>Country: {countryData.country}</p>
                <p>Min Salary: {countryData.min_salary}</p>
                <p>Max Salary: {countryData.max_salary}</p>
                <p>Avg Salary: {countryData.avg_salary}</p>
                <p>Employees: {countryData.employee_count}</p>
              </>
            )}
          </div>
        )}
      </div>

      <hr />

      {/* -------- Job Title Metrics -------- */}
      <div className="section">
        <h3>Job Title Metrics</h3>

        <input
          placeholder="Enter job title (required)"
          value={jobTitle}
          onChange={(e) => setJobTitle(e.target.value)}
        />

        <input
          placeholder="Enter country (optional)"
          value={countryForJobMetrics}
          onChange={(e) => setCountryForJobMetrics(e.target.value)}
        />

        <button onClick={fetchJobData}>
          Get Job Metrics
        </button>

        {jobData && (
          <div>
            {jobData.employee_count === 0 ? (
              <p>No data found</p>
            ) : (
              <>
                <p>Job Title: {jobData.job_title}</p>
                {jobData.country && <p>Country: {jobData.country}</p>}
                <p>Avg Salary: {jobData.avg_salary}</p>
                <p>Employees: {jobData.employee_count}</p>
              </>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export default SalaryInsights;