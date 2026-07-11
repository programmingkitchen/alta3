import sqlite3

conn = sqlite3.connect('my_database3.db')

c = conn.cursor()

c.execute('SELECT name FROM students')

names = c.fetchall() # returns a list of tuples

print("Students on the roster:")
student_names = [] # sets up an empty list...

for name in names:
    print(name[0])
    student_names.append(name[0]) # adds that string to a list of student names

student_name = " "

while student_name not in student_names:
    print("Enter the name of a student to see their courses:")
    student_name = input(">>").title() # ensures the first letter of our user input is capitalized to test against our list.

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
