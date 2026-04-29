require 'rails_helper'

RSpec.describe "Employees", type: :request do
  describe "GET /employees" do
    context "when no employees exist" do
      it "returns an empty array" do
        get "/employees", headers: json_headers

        expect(response).to have_http_status(:ok)
        expect(json_success?).to be true
        expect(json_data).to eq([])
      end
    end

    context "when employees exist" do
      let!(:employees) { create_list(:employee, 3) }

      it "returns all employees" do
        get "/employees", headers: json_headers

        expect(response).to have_http_status(:ok)
        expect(json_success?).to be true
        expect(json_data.length).to eq(3)
      end

      it "returns employees with correct attributes" do
        get "/employees", headers: json_headers

        json_data.each do |employee|
          expect(employee).to include(:id, :full_name, :job_title, :country, :salary)
        end
      end
    end
  end

  describe "GET /employees/:id" do
    context "when employee exists" do
      let!(:employee) { create(:employee, full_name: "Jane Smith", job_title: "Developer", country: "India", salary: 80000) }

      it "returns the employee" do
        get "/employees/#{employee.id}", headers: json_headers

        expect(response).to have_http_status(:ok)
        expect(json_success?).to be true
        expect(json_data[:id]).to eq(employee.id)
        expect(json_data[:full_name]).to eq("Jane Smith")
        expect(json_data[:job_title]).to eq("Developer")
        expect(json_data[:country]).to eq("India")
        expect(json_data[:salary]).to eq("80000.0")
      end
    end

    context "when employee does not exist" do
      it "returns not found" do
        get "/employees/999999", headers: json_headers

        expect(response).to have_http_status(:not_found)
        expect(json_success?).to be false
        expect(json_message).to eq("Resource not found")
      end
    end
  end

  describe "POST /employees" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          employee: {
            full_name: "John Doe",
            job_title: "Software Engineer",
            country: "United States",
            salary: 100000
          }
        }
      end

      it "creates a new employee" do
        expect {
          post "/employees", params: valid_params.to_json, headers: json_headers
        }.to change(Employee, :count).by(1)
      end

      it "returns created status" do
        post "/employees", params: valid_params.to_json, headers: json_headers

        expect(response).to have_http_status(:created)
        expect(json_success?).to be true
      end

      it "returns the created employee" do
        post "/employees", params: valid_params.to_json, headers: json_headers

        expect(json_data[:full_name]).to eq("John Doe")
        expect(json_data[:job_title]).to eq("Software Engineer")
        expect(json_data[:country]).to eq("United States")
        expect(json_data[:salary]).to eq("100000.0")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          employee: {
            full_name: "",
            job_title: "",
            country: "",
            salary: nil
          }
        }
      end

      it "does not create an employee" do
        expect {
          post "/employees", params: invalid_params.to_json, headers: json_headers
        }.not_to change(Employee, :count)
      end

      it "returns unprocessable entity status" do
        post "/employees", params: invalid_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_success?).to be false
      end

      it "returns validation errors" do
        post "/employees", params: invalid_params.to_json, headers: json_headers

        expect(json_errors).to be_present
        expect(json_message).to eq("Validation failed")
      end
    end

    context "with negative salary" do
      let(:params_with_negative_salary) do
        {
          employee: {
            full_name: "Test User",
            job_title: "Tester",
            country: "India",
            salary: -500
          }
        }
      end

      it "returns unprocessable entity status" do
        post "/employees", params: params_with_negative_salary.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_errors[:salary]).to include("must be greater than or equal to 0")
      end
    end
  end

  describe "PATCH /employees/:id" do
    let!(:employee) { create(:employee, full_name: "Original Name", salary: 50000) }

    context "with valid parameters" do
      let(:update_params) do
        {
          employee: {
            full_name: "Updated Name",
            salary: 75000
          }
        }
      end

      it "updates the employee" do
        patch "/employees/#{employee.id}", params: update_params.to_json, headers: json_headers

        expect(response).to have_http_status(:ok)
        expect(json_success?).to be true
        expect(json_data[:full_name]).to eq("Updated Name")
        expect(json_data[:salary]).to eq("75000.0")
      end

      it "persists the changes" do
        patch "/employees/#{employee.id}", params: update_params.to_json, headers: json_headers

        employee.reload
        expect(employee.full_name).to eq("Updated Name")
        expect(employee.salary).to eq(75000)
      end
    end

    context "with invalid parameters" do
      let(:invalid_update_params) do
        {
          employee: {
            full_name: "",
            salary: -100
          }
        }
      end

      it "returns unprocessable entity status" do
        patch "/employees/#{employee.id}", params: invalid_update_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_success?).to be false
      end

      it "does not update the employee" do
        patch "/employees/#{employee.id}", params: invalid_update_params.to_json, headers: json_headers

        employee.reload
        expect(employee.full_name).to eq("Original Name")
        expect(employee.salary).to eq(50000)
      end
    end

    context "when employee does not exist" do
      it "returns not found" do
        patch "/employees/999999", params: { employee: { full_name: "Test" } }.to_json, headers: json_headers

        expect(response).to have_http_status(:not_found)
        expect(json_success?).to be false
        expect(json_message).to eq("Resource not found")
      end
    end
  end

  describe "DELETE /employees/:id" do
    let!(:employee) { create(:employee) }

    context "when employee exists" do
      it "deletes the employee" do
        expect {
          delete "/employees/#{employee.id}", headers: json_headers
        }.to change(Employee, :count).by(-1)
      end

      it "returns no content status" do
        delete "/employees/#{employee.id}", headers: json_headers

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when employee does not exist" do
      it "returns not found" do
        delete "/employees/999999", headers: json_headers

        expect(response).to have_http_status(:not_found)
        expect(json_success?).to be false
        expect(json_message).to eq("Resource not found")
      end
    end
  end
end
