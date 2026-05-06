const BASE_URL = "http://localhost:3000"; // your Rails API

export const getEmployees = async () => {
  const res = await fetch(`${BASE_URL}/employees`);
  return res.json();
};

export const createEmployee = async (data) => {
  const res = await fetch(`${BASE_URL}/employees`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  return res.json();
};

export const updateEmployee = async (id, data) => {
  const res = await fetch(`${BASE_URL}/employees/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  return res.json();
};

export const deleteEmployee = async (id) => {
  await fetch(`${BASE_URL}/employees/${id}`, {
    method: "DELETE",
  });
};


export const getCountryMetrics = async (country) => {
  const res = await fetch(`${BASE_URL}/metrics/country/${country}`);
  return res.json();
};

export const getJobTitleMetrics = async (jobTitle, country) => {
  let url = `${BASE_URL}/metrics/job_title/${encodeURIComponent(jobTitle)}`;

  if (country) {
    url += `?country=${encodeURIComponent(country)}`;
  }

  const res = await fetch(url);
  return res.json();
};