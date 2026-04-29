Rails.application.routes.draw do
  resources :employees

  get "metrics/country/:country", to: "metrics#by_country", as: :metrics_by_country
  get "metrics/job_title/:job_title", to: "metrics#by_job_title", as: :metrics_by_job_title

  get "up" => "rails/health#show", as: :rails_health_check
end
