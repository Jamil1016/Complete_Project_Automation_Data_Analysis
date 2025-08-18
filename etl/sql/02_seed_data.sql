-- 02_seed_data.sql
INSERT INTO customers (customer_name, region, join_date) VALUES
('Acme Corp', 'APAC', '2023-01-15'),
('Beta Ltd', 'US', '2023-02-10'),
('Gamma LLC', 'EMEA', '2023-03-05'),
('Delta Inc', 'APAC', '2023-04-20'),
('Omega Partners', 'US', '2023-05-30')
ON CONFLICT DO NOTHING;

INSERT INTO process_tickets (created_at, completed_at, owner_team, status, sla_hours, priority, error_flag, customer_id, updated_at) VALUES
('2024-07-01 08:15:00','2024-07-01 12:30:00','Ops','Completed',8,'High',FALSE,1,'2024-07-01 12:30:00'),
('2024-07-02 09:00:00',NULL,'QA','Pending',24,'Medium',FALSE,2,'2024-07-02 09:00:00'),
('2024-07-03 10:30:00','2024-07-03 18:00:00','Support','Completed',12,'Low',TRUE,3,'2024-07-03 18:00:00'),
('2024-07-04 11:00:00','2024-07-04 15:45:00','Ops','Completed',6,'High',FALSE,4,'2024-07-04 15:45:00'),
('2024-07-05 13:00:00','2024-07-05 20:00:00','QA','Failed',10,'High',TRUE,5,'2024-07-05 20:00:00');