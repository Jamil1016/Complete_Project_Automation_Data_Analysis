-- 1. Departments Table
CREATE TABLE IF NOT EXISTS departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- 2. Employees Table
CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    department_id INT REFERENCES departments(department_id),
    hire_date DATE,
    salary NUMERIC(10,2)
);

-- 3. Projects Table
CREATE TABLE IF NOT EXISTS projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget NUMERIC(12,2),
    department_id INT REFERENCES departments(department_id)
);

-- 4. Timesheets Table
CREATE TABLE IF NOT EXISTS timesheets (
    timesheet_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    project_id INT REFERENCES projects(project_id),
    work_date DATE,
    hours_worked NUMERIC(5,2)
);

-- 5. Automation Logs Table
CREATE TABLE IF NOT EXISTS automation_logs (
    log_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    log_date TIMESTAMP,
    task_name VARCHAR(100),
    status VARCHAR(20),
    details TEXT
);

-- 6. Sales Orders Table
CREATE TABLE IF NOT EXISTS sales_orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE,
    customer_name VARCHAR(100),
    employee_id INT REFERENCES employees(employee_id),
    amount NUMERIC(10,2),
    status VARCHAR(20)
);
