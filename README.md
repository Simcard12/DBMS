# University Database Management System

## Overview
This project implements a comprehensive database management system for a university or college. It manages essential academic data including students, faculty, courses, enrollments, exams, attendance, and more. The system is built using Oracle 23ai and includes various tables, procedures, functions, triggers, and analytics features.

## Features

### Core Entities
- **Students**: Manage student information including personal details and academic records
- **Faculty**: Track faculty members and their department affiliations
- **Departments**: Organize academic departments
- **Courses**: Manage course offerings with credits and department associations
- **Enrollments**: Track student enrollment in courses
- **Exams & Marks**: Record exam schedules and student performance
- **Attendance**: Monitor student attendance in courses
- **Fees**: Track student fee payments

### Advanced Features
- **Student Performance Analytics**: View aggregated performance metrics for students across courses
- **Performance Index Calculator**: Calculate weighted performance scores based on academics and attendance
- **Performance Reports**: Generate detailed performance reports for students
- **Email Validation**: Ensure valid email formats for students and faculty
- **Data Integrity Checks**: Various triggers to maintain data consistency

## Database Schema

### Main Tables
- Student
- Faculty
- Department
- Course
- Course_Schedule
- Enrollment
- Exam
- Marks
- Attendance
- Society
- Student_Society
- Fees
- Student_GPA
- Academic_Standing

### Views
- Student_Performance_Analytics: Provides aggregated performance metrics for students

### Functions and Procedures
- Insert_Student: Add new student records
- Insert_Department: Add new department records
- Insert_Faculty: Add new faculty records
- Insert_Course: Add new course offerings
- Insert_Enrollment: Register students for courses
- Insert_Exam: Schedule new exams
- Insert_Marks: Record student exam results
- Calculate_Performance_Index: Compute student performance metrics
- Generate_Student_Performance_Report: Create comprehensive student reports

## Usage Examples

### Adding a New Student
```sql
EXEC Insert_Student(
    p_Student_ID => Student_Seq.NEXTVAL, 
    p_Name => 'John Doe', 
    p_Address => '123 Main St', 
    p_Phone => '1234567890', 
    p_Email => 'john@example.com', 
    p_Date_of_Birth => TO_DATE('2000-01-01', 'YYYY-MM-DD')
);
```

### Generating a Student Performance Report
```sql
BEGIN
    Generate_Student_Performance_Report(1); -- For Student ID 1
END;
```

### Viewing Student Performance Analytics
```sql
SELECT * FROM Student_Performance_Analytics WHERE Student_ID = 1;
```

## Installation and Setup

1. Ensure you have Oracle 23ai or compatible database installed
2. Run the main SQL script to create the database schema:
   ```
   sqlplus username/password@database @sqlscript.sql
   ```
3. The script will create all necessary sequences, tables, procedures, functions, triggers, and sample data

## Data Model
The database follows a relational model with appropriate foreign key constraints to maintain data integrity. Key relationships include:
- Students enroll in courses
- Courses belong to departments
- Faculty members are assigned to departments
- Exams are associated with courses
- Marks are recorded for students taking exams
- Attendance is tracked for enrolled students

## Performance Considerations
- Indexes are created on frequently queried columns
- Triggers are used to maintain data integrity
- Views are used to simplify complex queries
- Stored procedures encapsulate business logic

## Future Enhancements
- Web interface for data management
- Advanced reporting and analytics
- Integration with learning management systems
- Mobile application for students and faculty
- API for third-party integrations

## License
This project is available for educational and non-commercial use.

## Last Updated
May 13, 2025
