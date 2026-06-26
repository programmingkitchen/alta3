#!/usr/bin/python3
"""J. Hutcheson | creating tables in SQLite"""
 
import sqlite3
 
# Create a connection to a new SQLite database
conn = sqlite3.connect('my_database.db')
 
# Create a cursor object to execute SQL commands
c = conn.cursor()

# Create the products table with columns for ID, Name, and Company ID
c.execute('''CREATE TABLE IF NOT EXISTS products
            (id INTEGER PRIMARY KEY,
             name TEXT,
             company_id INTEGER,
             FOREIGN KEY(company_id) REFERENCES companies(id))''')
 
# Insert some example data into the products table
c.execute("INSERT INTO products (id, name, company_id) VALUES (1, 'Widget', 4)")
c.execute("INSERT INTO products (id, name, company_id) VALUES (2, 'Gizmo', 2)")
c.execute("INSERT INTO products (id, name, company_id) VALUES (3, 'Thingamajig', 1)")
c.execute("INSERT INTO products (id, name, company_id) VALUES (4, 'Doohickey', 3)")
c.execute("INSERT INTO products (id, name, company_id) VALUES (5, 'Whatchamacallit', 6)")
c.execute("INSERT INTO products (id, name, company_id) VALUES (6, 'Gadget', 5)")
 
# Commit changes and close the connection
conn.commit()
conn.close()

