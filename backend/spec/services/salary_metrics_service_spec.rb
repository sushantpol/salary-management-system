require "rails_helper"

RSpec.describe SalaryMetricsService do
  describe "#by_country" do
    subject(:result) { described_class.new.by_country(country) }

    context "when employees exist in the country" do
      let(:country) { "India" }

      before do
        create(:employee, country: "India", salary: 50000)
        create(:employee, country: "India", salary: 75000)
        create(:employee, country: "India", salary: 100000)
        create(:employee, country: "United States", salary: 120000)
      end

      it "returns the country name" do
        expect(result[:country]).to eq("India")
      end

      it "returns minimum salary" do
        expect(result[:min_salary]).to eq(50000.0)
      end

      it "returns maximum salary" do
        expect(result[:max_salary]).to eq(100000.0)
      end

      it "returns average salary" do
        expect(result[:avg_salary]).to eq(75000.0)
      end

      it "returns employee count" do
        expect(result[:employee_count]).to eq(3)
      end
    end

    context "when no employees exist in the country" do
      let(:country) { "Australia" }

      before do
        create(:employee, country: "India", salary: 50000)
      end

      it "returns nil values for metrics" do
        expect(result[:country]).to eq("Australia")
        expect(result[:min_salary]).to be_nil
        expect(result[:max_salary]).to be_nil
        expect(result[:avg_salary]).to be_nil
        expect(result[:employee_count]).to eq(0)
      end
    end

    context "with case-insensitive country matching" do
      let(:country) { "india" }

      before do
        create(:employee, country: "India", salary: 60000)
        create(:employee, country: "INDIA", salary: 80000)
      end

      it "matches regardless of case" do
        expect(result[:employee_count]).to eq(2)
        expect(result[:avg_salary]).to eq(70000.0)
      end
    end

    context "with single employee" do
      let(:country) { "Germany" }

      before do
        create(:employee, country: "Germany", salary: 90000)
      end

      it "returns same value for min, max, and avg" do
        expect(result[:min_salary]).to eq(90000.0)
        expect(result[:max_salary]).to eq(90000.0)
        expect(result[:avg_salary]).to eq(90000.0)
        expect(result[:employee_count]).to eq(1)
      end
    end

    context "with decimal salaries" do
      let(:country) { "Canada" }

      before do
        create(:employee, country: "Canada", salary: 75000.50)
        create(:employee, country: "Canada", salary: 82000.25)
      end

      it "handles decimals correctly" do
        expect(result[:min_salary]).to eq(75000.50)
        expect(result[:max_salary]).to eq(82000.25)
        expect(result[:avg_salary]).to be_within(0.01).of(78500.375)
      end
    end
  end

  describe "#by_job_title" do
    subject(:result) { described_class.new.by_job_title(job_title) }

    context "when employees with the job title exist" do
      let(:job_title) { "Software Engineer" }

      before do
        create(:employee, job_title: "Software Engineer", salary: 70000)
        create(:employee, job_title: "Software Engineer", salary: 90000)
        create(:employee, job_title: "Software Engineer", salary: 110000)
        create(:employee, job_title: "Product Manager", salary: 120000)
      end

      it "returns the job title" do
        expect(result[:job_title]).to eq("Software Engineer")
      end

      it "returns average salary" do
        expect(result[:avg_salary]).to eq(90000.0)
      end

      it "returns employee count" do
        expect(result[:employee_count]).to eq(3)
      end
    end

    context "when no employees with the job title exist" do
      let(:job_title) { "Data Scientist" }

      before do
        create(:employee, job_title: "Software Engineer", salary: 70000)
      end

      it "returns nil for average and zero count" do
        expect(result[:job_title]).to eq("Data Scientist")
        expect(result[:avg_salary]).to be_nil
        expect(result[:employee_count]).to eq(0)
      end
    end

    context "with case-insensitive job title matching" do
      let(:job_title) { "software engineer" }

      before do
        create(:employee, job_title: "Software Engineer", salary: 80000)
        create(:employee, job_title: "SOFTWARE ENGINEER", salary: 100000)
      end

      it "matches regardless of case" do
        expect(result[:employee_count]).to eq(2)
        expect(result[:avg_salary]).to eq(90000.0)
      end
    end

    context "with single employee" do
      let(:job_title) { "CTO" }

      before do
        create(:employee, job_title: "CTO", salary: 250000)
      end

      it "returns the salary as average" do
        expect(result[:avg_salary]).to eq(250000.0)
        expect(result[:employee_count]).to eq(1)
      end
    end
  end

  describe "class methods" do
    describe ".metrics_by_country" do
      it "provides a class method shortcut" do
        create(:employee, country: "India", salary: 50000)
        result = described_class.metrics_by_country("India")
        expect(result[:avg_salary]).to eq(50000.0)
      end
    end

    describe ".metrics_by_job_title" do
      it "provides a class method shortcut" do
        create(:employee, job_title: "Designer", salary: 60000)
        result = described_class.metrics_by_job_title("Designer")
        expect(result[:avg_salary]).to eq(60000.0)
      end
    end
  end
end
