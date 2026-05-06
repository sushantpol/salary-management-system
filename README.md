# Salary Management System

A Ruby on Rails application for managing employee salaries with country-specific metrics with reactjs frontend.

## Tech Stack

- **Ruby**: 3.3.6
- **Rails**: 8.0.2 (API-only mode)
- **Database**: Postgresql
- **Testing**: RSpec, FactoryBot, Shoulda Matchers

### Prerequisites

- Ruby 3.3.6
- Bundler

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd salary-management-system

# Install dependencies
bundle install

# Setup database
bin/rails db:create db:migrate

# Run the server
bin/rails server
```

The API will be available at `http://localhost:3000`

## Running Tests

```bash
# Run all tests
bundle exec rspec

# Run with documentation format
bundle exec rspec --format documentation

# Run specific test files
bundle exec rspec spec/models/
bundle exec rspec spec/requests/
bundle exec rspec spec/services/
```

## API Response Format

All API responses follow a consistent format using the `ApiResponseHandler` concern:

### Success Response
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error description",
  "errors": { ... }
}
```

### HTTP Status Codes

| Status | Description |
|--------|-------------|
| 200 | Success |
| 201 | Created |
| 204 | No Content (Delete) |
| 400 | Bad Request |
| 404 | Not Found |
| 422 | Unprocessable Entity |
| 500 | Internal Server Error |

## API Endpoints

### Employee CRUD

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/employees` | List all employees |
| GET | `/employees/:id` | Get a specific employee |
| POST | `/employees` | Create a new employee |
| PATCH | `/employees/:id` | Update an employee |
| DELETE | `/employees/:id` | Delete an employee |

#### Employee Attributes

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| full_name | string | Yes | Must be present |
| job_title | string | Yes | Must be present |
| country | string | Yes | Must be present |
| salary | decimal | Yes | Must be >= 0 |

#### Example Requests

**Create Employee:**
```bash
curl -X POST http://localhost:3000/employees \
  -H "Content-Type: application/json" \
  -d '{"employee": {"full_name": "Smith Will", "job_title": "Software Engineer", "country": "India", "salary": 75000}}'
```

**Response:**
```json
{
  "success": true,
  "message": "Employee created successfully",
  "data": {
    "id": 1,
    "full_name": "Smith Will",
    "job_title": "Software Engineer",
    "country": "India",
    "salary": "75000.0",
    "created_at": "2024-01-08T10:00:00.000Z",
    "updated_at": "2024-01-08T10:00:00.000Z"
  }
}
```

**Error Response (Validation Failed):**
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "full_name": ["can't be blank"],
    "salary": ["must be greater than or equal to 0"]
  }
}
```



### Salary Metrics

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/metrics/country/:country` | Salary statistics by country |
| GET | `/metrics/job_title/:job_title` | Average salary by job title |
| GET | `/metrics/job_title/:job_title?country=:country` | Average salary by job title in specific country |

#### Example Requests

**By Country:**
```bash
curl "http://localhost:3000/metrics/country/India"
```

**Response:**
```json
{
  "success": true,
  "message": "Country metrics retrieved successfully",
  "data": {
    "country": "India",
    "min_salary": 50000.0,
    "max_salary": 100000.0,
    "avg_salary": 75000.0,
    "employee_count": 3
  }
}
```

**By Job Title:**
```bash
curl "http://localhost:3000/metrics/job_title/Software%20Engineer"
```

**Response:**
```json
{
  "success": true,
  "message": "Job title metrics retrieved successfully",
  "data": {
    "job_title": "Software Engineer",
    "avg_salary": 85000.0,
    "employee_count": 5
  }
}
```

## Project Structure

```
app/
├── controllers/
│   ├── concerns/
│   │   ├── api_response_handler.rb
│   │   └── api_exception_handler.rb
│   ├── application_controller.rb
│   ├── employees_controller.rb
│   └── metrics_controller.rb
├── models/
│   └── employee.rb
└── services/
    └── salary_metrics_service.rb

spec/
├── factories/
│   └── employees.rb
├── models/
│   └── employee_spec.rb
├── requests/
│   ├── employees_spec.rb
│   ├── metrics_spec.rb
├── services/
│   └── salary_metrics_service_spec.rb
└── support/
    └── request_helpers.rb
```

## Design Decisions

### Architecture

- **API-only Rails application**: Lightweight, focused on JSON responses
- **Service Objects**: Business logic encapsulated in dedicated service classes
- **Database**: postgresql

### SOLID Principles Applied

1. **Single Responsibility**:
   - Each service handles one specific domain (salary calculation vs metrics)
   - Concerns separate response handling from business logic
2. **Open/Closed**: Tax rules are defined in a hash constant, making it easy to add new countries without modifying the calculation logic
3. **Dependency Inversion**: Controllers depend on service abstractions, not concrete implementations
4. **Interface Segregation**: Small, focused concern modules rather than large base classes

### Exception Handling


| Exception | HTTP Status | Message |
|-----------|-------------|---------|
| `ActiveRecord::RecordNotFound` | 404 | Resource not found |
| `ActiveRecord::RecordInvalid` | 422 | Validation failed |
| `ActionController::ParameterMissing` | 400 | Bad request |
| `ArgumentError` | 422 | Invalid argument |
| `StandardError` | 500 | Internal server error |