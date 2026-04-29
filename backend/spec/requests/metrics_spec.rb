require 'rails_helper'

RSpec.describe "Metrics", type: :request do
  describe "GET /metrics/country/:country" do
    context "when employees exist in the country" do
      before do
        create(:employee, country: "India", salary: 50000)
        create(:employee, country: "India", salary: 75000)
        create(:employee, country: "India", salary: 100000)
      end

      it "returns success status" do
        get "/metrics/country/India", headers: json_headers

        expect(response).to have_http_status(:ok)
        expect(json_success?).to be true
      end

      it "returns country name" do
        get "/metrics/country/India", headers: json_headers

        expect(json_data[:country]).to eq("India")
      end

      it "returns minimum salary" do
        get "/metrics/country/India", headers: json_headers

        expect(json_data[:min_salary]).to eq(50000.0)
      end

      it "returns maximum salary" do
        get "/metrics/country/India", headers: json_headers

        expect(json_data[:max_salary]).to eq(100000.0)
      end

      it "returns average salary" do
        get "/metrics/country/India", headers: json_headers

        expect(json_data[:avg_salary]).to eq(75000.0)
      end

      it "returns employee count" do
        get "/metrics/country/India", headers: json_headers

        expect(json_data[:employee_count]).to eq(3)
      end
    end

    context "when no employees exist in the country" do
      it "returns empty metrics" do
        get "/metrics/country/Australia", headers: json_headers

        expect(response).to have_http_status(:ok)
        expect(json_success?).to be true
        expect(json_data[:country]).to eq("Australia")
        expect(json_data[:min_salary]).to be_nil
        expect(json_data[:max_salary]).to be_nil
        expect(json_data[:avg_salary]).to be_nil
        expect(json_data[:employee_count]).to eq(0)
      end
    end

    context "with URL-encoded country names" do
      before do
        create(:employee, country: "United States", salary: 120000)
      end

      it "handles spaces in country names" do
        get "/metrics/country/United%20States", headers: json_headers

        expect(response).to have_http_status(:ok)
        expect(json_data[:country]).to eq("United States")
        expect(json_data[:employee_count]).to eq(1)
      end
    end
  end

  describe "GET /metrics/job_title/:job_title" do
    context "when employees with the job title exist" do
      before do
        create(:employee, job_title: "Software Engineer", salary: 70000)
        create(:employee, job_title: "Software Engineer", salary: 90000)
        create(:employee, job_title: "Software Engineer", salary: 110000)
      end

      it "returns success status" do
        get "/metrics/job_title/Software%20Engineer", headers: json_headers

        expect(response).to have_http_status(:ok)
        expect(json_success?).to be true
      end

      it "returns job title" do
        get "/metrics/job_title/Software%20Engineer", headers: json_headers

        expect(json_data[:job_title]).to eq("Software Engineer")
      end

      it "returns average salary" do
        get "/metrics/job_title/Software%20Engineer", headers: json_headers

        expect(json_data[:avg_salary]).to eq(90000.0)
      end

      it "returns employee count" do
        get "/metrics/job_title/Software%20Engineer", headers: json_headers

        expect(json_data[:employee_count]).to eq(3)
      end
    end

    context "when no employees with the job title exist" do
      it "returns empty metrics" do
        get "/metrics/job_title/Data%20Scientist", headers: json_headers

        expect(response).to have_http_status(:ok)
        expect(json_success?).to be true
        expect(json_data[:job_title]).to eq("Data Scientist")
        expect(json_data[:avg_salary]).to be_nil
        expect(json_data[:employee_count]).to eq(0)
      end
    end

    context "with different job titles" do
      before do
        create(:employee, job_title: "Product Manager", salary: 95000)
        create(:employee, job_title: "Product Manager", salary: 115000)
        create(:employee, job_title: "Designer", salary: 75000)
      end

      it "returns metrics for specific job title only" do
        get "/metrics/job_title/Product%20Manager", headers: json_headers

        expect(json_data[:job_title]).to eq("Product Manager")
        expect(json_data[:avg_salary]).to eq(105000.0)
        expect(json_data[:employee_count]).to eq(2)
      end
    end
  end
end
