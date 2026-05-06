class SalaryMetricsService
  def by_country(country)
    employees = Employee.where("LOWER(country) = ?", country.downcase)

    {
      country: country,
      min_salary: employees.minimum(:salary)&.to_f&.round(2),
      max_salary: employees.maximum(:salary)&.to_f&.round(2),
      avg_salary: employees.average(:salary)&.to_f&.round(2),
      employee_count: employees.count
    }
  end

  def by_job_title(job_title)
    employees = Employee.where("LOWER(job_title) = ?", job_title.downcase)

    {
      job_title: job_title,
      avg_salary: employees.average(:salary)&.to_f&.round(2),
      employee_count: employees.count
    }
  end

  def by_job_title_and_country(job_title, country)
    employees = Employee.where(
      "LOWER(job_title) = ? AND LOWER(country) = ?",
      job_title.downcase,
      country.downcase
    )

    {
      job_title: job_title,
      country: country,
      avg_salary: employees.average(:salary)&.to_f&.round(2),
      employee_count: employees.count
    }
  end

  def self.metrics_by_country(country)
    new.by_country(country)
  end

  def self.metrics_by_job_title(job_title)
    new.by_job_title(job_title)
  end

  def self.metrics_by_job_title_and_country(job_title, country)
    new.by_job_title_and_country(job_title, country)
  end
end
