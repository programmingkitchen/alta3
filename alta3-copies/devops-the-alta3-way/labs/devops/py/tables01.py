#!/usr/bin/python3
"""J. Hutcheson | creating tables in SQLite"""

import sqlite3

# Create a connection to a new SQLite database
conn = sqlite3.connect('my_database.db')

# Create a cursor object to execute SQL commands
c = conn.cursor()

# Create the companies table with columns for Company ID and Company Name
c.execute('''CREATE TABLE IF NOT EXISTS companies
             (id INTEGER PRIMARY KEY,
              name TEXT)''')

# Insert some example data into the companies table
c.execute("INSERT INTO companies (id, name) VALUES (1, 'Acme Inc.')")
c.execute("INSERT INTO companies (id, name) VALUES (2, 'XYZ Corp')")
c.execute("INSERT INTO companies (id, name) VALUES (3, 'Apple Inc.')")
c.execute("INSERT INTO companies (id, name) VALUES (4, 'Samsung Electronics')")
c.execute("INSERT INTO companies (id, name) VALUES (5, 'Toyota Motor Corporation')")
c.execute("INSERT INTO companies (id, name) VALUES (6, 'Google LLC')")

# Commit changes and close the connection
conn.commit()
conn.close()
