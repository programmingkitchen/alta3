import sqlite3

# Connect to the database
conn = sqlite3.connect('my_database2.db')

# Create a cursor object to execute SQL commands
c = conn.cursor()

# Query all products that XYZ Corp provides
c.execute('''
          SELECT name
          FROM products
          WHERE company_id = (
              SELECT id
              FROM companies
              WHERE name = 'XYZ Corp.'
          )
          ''')

# Fetch the results and print them
results = c.fetchall()
for row in results:
    print(row[0])

# Close the connection
conn.close()
