🎓 Smart Campus Portal

A full-stack, role-based web application designed to manage academic and campus-related services for students and staff in a unified digital platform.

📌 Project Overview

The Smart Campus Portal centralizes essential academic functions such as course management, grades, attendance, announcements, scheduling, and personal task tracking.
The system is designed with security, scalability, and usability in mind, following professional software engineering practices.

The project demonstrates a complete end-to-end web system using HTML, CSS, JavaScript, PHP, and MySQL, with strict role-based access control.

👥 User Roles
🧑‍🎓 Student

Students can:

View enrolled courses

View grades and attendance

View announcements

Manage a personal To-Do List

View schedules and calendar

Students cannot modify academic data.

🧑‍🏫 Staff

Staff users (instructors, TAs, coordinators) can:

View assigned courses

View enrolled students

Enter and update grades

Mark and edit attendance

Create, edit, and delete course-specific announcements

Manage professional and personal To-Do List tasks

Staff cannot:

Manage users or roles

Post global system announcements

Access system configuration

Admin functionality is intentionally excluded from this implementation scope.

✨ Core Features
🔐 Authentication & Security

Secure login and registration

Password hashing using password_hash()

Session-based authentication

Role-based access control

📊 Dashboards

Role-specific dashboards

Widget-based layout

Real-time academic summaries

📝 To-Do List Module

Assignment tasks

Exam reminders

Project deadlines

Personal notes

Drag-and-drop task reordering

Priority levels & categories

Due dates & status tracking

Dashboard task widget (Today / Upcoming / Overdue)

📢 Announcements

Course-specific announcements

Staff-controlled creation and editing

Student read-only access

📅 Schedule & Calendar

Weekly and monthly views

Interactive event details

🌙 Light & Dark Mode

Implemented using CSS variables

JavaScript toggle

Consistent branding across modes

🎨 Design & Branding
Color Palette

Primary Blue: #0281ed

Dark Navy: #0a1a2b

White: #ffffff

Light Gray: #d9d9d9

Mid Gray: #b4b4b4

These colors are applied consistently across:

Navigation bars

Dashboards

Buttons & forms

Cards & widgets

Light and dark themes

Logo Usage

The project logo (/assets/logo.png) is used in:

Login page header

Dashboard navigation bar

Browser favicon

🛠 Technology Stack
Front-End

HTML5

CSS3 (Flexbox, Grid, CSS Variables)

JavaScript (ES6, AJAX, Drag & Drop API)

Back-End

PHP (PDO for database access)

MySQL

Session management

📁 Project Structure
/root
│── index.php
│── login.php
│── register.php
│── dashboard.php
│── schedule.php
│── announcements.php
│── tasks.php
│── README.md
│
├── /assets
│   ├── logo.png
│   ├── icons/
│   └── images/
│
├── /css
│   ├── style.css
│   ├── dashboard.css
│   ├── dark-mode.css
│   └── tasks.css
│
├── /js
│   ├── main.js
│   ├── darkmode.js
│   └── tasks.js
│
└── /backend
    ├── config/
    │   ├── config.php
    │   └── db.php
    │
    ├── middleware/
    │   ├── auth.php
    │   └── staff.php
    │
    ├── auth/
    │   ├── login.php
    │   ├── register.php
    │   └── logout.php
    │
    ├── announcements/
    │   ├── create.php
    │   ├── update.php
    │   ├── delete.php
    │   └── list.php
    │
    ├── tasks/
    │   ├── add.php
    │   ├── update.php
    │   ├── delete.php
    │   └── get.php
    │
    └── database.sql

🗄 Database Design

The system uses a relational MySQL database with the following core tables:

users

courses

grades

attendance

announcements

tasks

Foreign key relationships ensure data integrity and role isolation.

🚀 Installation & Setup

Clone or download the repository

Place the project inside your local server directory (e.g. htdocs)

Import backend/database.sql into MySQL

Update database credentials in backend/config/db.php

Start Apache & MySQL

Access the project via:

http://localhost/smart-campus-portal

🧪 Testing

Functional testing for each module

Role-based access testing

UI responsiveness testing

Unauthorized access prevention testing

🔮 Future Enhancements

Real-time notifications

File uploads for assignments

Analytics dashboards

Mobile application

Email integration

📄 License

This project is developed for educational purposes and may be extended or modified as needed.

👨‍💻 Author

Smart Campus Portal
Full-Stack Academic Project


