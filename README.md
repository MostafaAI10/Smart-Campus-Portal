# smart-campus-project
This repository contains the code and resources for the Smart Campus Project.
Some of the backend files (mainly the php files) are AI assisted, as we did not get enough practice on PHP.
The database is AI generated and some of the SQL queries are also AI generated.
The frontend is NOT AI generated, the only thing AI helped in was the colors, as we could not make something that visually appealing, all the css placements and displays are NOT AI generated.

01. Introduction 
1.1 Project Overview 
The Smart Campus Portal is a full-stack web-based system designed to facilitate academic and 
campus-related services for students, staff, and administrators. The platform centralizes course 
management, grades, attendance, announcements, scheduling, and personal task management 
into a single, secure portal. 
1.2 Project Objectives 
 Provide a unified digital campus experience 
 Support role-based access for students, staff, and admins 
 Improve academic workflow efficiency 
 Demonstrate professional full-stack system design 
1.3 Target Users 
 Students 
 Academic Staff (Instructors, TAs, Coordinators) 
 System Administrators 
02. System Scope & Features 
2.1 Core Features 
 User authentication & authorization 
 Role-based dashboards 
 Course, grade, and attendance management 
 Announcements system 
 Interactive schedule & calendar 
 Integrated To-Do List 
 Dark & light mode support 
2.2 Out-of-Scope 
 Financial systems 
 Payment processing 
 External LMS integration 
03. Technology Stack 
3.1 Front-End 
 HTML5 
 CSS3 (Flexbox, Grid, CSS Variables) 
 JavaScript (ES6, AJAX, Drag & Drop API) 
3.2 Back-End 
 PHP (PDO) 
 MySQL 
 Session-based authentication 
3.3 Tools 
 GitHub (version control) 
 VS Code (development environment) 
04. System Architecture 
4.1 Architecture Overview 
The Smart Campus Portal follows a modular layered architecture to ensure maintainability, 
scalability, and security. Each layer has a clear responsibility and communicates with other 
layers through well-defined interfaces. 
Architecture Layers: 
 Presentation Layer: HTML, CSS, JavaScript responsible for UI rendering and user 
interaction. 
 Application Layer: PHP controllers handling business logic, role validation, and request 
processing. 
 Data Access Layer: PDO-based MySQL interactions for secure and efficient database 
operations. 
This separation of concerns ensures that UI changes do not affect business logic, and database 
modifications remain isolated from the front-end. 
4.2 File & Folder Structure 
The project uses a structured directory layout to separate responsibilities clearly: 

