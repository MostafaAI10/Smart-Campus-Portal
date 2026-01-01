# 🎓 Smart Campus Portal

A professional, role-based full-stack web application designed to manage academic and campus-related services for students and staff.

---

## Overview

**Smart Campus Portal** is a web-based system that centralizes essential academic functions such as:

- Course management  
- Grades and attendance  
- Announcements  
- Scheduling  
- Personal task management (To-Do List)

The project demonstrates **secure authentication**, **role-based access control**, and **modern UI/UX practices**, making it suitable for **university capstone projects** and **professional portfolios**.

---

## 👥 User Roles

### 🧑‍🎓 Student
Students can:
- View enrolled courses
- View grades and attendance
- View announcements
- Manage a personal To-Do List
- View schedules and calendar

Students **cannot** modify academic data.

---

### 🧑‍🏫 Staff
Staff users (instructors, TAs, coordinators) can:
- View assigned courses
- View enrolled students
- Enter and update grades
- Mark and edit attendance
- Create, edit, and delete course-specific announcements
- Manage professional and personal To-Do List tasks

Staff **cannot**:
- Manage users or roles  
- Post global system announcements  
- Access system configuration  

> **Admin functionality is intentionally excluded** from this implementation scope.

---

## ✨ Features

### 🔐 Authentication & Security
- Secure login and registration
- Password hashing using `password_hash()`
- Session-based authentication
- Role-based access control (RBAC)

### 📊 Dashboards
- Role-specific dashboards
- Widget-based layout
- Academic and task summaries

### 📝 To-Do List Module
- Assignment tasks
- Exam reminders
- Project deadlines
- Personal notes
- Drag-and-drop reordering
- Priority levels & categories
- Due dates & task status
- Dashboard widget (Today / Upcoming / Overdue)

### 📢 Announcements
- Course-specific announcements
- Staff-controlled creation and editing
- Student read-only access

### 📅 Schedule & Calendar
- Weekly and monthly views
- Interactive event details

### 🌙 Light & Dark Mode
- Implemented using CSS variables
- JavaScript toggle
- Consistent branding across modes

---

## 🎨 Design & Branding

### Color Palette
- **Primary Blue:** `#0281ed`
- **Dark Navy:** `#0a1a2b`
- **White:** `#ffffff`
- **Light Gray:** `#d9d9d9`
- **Mid Gray:** `#b4b4b4`

Used consistently across:
- Navigation bars
- Dashboards
- Buttons & forms
- Cards & widgets
- Light and dark themes

### Logo
The project logo (`/assets/logo.png`) is displayed in:
- Login page header
- Dashboard navigation bar
- Browser favicon

---

## 🛠 Tech Stack

### Front-End
- HTML5
- CSS3 (Flexbox, Grid, CSS Variables)
- JavaScript (ES6, AJAX, Drag & Drop API)

### Back-End
- PHP (PDO)
- MySQL
- Session management

---

## 📁 Project Structure

```text
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
├── assets/
│   ├── logo.png
│   ├── icons/
│   └── images/
│
├── css/
│   ├── style.css
│   ├── dashboard.css
│   ├── dark-mode.css
│   └── tasks.css
│
├── js/
│   ├── main.js
│   ├── darkmode.js
│   └── tasks.js
│
└── backend/
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


