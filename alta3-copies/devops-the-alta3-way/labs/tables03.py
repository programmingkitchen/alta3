import sqlite3

# Connect to a new database (or open an existing one)
conn = sqlite3.connect('my_database2.db')

# Create a cursor object to execute SQL commands
c = conn.cursor()

# Create the companies table
c.execute('''
          CREATE TABLE IF NOT EXISTS companies (
              id INTEGER PRIMARY KEY,
              name TEXT
          )
          ''')

# Insert some data into the companies table
c.execute('''
          INSERT INTO companies (id, name)
          VALUES (1, 'Acme Inc.')
          ''')
c.execute('''
          INSERT INTO companies (id, name)
          VALUES (2, 'XYZ Corp.')
          ''')

# Create the products table
c.execute('''
          CREATE TABLE IF NOT EXISTS products (
              id INTEGER PRIMARY KEY,
              name TEXT,
              company_id INTEGER REFERENCES companies(id)
          )
          ''')

# Insert some data into the products table
c.execute('''
          INSERT INTO products (id, name, company_id)
          VALUES (1, 'Widget', 1)
          ''')
c.execute('''
          INSERT INTO products (id, name, company_id)
          VALUES (2, 'Gizmo', 2)
          ''')
c.execute('''
          INSERT INTO products (id, name, company_id)
          VALUES (3, 'Thingamajig', 1)
          ''')
c.execute('''
          INSERT INTO products (id, name, company_id)
          VALUES (4, 'Doohickey', 2)
          ''')
c.execute('''
          INSERT INTO products (id, name, company_id)
          VALUES (5, 'Whatchamacallit', 1)
          ''')
c.execute('''
          INSERT INTO products (id, name, company_id)
          VALUES (6, 'Gadget', 2)
          ''')
c.execute('''
          INSERT INTO products (id, name, company_id)
          VALUES (7, 'Gizmometer', 2)
          ''')
c.execute('''
          INSERT INTO products (id, name, company_id)
          VALUES (8, 'Doohickey 2', 1)
          ''')
c.execute('''
          INSERT INTO products (id, name, company_id)
          VALUES (9, 'Thingamajig 2', 1)
          ''')
c.execute('''
          INSERT INTO products (id, name, company_id)
          VALUES (10, 'Widget Pro', 1)
          ''')

# Commit the changes and close the connection
conn.commit()
conn.close()
