#!/usr/bin/python3
"""J. Hutcheson | Retrieving table data with SQLite"""

import sqlite3

# Create a connection to the SQLite database
conn = sqlite3.connect('my_database.db')

# Create a cursor object to execute SQL commands
c = conn.cursor()

# Execute the SQL query to find the product associated with "XYZ Corp"
c.execute('''SELECT products.name
             FROM products
             INNER JOIN companies ON products.company_id = companies.id
             WHERE companies.name = 'XYZ Corp';''')

# Fetch the results of the query
result = c.fetchone()

# Print the result
# print(result)
print(result[0]) # out results are returned to us in a tuple, uncomment out the above line if you'd like to see that.

# Close the database connection
conn.close()
