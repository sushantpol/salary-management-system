class EmployeesController < ApplicationController
  before_action :set_employee, only: [ :show, :update, :destroy ]

  def index
    @employees = Employee.all
    render_success(@employees, "Employees Data retrieved successfully")
  end

  def show
    render_success(@employee, "Employee Data retrieved successfully")
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      render_success(@employee, "Employee created successfully", :created)
    else
      render_error(@employee.errors.to_hash, "Validation failed", :unprocessable_entity)
    end
  end

  def update
    if @employee.update(employee_params)
      render_success(@employee, "Employee updated successfully")
    else
      render_error(@employee.errors.to_hash, "Validation failed", :unprocessable_entity)
    end
  end

  def destroy
    @employee.destroy
    render_success(nil, "Employee deleted successfully", :no_content)
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:full_name, :job_title, :country, :salary)
  end

end
