require "rails_helper"

RSpec.describe Employee, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:job_title) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:salary) }

    it { is_expected.to validate_numericality_of(:salary).is_greater_than_or_equal_to(0) }
  end

  describe "attributes" do
    subject(:employee) { build(:employee) }

    it "has a full_name" do
      expect(employee).to respond_to(:full_name)
    end

    it "has a job_title" do
      expect(employee).to respond_to(:job_title)
    end

    it "has a country" do
      expect(employee).to respond_to(:country)
    end

    it "has a salary" do
      expect(employee).to respond_to(:salary)
    end
  end

  describe "valid employee" do
    subject(:employee) { build(:employee) }

    it "is valid with all required attributes" do
      expect(employee).to be_valid
    end
  end

  describe "invalid employee" do
    it "is invalid without a full_name" do
      employee = build(:employee, full_name: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:full_name]).to include("can't be blank")
    end

    it "is invalid without a job_title" do
      employee = build(:employee, job_title: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:job_title]).to include("can't be blank")
    end

    it "is invalid without a country" do
      employee = build(:employee, country: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:country]).to include("can't be blank")
    end

    it "is invalid without a salary" do
      employee = build(:employee, salary: nil)
      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to include("can't be blank")
    end

    it "is invalid with a negative salary" do
      employee = build(:employee, salary: -100)
      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to include("must be greater than or equal to 0")
    end

    it "is invalid with a non-numeric salary" do
      employee = build(:employee, salary: "invalid")
      expect(employee).not_to be_valid
    end
  end

  describe "edge cases" do
    it "is valid with zero salary" do
      employee = build(:employee, salary: 0)
      expect(employee).to be_valid
    end

    it "is valid with decimal salary" do
      employee = build(:employee, salary: 50000.50)
      expect(employee).to be_valid
    end

    it "is valid with large salary values" do
      employee = build(:employee, salary: 10_000_000)
      expect(employee).to be_valid
    end
  end
end
