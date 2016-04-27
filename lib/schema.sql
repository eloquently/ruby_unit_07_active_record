CREATE TABLE schools ( id INTEGER PRIMARY KEY AUTOINCREMENT,
                       name TEXT NOT NULL,
                       min_grade INTEGER,
                       max_grade INTEGER,
                       next_school_id INTEGER );

CREATE TABLE teachers ( id INTEGER PRIMARY KEY AUTOINCREMENT,
                        first_name TEXT,
                        last_name TEXT,
                        school_id INTEGER );

CREATE TABLE students ( id INTEGER PRIMARY KEY AUTOINCREMENT,
                        first_name TEXT,
                        last_name TEXT,
                        school_id INTEGER,
                        grade_level INTEGER);

CREATE TABLE classes ( id INTEGER PRIMARY KEY AUTOINCREMENT,
                       name TEXT,
                       teacher_id INTEGER);

CREATE TABLE tests ( id INTEGER PRIMARY KEY AUTOINCREMENT,
                     name TEXT,
                     score INTEGER,
                     class_id INTEGER,
                     student_id INTEGER );

CREATE TABLE classes_students ( class_id INTEGER,
                                student_id INTEGER );