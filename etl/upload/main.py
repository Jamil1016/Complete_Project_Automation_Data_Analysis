import etl.upload.upload_csv as upload_csv
import etl.upload.move_csv as move_csv

upload_csv("departments", "datasets/to_upload/departments.csv")
upload_csv("employees", "datasets/to_upload/employees.csv")
upload_csv("projects", "datasets/to_upload/projects.csv")
upload_csv("timesheets", "datasets/to_upload/timesheets.csv")
upload_csv("automation_logs", "datasets/to_upload/automation_logs.csv")
upload_csv("sales_orders", "datasets/to_upload/sales_orders.csv")
