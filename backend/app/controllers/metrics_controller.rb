class MetricsController < ApplicationController

  def by_country
    metrics = SalaryMetricsService.metrics_by_country(params[:country])
    render_success(metrics, "Country metrics retrieved successfully")
  end

  def by_job_title
    if params[:country].present?
      metrics = SalaryMetricsService.metrics_by_job_title_and_country(params[:job_title], params[:country])
    else
      metrics = SalaryMetricsService.metrics_by_job_title(params[:job_title])
    end
    render_success(metrics, "Job title metrics retrieved successfully")
  end

end
