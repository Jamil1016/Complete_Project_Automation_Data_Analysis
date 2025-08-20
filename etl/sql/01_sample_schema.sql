-- 01_schema.sql
CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    region VARCHAR(50),
    join_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS process_tickets (
    ticket_id SERIAL PRIMARY KEY,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    owner_team VARCHAR(50),
    status VARCHAR(20) CHECK (status IN ('Pending','In Progress','Completed','Failed')),
    sla_hours INT,
    priority VARCHAR(10) CHECK (priority IN ('Low','Medium','High')),
    error_flag BOOLEAN DEFAULT FALSE,
    customer_id INT REFERENCES customers(customer_id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);