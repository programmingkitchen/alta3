import sqlite3

conn = sqlite3.connect('my_database3.db')

c = conn.cursor()

student_name = 'Alice'

c.execute('''
    SELECT courses.name
    FROM courses
    JOIN student_courses ON courses.id = student_courses.course_id
    JOIN students ON students.id = student_courses.student_id
    WHERE students.name = ?''', (student_name,))

courses = c.fetchall()
print(f"{student_name} is taking the following courses:")
for course in courses:
    print(course[0])

conn.close()
