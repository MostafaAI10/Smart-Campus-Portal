-- Smart Campus Database Schema
-- Database: smart_campus

CREATE DATABASE IF NOT EXISTS smart_campus;
USE smart_campus;

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    profile_picture VARCHAR(255) DEFAULT 'default.jpg',
    role ENUM('student', 'instructor', 'admin') NOT NULL DEFAULT 'student',
    card_balance DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================
-- SEMESTERS TABLE
-- ============================================
CREATE TABLE semesters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,  -- e.g., 'Fall', 'Spring', 'Summer'
    year YEAR NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_current BOOLEAN DEFAULT FALSE
);

-- ============================================
-- COURSES TABLE
-- ============================================
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL,  -- e.g., 'CS101'
    name VARCHAR(255) NOT NULL,
    description TEXT,
    credits INT NOT NULL DEFAULT 3,
    instructor_id INT,
    semester_id INT NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE,
    UNIQUE KEY unique_course_semester (code, semester_id)
);

-- ============================================
-- ENROLLMENTS TABLE (links students to courses)
-- ============================================
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id)
);

-- ============================================
-- COURSE SCHEDULE TABLE
-- ============================================
CREATE TABLE course_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room VARCHAR(50),
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- ============================================
-- ASSESSMENTS TABLE (assignments, exams, quizzes)
-- ============================================
CREATE TABLE assessments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    type ENUM('assignment', 'quiz', 'midterm', 'final', 'project', 'other') NOT NULL,
    max_score DECIMAL(5, 2) NOT NULL DEFAULT 100.00,
    weight DECIMAL(5, 2) DEFAULT 1.00,  -- Weight for grade calculation
    due_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- ============================================
-- GRADES TABLE (student scores on assessments)
-- ============================================
CREATE TABLE grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    assessment_id INT NOT NULL,
    score DECIMAL(5, 2),
    graded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assessment_id) REFERENCES assessments(id) ON DELETE CASCADE,
    UNIQUE KEY unique_grade (student_id, assessment_id)
);

-- ============================================
-- ATTENDANCE TABLE
-- ============================================
CREATE TABLE attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('present', 'absent') NOT NULL DEFAULT 'present',
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_attendance (student_id, course_id, date)
);

-- ============================================
-- TASKS TABLE (student personal to-do list)
-- ============================================
CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATETIME,
    priority ENUM('low', 'medium', 'high') DEFAULT 'medium',
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================
-- ANNOUNCEMENTS TABLE
-- ============================================
CREATE TABLE announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL
);

-- ============================================
-- NEWS TABLE (campus news)
-- ============================================
CREATE TABLE news (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    summary TEXT,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    author_id INT,
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_courses_semester ON courses(semester_id);
CREATE INDEX idx_courses_instructor ON courses(instructor_id);
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
CREATE INDEX idx_grades_student ON grades(student_id);
CREATE INDEX idx_attendance_student_date ON attendance(student_id, date);
CREATE INDEX idx_tasks_user ON tasks(user_id);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_announcements_created ON announcements(created_at);
CREATE INDEX idx_news_published ON news(published_at);

-- ============================================
-- SAMPLE DATA (for testing)
-- ============================================

-- Semesters
INSERT INTO semesters (name, year, start_date, end_date, is_current) VALUES
('Fall', 2024, '2024-09-01', '2024-12-20', FALSE),
('Spring', 2025, '2025-01-15', '2025-05-15', TRUE),
('Summer', 2025, '2025-06-01', '2025-08-15', FALSE);

-- Users (password for all: 'password123')
-- Hash generated with password_hash('password123', PASSWORD_DEFAULT)
INSERT INTO users (email, password_hash, first_name, last_name, phone, address, role, card_balance) VALUES
('admin@campus.edu', '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK', 'Admin', 'User', '555-0100', '100 Admin Building', 'admin', 0.00),
('john.smith@campus.edu', '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK', 'John', 'Smith', '555-0101', '123 Main St, Anytown, USA', 'student', 150.50),
('jane.doe@campus.edu', '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK', 'Jane', 'Doe', '555-0102', '456 Oak Ave, Anytown, USA', 'student', 75.25),
('mike.johnson@campus.edu', '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK', 'Mike', 'Johnson', '555-0103', '789 Pine Rd, Anytown, USA', 'student', 200.00),
('sarah.williams@campus.edu', '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK', 'Sarah', 'Williams', '555-0104', '321 Elm St, Anytown, USA', 'student', 50.00),
('emily.brown@campus.edu', '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK', 'Emily', 'Brown', '555-0105', '654 Maple Dr, Anytown, USA', 'student', 125.75),
('dr.anderson@campus.edu', '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK', 'Robert', 'Anderson', '555-0201', '10 Faculty Lane', 'instructor', 0.00),
('dr.martinez@campus.edu', '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK', 'Maria', 'Martinez', '555-0202', '11 Faculty Lane', 'instructor', 0.00),
('dr.thompson@campus.edu', '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK', 'James', 'Thompson', '555-0203', '12 Faculty Lane', 'instructor', 0.00),
('dr.garcia@campus.edu', '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK', 'Lisa', 'Garcia', '555-0204', '13 Faculty Lane', 'instructor', 0.00);

-- Courses (Spring 2025 - semester_id = 2)
INSERT INTO courses (code, name, description, credits, instructor_id, semester_id) VALUES
('CS101', 'Introduction to Computer Science', 'Fundamentals of programming and computational thinking using Python.', 3, 7, 2),
('CS201', 'Data Structures', 'Study of fundamental data structures including arrays, linked lists, trees, and graphs.', 3, 7, 2),
('MATH101', 'Calculus I', 'Introduction to differential and integral calculus.', 4, 8, 2),
('MATH201', 'Linear Algebra', 'Vectors, matrices, linear transformations, and eigenvalues.', 3, 8, 2),
('ENG101', 'English Composition', 'Fundamentals of academic writing and critical reading.', 3, 9, 2),
('PHYS101', 'Physics I', 'Classical mechanics, thermodynamics, and waves.', 4, 10, 2),
('CS301', 'Database Systems', 'Design and implementation of relational database systems.', 3, 7, 2),
('CS401', 'Software Engineering', 'Software development methodologies, testing, and project management.', 3, 7, 2);

-- Course Schedules
INSERT INTO course_schedules (course_id, day_of_week, start_time, end_time, room) VALUES
(1, 'Monday', '09:00:00', '10:30:00', 'Room 101'),
(1, 'Wednesday', '09:00:00', '10:30:00', 'Room 101'),
(2, 'Tuesday', '11:00:00', '12:30:00', 'Room 102'),
(2, 'Thursday', '11:00:00', '12:30:00', 'Room 102'),
(3, 'Monday', '14:00:00', '15:30:00', 'Room 201'),
(3, 'Wednesday', '14:00:00', '15:30:00', 'Room 201'),
(3, 'Friday', '14:00:00', '15:00:00', 'Room 201'),
(4, 'Tuesday', '09:00:00', '10:30:00', 'Room 202'),
(4, 'Thursday', '09:00:00', '10:30:00', 'Room 202'),
(5, 'Monday', '11:00:00', '12:30:00', 'Room 301'),
(5, 'Wednesday', '11:00:00', '12:30:00', 'Room 301'),
(6, 'Tuesday', '14:00:00', '15:30:00', 'Lab 101'),
(6, 'Thursday', '14:00:00', '15:30:00', 'Lab 101'),
(6, 'Friday', '10:00:00', '12:00:00', 'Lab 101'),
(7, 'Monday', '16:00:00', '17:30:00', 'Room 103'),
(7, 'Wednesday', '16:00:00', '17:30:00', 'Room 103'),
(8, 'Tuesday', '16:00:00', '17:30:00', 'Room 104'),
(8, 'Thursday', '16:00:00', '17:30:00', 'Room 104');

-- Enrollments (students 2-6 enrolled in various courses)
INSERT INTO enrollments (student_id, course_id) VALUES
(2, 1), (2, 2), (2, 3), (2, 7),
(3, 1), (3, 3), (3, 5), (3, 6),
(4, 2), (4, 4), (4, 6), (4, 8),
(5, 1), (5, 3), (5, 5),
(6, 1), (6, 2), (6, 4), (6, 7), (6, 8);

-- Assessments
INSERT INTO assessments (course_id, name, type, max_score, weight, due_date) VALUES
-- CS101 assessments
(1, 'Python Basics Quiz', 'quiz', 100.00, 0.10, '2025-02-01 23:59:00'),
(1, 'Assignment 1: Variables & Loops', 'assignment', 100.00, 0.15, '2025-02-15 23:59:00'),
(1, 'Midterm Exam', 'midterm', 100.00, 0.25, '2025-03-10 14:00:00'),
(1, 'Assignment 2: Functions', 'assignment', 100.00, 0.15, '2025-04-01 23:59:00'),
(1, 'Final Project', 'project', 100.00, 0.20, '2025-05-01 23:59:00'),
(1, 'Final Exam', 'final', 100.00, 0.15, '2025-05-10 14:00:00'),
-- CS201 assessments
(2, 'Arrays & Lists Quiz', 'quiz', 100.00, 0.10, '2025-02-05 23:59:00'),
(2, 'Assignment 1: Linked Lists', 'assignment', 100.00, 0.20, '2025-02-20 23:59:00'),
(2, 'Midterm Exam', 'midterm', 100.00, 0.30, '2025-03-15 11:00:00'),
(2, 'Assignment 2: Trees & Graphs', 'assignment', 100.00, 0.20, '2025-04-10 23:59:00'),
(2, 'Final Exam', 'final', 100.00, 0.20, '2025-05-12 11:00:00'),
-- MATH101 assessments
(3, 'Limits Quiz', 'quiz', 100.00, 0.10, '2025-02-03 23:59:00'),
(3, 'Homework Set 1', 'assignment', 100.00, 0.15, '2025-02-17 23:59:00'),
(3, 'Midterm Exam', 'midterm', 100.00, 0.25, '2025-03-12 14:00:00'),
(3, 'Homework Set 2', 'assignment', 100.00, 0.15, '2025-04-05 23:59:00'),
(3, 'Final Exam', 'final', 100.00, 0.35, '2025-05-14 14:00:00'),
-- ENG101 assessments
(5, 'Essay 1: Personal Narrative', 'assignment', 100.00, 0.20, '2025-02-10 23:59:00'),
(5, 'Essay 2: Argumentative', 'assignment', 100.00, 0.25, '2025-03-20 23:59:00'),
(5, 'Research Paper', 'project', 100.00, 0.35, '2025-04-25 23:59:00'),
(5, 'Final Portfolio', 'final', 100.00, 0.20, '2025-05-08 23:59:00'),
-- PHYS101 assessments
(6, 'Mechanics Quiz', 'quiz', 100.00, 0.10, '2025-02-08 23:59:00'),
(6, 'Lab Report 1', 'assignment', 100.00, 0.15, '2025-02-22 23:59:00'),
(6, 'Midterm Exam', 'midterm', 100.00, 0.25, '2025-03-18 14:00:00'),
(6, 'Lab Report 2', 'assignment', 100.00, 0.15, '2025-04-12 23:59:00'),
(6, 'Final Exam', 'final', 100.00, 0.35, '2025-05-16 14:00:00');

-- Grades (sample grades for students)
INSERT INTO grades (student_id, assessment_id, score) VALUES
-- John Smith (id=2) grades
(2, 1, 85.00), (2, 2, 92.00), (2, 3, 78.00), (2, 4, 88.00),
(2, 7, 90.00), (2, 8, 85.00), (2, 9, 82.00),
(2, 12, 75.00), (2, 13, 80.00), (2, 14, 72.00),
-- Jane Doe (id=3) grades
(3, 1, 95.00), (3, 2, 98.00), (3, 3, 92.00), (3, 4, 96.00),
(3, 12, 88.00), (3, 13, 90.00), (3, 14, 85.00),
(3, 17, 92.00), (3, 18, 88.00),
(3, 21, 78.00), (3, 22, 82.00), (3, 23, 75.00),
-- Mike Johnson (id=4) grades
(4, 7, 70.00), (4, 8, 65.00), (4, 9, 68.00),
(4, 21, 72.00), (4, 22, 70.00), (4, 23, 65.00),
-- Sarah Williams (id=5) grades
(5, 1, 82.00), (5, 2, 78.00), (5, 3, 80.00),
(5, 12, 85.00), (5, 13, 82.00),
(5, 17, 90.00), (5, 18, 88.00),
-- Emily Brown (id=6) grades
(6, 1, 88.00), (6, 2, 90.00), (6, 3, 85.00), (6, 4, 92.00),
(6, 7, 94.00), (6, 8, 96.00), (6, 9, 90.00);

-- Attendance records (last 2 weeks of sample data)
INSERT INTO attendance (student_id, course_id, date, status) VALUES
-- Week 1 - December 9-13, 2024
(2, 1, '2024-12-09', 'present'), (2, 2, '2024-12-10', 'present'), (2, 3, '2024-12-09', 'present'),
(2, 1, '2024-12-11', 'present'), (2, 2, '2024-12-12', 'absent'), (2, 3, '2024-12-11', 'present'),
(3, 1, '2024-12-09', 'present'), (3, 3, '2024-12-09', 'present'), (3, 5, '2024-12-09', 'present'),
(3, 1, '2024-12-11', 'present'), (3, 3, '2024-12-11', 'present'), (3, 5, '2024-12-11', 'absent'),
(4, 2, '2024-12-10', 'present'), (4, 4, '2024-12-10', 'present'), (4, 6, '2024-12-10', 'present'),
(4, 2, '2024-12-12', 'absent'), (4, 4, '2024-12-12', 'present'), (4, 6, '2024-12-12', 'present'),
(5, 1, '2024-12-09', 'present'), (5, 3, '2024-12-09', 'present'), (5, 5, '2024-12-09', 'present'),
(5, 1, '2024-12-11', 'absent'), (5, 3, '2024-12-11', 'present'), (5, 5, '2024-12-11', 'present'),
(6, 1, '2024-12-09', 'present'), (6, 2, '2024-12-10', 'present'), (6, 4, '2024-12-10', 'present'),
(6, 1, '2024-12-11', 'present'), (6, 2, '2024-12-12', 'present'), (6, 4, '2024-12-12', 'present'),
-- Week 2 - December 16-20, 2024
(2, 1, '2024-12-16', 'present'), (2, 2, '2024-12-17', 'present'), (2, 3, '2024-12-16', 'present'),
(2, 1, '2024-12-18', 'absent'), (2, 2, '2024-12-19', 'present'), (2, 3, '2024-12-18', 'present'),
(3, 1, '2024-12-16', 'present'), (3, 3, '2024-12-16', 'present'), (3, 5, '2024-12-16', 'present'),
(3, 1, '2024-12-18', 'present'), (3, 3, '2024-12-18', 'present'), (3, 5, '2024-12-18', 'present'),
(4, 2, '2024-12-17', 'present'), (4, 4, '2024-12-17', 'present'), (4, 6, '2024-12-17', 'absent'),
(4, 2, '2024-12-19', 'present'), (4, 4, '2024-12-19', 'present'), (4, 6, '2024-12-19', 'present'),
(5, 1, '2024-12-16', 'present'), (5, 3, '2024-12-16', 'present'), (5, 5, '2024-12-16', 'present'),
(5, 1, '2024-12-18', 'present'), (5, 3, '2024-12-18', 'absent'), (5, 5, '2024-12-18', 'absent'),
(6, 1, '2024-12-16', 'present'), (6, 2, '2024-12-17', 'present'), (6, 4, '2024-12-17', 'present'),
(6, 1, '2024-12-18', 'present'), (6, 2, '2024-12-19', 'present'), (6, 4, '2024-12-19', 'present');

-- Tasks (student to-do items)
INSERT INTO tasks (user_id, title, description, due_date, priority, is_completed) VALUES
(2, 'Complete CS101 Assignment', 'Finish the Python functions assignment', '2025-01-20 23:59:00', 'high', FALSE),
(2, 'Study for Math Midterm', 'Review chapters 1-5 for calculus midterm', '2025-01-25 14:00:00', 'high', FALSE),
(2, 'Buy textbooks', 'Get textbooks for spring semester', '2025-01-10 17:00:00', 'medium', TRUE),
(2, 'Meet with advisor', 'Discuss course selection for next semester', '2025-01-15 10:00:00', 'medium', FALSE),
(3, 'Physics Lab Report', 'Write up results from last weeks experiment', '2025-01-18 23:59:00', 'high', FALSE),
(3, 'English Essay Draft', 'Complete first draft of argumentative essay', '2025-01-22 23:59:00', 'medium', FALSE),
(3, 'Group project meeting', 'Meet with team for CS101 project', '2025-01-12 15:00:00', 'low', TRUE),
(4, 'Register for classes', 'Sign up for summer courses', '2025-01-08 17:00:00', 'high', TRUE),
(4, 'Data Structures Homework', 'Complete linked list implementation', '2025-01-19 23:59:00', 'high', FALSE),
(5, 'Submit scholarship application', 'Complete and submit merit scholarship form', '2025-01-30 17:00:00', 'high', FALSE),
(5, 'Study group session', 'Calculus study session with classmates', '2025-01-14 18:00:00', 'low', FALSE),
(6, 'Database project proposal', 'Submit initial project proposal', '2025-01-17 23:59:00', 'high', FALSE),
(6, 'Review lecture notes', 'Catch up on Software Engineering lectures', '2025-01-10 20:00:00', 'medium', FALSE),
(6, 'Career fair prep', 'Update resume and prepare elevator pitch', '2025-01-14 12:00:00', 'medium', FALSE);

-- Announcements
INSERT INTO announcements (title, content, author_id, created_at) VALUES
('Welcome to Spring 2025 Semester', 'Welcome back students! Classes begin January 15th. Please check your schedules and contact the registrar if you have any issues.', 1, '2025-01-02 09:00:00'),
('Campus Library Extended Hours', 'The main library will remain open until midnight during the first two weeks of the semester to help students prepare.', 1, '2025-01-05 10:00:00'),
('Career Fair Announcement', 'The annual Spring Career Fair will be held on February 15th in the Student Union. Over 50 employers will attend. Dress professionally!', 1, '2025-01-08 11:00:00'),
('New Shuttle Bus Route', 'A new shuttle route connecting the North Campus to the downtown transit hub will begin operating January 20th.', 1, '2025-01-10 09:30:00'),
('Student Health Center Flu Shots', 'Free flu vaccinations are available at the Student Health Center every weekday from 9 AM to 4 PM through February.', 1, '2025-01-12 14:00:00'),
('Campus WiFi Maintenance', 'Scheduled maintenance will occur on January 18th from 2:00 AM to 6:00 AM. Expect brief connectivity interruptions.', 1, '2025-01-14 08:00:00'),
('Spring Semester Registration Reminder', 'Last day to add/drop courses without penalty is January 31st. Please finalize your schedules.', 1, '2025-01-16 09:00:00'),
('Mental Health Awareness Week', 'Join us for workshops and activities promoting mental wellness from February 3-7. Free counseling sessions available.', 1, '2025-01-18 10:00:00'),
('Parking Permit Information', 'Spring semester parking permits are now available for purchase online. Early bird discount ends January 25th.', 1, '2025-01-19 11:00:00'),
('New Study Rooms Available', 'Ten new group study rooms have been added to the Science Building. Reservations can be made through the student portal.', 1, '2025-01-20 13:00:00');

-- News
INSERT INTO news (title, summary, content, image_url, author_id, published_at) VALUES
('Campus Receives $5M Research Grant', 'The university has been awarded a major grant for renewable energy research.', 'The Department of Energy has awarded our university a $5 million grant to establish a new Renewable Energy Research Center. The center will focus on solar and wind energy innovations and will create opportunities for both graduate and undergraduate research assistants.', 'news_grant.jpg', 1, '2025-01-15 08:00:00'),
('New Student Recreation Center Opens', 'State-of-the-art fitness facility now available to all students.', 'The new 50,000 square foot Student Recreation Center is now open! Features include an Olympic-sized swimming pool, rock climbing wall, basketball courts, and modern fitness equipment. Student access is included in tuition fees.', 'news_rec_center.jpg', 1, '2025-01-12 10:00:00'),
('Computer Science Department Ranks Top 20', 'National rankings place our CS program among the best in the country.', 'U.S. News & World Report has ranked our Computer Science program #18 in the nation, up from #25 last year. The improvement is attributed to increased research funding and new faculty hires.', 'news_ranking.jpg', 1, '2025-01-10 09:00:00'),
('Alumni Donation Funds New Scholarships', 'Generous gift creates 20 new full-ride scholarships.', 'Tech entrepreneur and alumnus Michael Chen has donated $10 million to establish the Chen Scholars Program, which will provide full-ride scholarships to 20 students annually who demonstrate financial need and academic excellence.', 'news_scholarship.jpg', 1, '2025-01-08 11:00:00'),
('Winter Storm Preparedness', 'Campus emergency procedures for severe weather.', 'With winter weather approaching, please review the campus emergency procedures. In case of severe weather, check your email and the campus website for closure announcements. Emergency supplies are available at all residence halls.', 'news_weather.jpg', 1, '2025-01-05 14:00:00'),
('Student Government Elections Coming', 'Nominations open for spring student government elections.', 'Student Government elections will be held March 1-3. Nominations are now open for President, Vice President, and Senator positions. All full-time students in good academic standing are eligible to run.', 'news_election.jpg', 1, '2025-01-03 09:00:00'),
('Dining Hall Menu Updates', 'New healthy options added to campus dining.', 'Based on student feedback, campus dining services has added new vegetarian, vegan, and gluten-free options to all dining halls. A new smoothie bar has also been installed in the Main Dining Hall.', 'news_dining.jpg', 1, '2025-01-02 12:00:00'),
('Research Symposium Call for Papers', 'Submit your research for the annual student symposium.', 'The 15th Annual Student Research Symposium will be held April 10-11. Undergraduate and graduate students are invited to submit abstracts by February 28. Cash prizes will be awarded in each category.', 'news_research.jpg', 1, '2024-12-28 10:00:00');

-- ============================================
-- UPDATE SCRIPT (run this if database already exists with old password hash)
-- ============================================
-- To fix password hash for existing users, run this UPDATE statement:
-- UPDATE users SET password_hash = '$2y$10$OnvoCaKZXcRByNkbj7NAAeZCzBN1H/ERTe3VXxF8CTs/mdIcGBUkK';
-- Password for all users: password123
