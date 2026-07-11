...
registrations = [
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
]

c.executemany('INSERT INTO student_courses (student_id, course_id, registration_number) VALUES (?, ?, ?)', registrations)

conn.commit()
conn.close()
