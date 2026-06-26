import sqlite3

# create a connection to the database
conn = sqlite3.connect('mydatabase.db')

# create a cursor object to execute SQL queries
cursor = conn.cursor()

# create the students table
cursor.execute('''
    CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT
    )
''')

# create the courses table
cursor.execute('''
    CREATE TABLE IF NOT EXISTS courses (
        id INTEGER PRIMARY KEY,
        name TEXT
    )
''')

# add data to the students table
cursor.execute('''
    INSERT INTO students (id, name)
    VALUES
        (1, 'Alice'),
        (2, 'Bob'),
        (3, 'Charlie'),
        (4, 'Dave'),
        (5, 'Eve'),
        (6, 'Frank'),
        (7, 'Grace'),
        (8, 'Hank'),
        (9, 'Ivy'),
        (10, 'Jack'),
        (11, 'Karen'),
        (12, 'Leo'),
        (13, 'Mia'),
        (14, 'Nate'),
        (15, 'Olivia')
''')

# add data to the courses table
cursor.execute('''
    INSERT INTO courses (id, name)
    VALUES
        (1, 'Introduction to Computer Science'),
        (2, 'Data Structures and Algorithms'),
        (3, 'Web Development')
''')

# commit the changes to the database
conn.commit()

# close the connection
conn.close()

