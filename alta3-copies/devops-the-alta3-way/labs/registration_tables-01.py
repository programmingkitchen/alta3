import sqlite3

# Create a connection to the database
conn = sqlite3.connect('my_database3.db')

# Create a cursor object to execute SQL commands
c = conn.cursor()

# Create the students table
c.execute('''
    CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
    )
''')

# Insert some data into the students table
students = [
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Charlie'),
    (4, 'Dave'),
    (5, 'Eve'),
    (6, 'Frank'),
    (7, 'Grace'),
    (8, 'Harry'),
    (9, 'Irene'),
    (10, 'Jack'),
    (11, 'Karen'),
    (12, 'Larry'),
    (13, 'Maggie'),
    (14, 'Nancy'),
    (15, 'Oscar')
]
c.executemany('INSERT INTO students VALUES (?, ?)', students) # <= this is new! Take a look at this command to see what it's doing differently than the script above.

# Create the courses table
c.execute('''
    CREATE TABLE IF NOT EXISTS courses (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
    )
''')

# Insert some data into the courses table
courses = [
    (1, 'Introduction to Programming'),
    (2, 'Database Management'),
    (3, 'Web Development')
]
c.executemany('INSERT INTO courses VALUES (?, ?)', courses) # <= just like the line above, this command is inserting 'many' records into our table.
                                                            # This approach *potentially* makes our script more dynamic should we need to add courses
                                                            # here or add students above.

# THIS IS NEW! Create the student_courses table
c.execute('''
    CREATE TABLE IF NOT EXISTS student_courses (
        id INTEGER PRIMARY KEY,
        student_id INTEGER NOT NULL,
        course_id INTEGER NOT NULL,
        registration_number TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students (id),
        FOREIGN KEY (course_id) REFERENCES courses (id)
    )
''')

# Insert some data into the student_courses table.
c.executemany('INSERT INTO student_courses (student_id, course_id, registration_number) VALUES (?, ?, ?)', [
    (1, 1, 'registration0101'),
    (1, 2, 'registration0102'),
    (2, 1, 'registration0103'),
    (2, 3, 'registration0104'),
    (3, 2, 'registration0105'),
    (3, 3, 'registration0106'),
    (4, 1, 'registration0107'),
    (4, 3, 'registration0108'),
    (5, 2, 'registration0109'),
    (5, 3, 'registration0110'),
    (6, 1, 'registration0111'),
    (6, 2, 'registration0112'),
    (7, 2, 'registration0113'),
    (7, 3, 'registration0114'),
    (8, 1, 'registration0115'),
    (8, 3, 'registration0116'),
    (9, 1, 'registration0117'),
    (9, 2, 'registration0118'),
    (10, 1, 'registration0119'),
    (10, 3, 'registration0120'),
    (11, 1, 'registration0121'),
    (11, 2, 'registration0122'),
    (12, 2, 'registration0123'),
    (12, 3, 'registration0124'),
    (13, 1, 'registration0125'),
    (13, 3, 'registration0126'),
    (14, 2, 'registration0127'),
    (14, 3, 'registration0128'),
    (15, 1, 'registration0129'),
    (15, 2, 'registration0130')
])

conn.commit()
conn.close()
