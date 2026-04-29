class MetricsController < ApplicationController

  def by_country
    metrics = SalaryMetricsService.metrics_by_country(params[:country])
    render_success(metrics, "Country metrics retrieved successfully")
  end

  def by_job_title
    metrics = SalaryMetricsService.metrics_by_job_title(params[:job_title])
    render_success(metrics, "Job title metrics retrieved successfully")
  end

end
