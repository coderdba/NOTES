#
# PACKAGES NEEDED:
# pip install pyodbc
#

import pyodbc

from dotenv import load_dotenv
import os
import timeit
import time

print("INFO - Getting environment")
load_dotenv()

your_server_name = os.getenv("SQL_SERVER_SERVER_NAME")
your_database_name = os.getenv("SQL_SERVER_DATABASE_NAME")
your_username = os.getenv("SQL_SERVER_USERNAME")
your_password = os.getenv("SQL_SERVER_PASSWORD")

# Define the connection string
print("INFO - Defining the connection string")
conn_str = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={your_server_name};DATABASE={your_database_name};UID={your_username};PWD={your_password}'
#print("Connection string is: ", conn_str)

'''
conn_str = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=your_server_name;"
    "DATABASE=your_database_name;"
    "UID=your_username;"
    "PWD=your_password"
)
'''

# Establish the connection
print("INFO - Establishing the connection")
conn = pyodbc.connect(conn_str)

# Create a cursor object
print("INFO - Creating the cursor object")
cursor = conn.cursor()

# Define your SQL query
print("INFO - Define the query")
#sql_query = "SELECT * FROM your_table_name"

sql_query = """select
            a, b
            from table_name1;
"""


# Execute the SQL query
print("INFO - Execute the query")
cursor.execute(sql_query)

# Fetch all results
print("INFO - Fetch results from cursor")
start_time = time.time()
rows = cursor.fetchall()
end_time = time.time()
execution_time = end_time - start_time
print(f"INFO - Execution time: {execution_time} seconds")
print("INFO - Type of rows variable: ", type(rows))
print("INFO - Number of rows: ", len(rows))

# Print the results
'''

print("INFO - Print results")
for row in rows:
    print(row, "\n")

print("\nINFO - Total rows: ", len(rows), "\n")
'''

# Close the cursor and connection
print("INFO - Close cursor")
cursor.close()

print("INFO - Close connection")
conn.close()

print("INFO - Exiting\n")
