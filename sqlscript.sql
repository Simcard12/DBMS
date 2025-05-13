REM   Script: Actual DBMS
REM   actual

CREATE TABLE Student ( 
    Student_ID NUMBER PRIMARY KEY NOT NULL, 
    Name VARCHAR(100) NOT NULL, 
    Address VARCHAR(255), 
    Phone VARCHAR(20), 
    Email VARCHAR(100) NOT NULL, 
    Date_of_Birth DATE NOT NULL 
);

ALTER TABLE Student 
ADD CONSTRAINT UK_Student_Email UNIQUE (Email);

CREATE TABLE Department ( 
    Department_ID NUMBER PRIMARY KEY NOT NULL, 
    Department_Name VARCHAR(100) NOT NULL 
);

CREATE TABLE Faculty ( 
    Faculty_ID NUMBER PRIMARY KEY NOT NULL, 
    Name VARCHAR(100) NOT NULL, 
    Address VARCHAR(255), 
    Phone VARCHAR(20), 
    Email VARCHAR(100) NOT NULL, 
    Department_ID NUMBER NOT NULL, 
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID) 
);

ALTER TABLE Faculty 
ADD CONSTRAINT UK_Faculty_Email UNIQUE (Email);

CREATE TABLE Course ( 
    Course_ID NUMBER PRIMARY KEY NOT NULL, 
    Course_Name VARCHAR(100) NOT NULL, 
    Credits DECIMAL(3, 1), 
    Department_ID NUMBER NOT NULL, 
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID) 
);

CREATE TABLE Enrollment ( 
    Enrollment_ID NUMBER PRIMARY KEY NOT NULL, 
    Student_ID NUMBER NOT NULL, 
    Course_ID NUMBER NOT NULL, 
    Enrollment_Date DATE, 
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID), 
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) 
);

CREATE TABLE Exam ( 
    Exam_ID NUMBER PRIMARY KEY NOT NULL, 
    Course_ID NUMBER NOT NULL, 
    Exam_Date DATE, 
    Exam_Type VARCHAR(50), 
    Max_Marks DECIMAL(5, 2), 
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) 
);

CREATE TABLE Marks ( 
    Marks_ID NUMBER PRIMARY KEY NOT NULL, 
    Exam_ID NUMBER NOT NULL, 
    Student_ID NUMBER NOT NULL, 
    Marks_Obtained DECIMAL(5, 2), 
    Grade CHAR(1), 
    FOREIGN KEY (Exam_ID) REFERENCES Exam(Exam_ID), 
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) 
);

CREATE TABLE Society ( 
    Society_ID NUMBER PRIMARY KEY NOT NULL, 
    Society_Name VARCHAR(100) NOT NULL, 
    Description VARCHAR(300) 
);

CREATE TABLE Student_Society ( 
    Student_ID NUMBER, 
    Society_ID NUMBER, 
    PRIMARY KEY (Student_ID, Society_ID), 
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID), 
    FOREIGN KEY (Society_ID) REFERENCES Society(Society_ID) 
);

CREATE TABLE Fees ( 
    Fees_ID NUMBER PRIMARY KEY NOT NULL, 
    Student_ID NUMBER NOT NULL, 
    Amount DECIMAL(10, 2), 
    Payment_Date DATE, 
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) 
);

CREATE TABLE Attendance ( 
    Attendance_ID NUMBER PRIMARY KEY, 
    Enrollment_ID NUMBER NOT NULL, 
    Attendance_Date DATE NOT NULL, 
    Status VARCHAR2(7) NOT NULL 
);

CREATE OR REPLACE PROCEDURE Insert_Student( 
    p_Student_ID NUMBER, 
    p_Name VARCHAR2, 
    p_Address VARCHAR2, 
    p_Phone VARCHAR2, 
    p_Email VARCHAR2, 
    p_Date_of_Birth DATE 
) 
AS 
BEGIN 
    INSERT INTO Student (Student_ID, Name, Address, Phone, Email, Date_of_Birth) 
    VALUES (p_Student_ID, p_Name, p_Address, p_Phone, p_Email, p_Date_of_Birth); 
    COMMIT; 
END Insert_Student; 
/

CREATE OR REPLACE TRIGGER Check_Student_Email 
BEFORE INSERT OR UPDATE ON Student 
FOR EACH ROW 
BEGIN 
    IF :NEW.Email IS NOT NULL AND REGEXP_LIKE(:NEW.Email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') = FALSE THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Invalid email format for student'); 
    END IF; 
END; 
/

EXEC Insert_Student(1, 'John Doe', '123 Main St', '1234567890', 'john@example.com', TO_DATE('2000-01-01', 'YYYY-MM-DD'))


EXEC Insert_Student(2, 'Jane Smith', '456 Oak St', '0987654321', 'jane@example.com', TO_DATE('2001-02-02', 'YYYY-MM-DD'))


EXEC Insert_Student(3, 'Mike Doe', '145 Main St', '1234565590', 'mike@example.com', TO_DATE('2002-01-01', 'YYYY-MM-DD'))


EXEC Insert_Student(4, 'Milly', '123 Cross Street', '1234567330', 'milly@example.com', TO_DATE('2003-06-01', 'YYYY-MM-DD'))


EXEC Insert_Student(5, 'Kate', '145 Cross St', '1211567890', 'kate@example.com', TO_DATE('2005-01-08', 'YYYY-MM-DD'))


SELECT * FROM Student ORDER BY Student_ID;

CREATE OR REPLACE PROCEDURE Insert_Department( 
    p_Department_ID NUMBER, 
    p_Department_Name VARCHAR2 
) 
AS 
BEGIN 
    INSERT INTO Department (Department_ID, Department_Name) 
    VALUES (p_Department_ID, p_Department_Name); 
    COMMIT; 
END Insert_Department; 
/

EXEC Insert_Department(1, 'Computer Science')


EXEC Insert_Department(2, 'Electrical Engineering')


EXEC Insert_Department(3, 'Electronics Engineering') 


EXEC Insert_Department(4, 'Mechanical Engineering')


EXEC Insert_Department(5, 'Civil Engineering')


EXEC Insert_Department(6, 'Biomedical Engineering')


SELECT * FROM Department ORDER BY Department_ID;

CREATE OR REPLACE PROCEDURE Insert_Faculty( 
    p_Faculty_ID NUMBER, 
    p_Name VARCHAR2, 
    p_Address VARCHAR2, 
    p_Phone VARCHAR2, 
    p_Email VARCHAR2, 
    p_Department_ID NUMBER 
) 
AS 
BEGIN 
    INSERT INTO Faculty (Faculty_ID, Name, Address, Phone, Email, Department_ID) 
    VALUES (p_Faculty_ID, p_Name, p_Address, p_Phone, p_Email, p_Department_ID); 
    COMMIT; 
END Insert_Faculty; 
/

CREATE OR REPLACE TRIGGER Check_Faculty_Email_Unique 
BEFORE INSERT OR UPDATE ON Faculty 
FOR EACH ROW 
DECLARE 
    v_Count NUMBER; 
BEGIN 
    SELECT COUNT(*) INTO v_Count FROM Faculty WHERE Email = :NEW.Email AND Faculty_ID != :NEW.Faculty_ID; 
    IF v_Count > 0 THEN 
        RAISE_APPLICATION_ERROR(-20002, 'Email address must be unique for faculty'); 
    END IF; 
END; 
/

EXEC Insert_Faculty(1, 'Dr. Joe', '789 Elm St', '9876543210', 'profjoe@example.com', 1)


EXEC Insert_Faculty(2, 'Dr. Sam', '987 Pine St', '1234567890', 'profsam@example.com', 2)


EXEC Insert_Faculty(3, 'Dr. Jim', '917 Pine St', '1234557890', 'profjim@example.com', 3)


EXEC Insert_Faculty(4, 'Dr. Selena', '217 Elm St', '1134567890', 'profselena@example.com', 4)


EXEC Insert_Faculty(5, 'Dr. Helena', '987 Cross St', '1231567890', 'profhelena@example.com', 5)


SELECT * FROM Faculty ORDER BY Faculty_ID;

CREATE OR REPLACE PROCEDURE Insert_Course( 
    p_Course_ID NUMBER, 
    p_Course_Name VARCHAR2, 
    p_Credits DECIMAL, 
    p_Department_ID NUMBER 
) 
AS 
BEGIN 
    INSERT INTO Course (Course_ID, Course_Name, Credits, Department_ID) 
    VALUES (p_Course_ID, p_Course_Name, p_Credits, p_Department_ID); 
    COMMIT; 
END Insert_Course; 
/

EXEC Insert_Course(1, 'Introduction to Programming', 3.0, 1)


EXEC Insert_Course(2, 'Circuit Analysis', 4.5, 2)


EXEC Insert_Course(3, 'Data Structures', 3.0, 1)


EXEC Insert_Course(4, 'Control Systems', 4.0, 2)


EXEC Insert_Course(5, 'Digital Electronics', 3.0, 3)


SELECT * FROM Course ORDER BY Course_ID;

CREATE OR REPLACE PROCEDURE Insert_Enrollment( 
    p_Enrollment_ID NUMBER, 
    p_Student_ID NUMBER, 
    p_Course_ID NUMBER, 
    p_Enrollment_Date DATE 
) 
AS 
BEGIN 
    INSERT INTO Enrollment (Enrollment_ID, Student_ID, Course_ID, Enrollment_Date) 
    VALUES (p_Enrollment_ID, p_Student_ID, p_Course_ID, p_Enrollment_Date); 
    COMMIT; 
END Insert_Enrollment; 
/

CREATE OR REPLACE TRIGGER Check_Enrollment_Date 
BEFORE INSERT ON Enrollment 
FOR EACH ROW 
BEGIN 
    IF :NEW.Enrollment_Date > SYSDATE THEN 
        RAISE_APPLICATION_ERROR(-20003, 'Enrollment Date cannot be in the future'); 
    END IF; 
END; 
/

EXEC Insert_Enrollment(1, 1, 1, SYSDATE - 30)


EXEC Insert_Enrollment(2, 2, 2, SYSDATE - 45)


EXEC Insert_Enrollment(3, 3, 3, SYSDATE - 60)


EXEC Insert_Enrollment(4, 4, 4, SYSDATE - 75)


EXEC Insert_Enrollment(5, 5, 5, SYSDATE - 90)


SELECT * FROM Enrollment ORDER BY Enrollment_ID;

CREATE OR REPLACE PROCEDURE Insert_Exam( 
    p_Exam_ID NUMBER, 
    p_Course_ID NUMBER, 
    p_Exam_Date DATE, 
    p_Exam_Type VARCHAR2, 
    p_Max_Marks DECIMAL 
) 
AS 
BEGIN 
    INSERT INTO Exam (Exam_ID, Course_ID, Exam_Date, Exam_Type, Max_Marks) 
    VALUES (p_Exam_ID, p_Course_ID, p_Exam_Date, p_Exam_Type, p_Max_Marks); 
    COMMIT; 
END Insert_Exam; 
/

CREATE OR REPLACE TRIGGER Check_Exam_Date 
BEFORE INSERT OR UPDATE ON Exam 
FOR EACH ROW 
BEGIN 
    IF :NEW.Exam_Date < SYSDATE THEN 
        RAISE_APPLICATION_ERROR(-20004, 'Exam Date cannot be in the past'); 
    END IF; 
END; 
/

EXEC Insert_Exam(1, 1, SYSDATE + 7, 'Midterm', 100)


EXEC Insert_Exam(2, 2, SYSDATE + 14, 'Final', 100)


EXEC Insert_Exam(3, 3, SYSDATE + 21, 'Midterm', 100)


EXEC Insert_Exam(4, 4, SYSDATE + 28, 'Final', 100)


EXEC Insert_Exam(5, 5, SYSDATE + 35, 'Midterm', 100)


SELECT * FROM Exam ORDER BY Exam_ID;

CREATE OR REPLACE PROCEDURE Insert_Marks( 
    p_Marks_ID NUMBER, 
    p_Exam_ID NUMBER, 
    p_Student_ID NUMBER, 
    p_Marks_Obtained DECIMAL, 
    p_Grade CHAR 
) 
AS 
BEGIN 
    INSERT INTO Marks (Marks_ID, Exam_ID, Student_ID, Marks_Obtained, Grade) 
    VALUES (p_Marks_ID, p_Exam_ID, p_Student_ID, p_Marks_Obtained, p_Grade); 
    COMMIT; 
END Insert_Marks; 
/

CREATE OR REPLACE TRIGGER Check_Marks_Range 
BEFORE INSERT OR UPDATE ON Marks 
FOR EACH ROW 
DECLARE 
    v_Max_Marks DECIMAL(5, 2); 
BEGIN 
    -- Get the maximum marks for the corresponding exam 
    SELECT Max_Marks INTO v_Max_Marks 
    FROM Exam 
    WHERE Exam_ID = :NEW.Exam_ID; 
 
    -- Check if the Marks_Obtained is within the range 
    IF :NEW.Marks_Obtained < 0 OR :NEW.Marks_Obtained > v_Max_Marks THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Marks obtained must be between 0 and ' || v_Max_Marks); 
    END IF; 
END; 
/

CREATE OR REPLACE TRIGGER Assign_Grades 
BEFORE INSERT ON Marks 
FOR EACH ROW 
BEGIN 
    IF :NEW.Marks_Obtained >= 90 THEN 
        :NEW.Grade := 'A'; 
    ELSIF :NEW.Marks_Obtained >= 80 THEN 
        :NEW.Grade := 'B'; 
    ELSIF :NEW.Marks_Obtained >= 70 THEN 
        :NEW.Grade := 'C'; 
    ELSIF :NEW.Marks_Obtained >= 60 THEN 
        :NEW.Grade := 'D'; 
    ELSE 
        :NEW.Grade := 'F'; 
    END IF; 
END; 
/

EXEC Insert_Marks(1, 1, 1, 85, NULL)


EXEC Insert_Marks(2, 2, 2, 75, NULL)


EXEC Insert_Marks(3, 3, 3, 90, NULL)


EXEC Insert_Marks(4, 4, 4, 100, NULL)


EXEC Insert_Marks(5, 5, 5, 80, NULL)


SELECT * FROM Marks ORDER BY Marks_ID;

CREATE OR REPLACE PROCEDURE Insert_Society( 
    p_Society_ID NUMBER, 
    p_Society_Name VARCHAR2, 
    p_Description VARCHAR2 
) 
AS 
BEGIN 
    INSERT INTO Society (Society_ID, Society_Name, Description) 
    VALUES (p_Society_ID, p_Society_Name, p_Description); 
    COMMIT; 
END Insert_Society; 
/

EXEC Insert_Society(1, 'Chess Club', 'A club for chess enthusiasts')


EXEC Insert_Society(2, 'Debating Society', 'Promotes debate and public speaking skills')


EXEC Insert_Society(3, 'Photography Club', 'Bringing together photography enthusiasts')


EXEC Insert_Society(4, 'Music Band', 'Creating harmony through music')


EXEC Insert_Society(5, 'Environmental Club', 'Promoting environmental awareness and sustainability initiatives')


SELECT * FROM Society ORDER BY Society_ID;

CREATE OR REPLACE PROCEDURE Add_Student_Society_Entry ( 
    p_Student_ID NUMBER, 
    p_Society_ID NUMBER 
) 
AS 
BEGIN 
    INSERT INTO Student_Society (Student_ID, Society_ID) 
    VALUES (p_Student_ID, p_Society_ID); 
END; 
/

EXEC Add_Student_Society_Entry(1, 1)


EXEC Add_Student_Society_Entry(2, 2)


EXEC Add_Student_Society_Entry(3, 3)


EXEC Add_Student_Society_Entry(4, 4)


EXEC Add_Student_Society_Entry(5, 5)


SELECT * FROM Student_Society ORDER BY Society_ID;

CREATE OR REPLACE PROCEDURE Insert_Fees( 
    p_Fees_ID NUMBER, 
    p_Student_ID NUMBER, 
    p_Amount DECIMAL, 
    p_Payment_Date DATE 
) 
AS 
BEGIN 
    INSERT INTO Fees (Fees_ID, Student_ID, Amount, Payment_Date) 
    VALUES (p_Fees_ID, p_Student_ID, p_Amount, p_Payment_Date); 
    COMMIT; 
END Insert_Fees; 
/

EXEC Insert_Fees(1, 1, 500, SYSDATE - 15)


EXEC Insert_Fees(2, 2, 600, SYSDATE - 10)


EXEC Insert_Fees(3, 3, 550, SYSDATE - 5)


EXEC Insert_Fees(4, 4, 700, SYSDATE)


EXEC Insert_Fees(5, 5, 450, SYSDATE)


SELECT * FROM Fees ORDER BY Fees_ID;

CREATE OR REPLACE FUNCTION Calculate_Total_Fees(p_Student_ID NUMBER) 
RETURN DECIMAL 
IS 
    total_fees DECIMAL(10, 2) := 0; 
BEGIN 
    SELECT SUM(Amount) INTO total_fees 
    FROM Fees 
    WHERE Student_ID = p_Student_ID; 
     
    RETURN total_fees; 
END Calculate_Total_Fees; 
/

DECLARE 
    total_fees DECIMAL(10, 2); 
BEGIN 
    total_fees := Calculate_Total_Fees(1); -- For Student_ID = 1 
    DBMS_OUTPUT.PUT_LINE('Total Fees: ' || total_fees); 
END; 
/

CREATE OR REPLACE PROCEDURE Add_Attendance_Entry ( 
    p_Attendance_ID NUMBER, 
    p_Enrollment_ID NUMBER, 
    p_Attendance_Date DATE, 
    p_Status VARCHAR2 
) 
AS 
BEGIN 
    INSERT INTO Attendance (Attendance_ID, Enrollment_ID, Attendance_Date, Status) 
    VALUES (p_Attendance_ID, p_Enrollment_ID, p_Attendance_Date, p_Status); 
END; 
/

EXEC Add_Attendance_Entry(1, 1, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'PRESENT')


EXEC Add_Attendance_Entry(2, 2, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'PRESENT')


EXEC Add_Attendance_Entry(3, 3, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'ABSENT')


EXEC Add_Attendance_Entry(4, 4, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'PRESENT')


EXEC Add_Attendance_Entry(5, 5, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'ABSENT')


SELECT * FROM Attendance ORDER BY Attendance_ID;

CREATE OR REPLACE FUNCTION Get_Student_Attendance( 
    p_Student_ID NUMBER, 
    p_Course_ID NUMBER 
) 
RETURN NUMBER 
IS 
    v_AttendanceCount NUMBER; 
BEGIN 
    SELECT COUNT(*) 
    INTO v_AttendanceCount 
    FROM Attendance A 
    JOIN Enrollment E ON A.Enrollment_ID = E.Enrollment_ID 
    WHERE E.Student_ID = p_Student_ID 
    AND E.Course_ID = p_Course_ID 
    AND A.Status = 'PRESENT'; 
 
    RETURN v_AttendanceCount; 
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        RETURN 0; -- If no attendance found, return 0 
END; 
/

DECLARE 
    v_Attendance NUMBER; 
BEGIN 
    v_Attendance := Get_Student_Attendance(2, 2); --(actual student ID, actual course ID) 
    DBMS_OUTPUT.PUT_LINE('Attendance Count: ' || v_Attendance); 
END; 
/

CREATE OR REPLACE PROCEDURE Get_Enrolled_Students(p_Course_ID NUMBER) 
IS 
    -- Declare cursor variables 
    CURSOR students_cur IS 
        SELECT s.Student_ID, s.Name, s.Email, e.Enrollment_Date 
        FROM Student s 
        INNER JOIN Enrollment e ON s.Student_ID = e.Student_ID 
        WHERE e.Course_ID = p_Course_ID; 
     
    -- Declare variables to store cursor data 
    v_Student_ID NUMBER; 
    v_Student_Name VARCHAR2(100); 
    v_Student_Email VARCHAR2(100); 
    v_Enrollment_Date DATE; 
BEGIN 
    -- Open the cursor 
    OPEN students_cur; 
     
    -- Fetch data from the cursor 
    LOOP 
        FETCH students_cur INTO v_Student_ID, v_Student_Name, v_Student_Email, v_Enrollment_Date; 
        EXIT WHEN students_cur%NOTFOUND; 
         
        -- Display student information 
		 DBMS_OUTPUT.PUT_LINE('Enrolled Students for Course ID ' || p_Course_ID || ':'); 
        DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_Student_ID); 
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_Student_Name); 
        DBMS_OUTPUT.PUT_LINE('Email: ' || v_Student_Email); 
        DBMS_OUTPUT.PUT_LINE('Enrollment Date: ' || TO_CHAR(v_Enrollment_Date, 'DD-MON-YYYY')); 
        DBMS_OUTPUT.PUT_LINE('----------------------'); 
    END LOOP; 
     
    -- Close the cursor 
    CLOSE students_cur; 
END Get_Enrolled_Students; 
/

BEGIN 
    Get_Enrolled_Students(1); -- Assuming Course_ID = 1 
END; 
/

UPDATE Student  
SET Phone = '9876543210'  
WHERE Student_ID = 1;

EXEC Insert_Student(6, 'Alice', '789 Elm St', '1112223333', 'alice@example.com', TO_DATE('2003-03-03', 'YYYY-MM-DD'))


SELECT * FROM Student ORDER BY Student_ID;

UPDATE Marks  
SET Marks_Obtained = 90  
WHERE Student_ID = 1  
AND Exam_ID = 1;

SELECT Student.Student_ID, Student.Name, Society.Society_Name 
FROM Student 
JOIN Student_Society ON Student.Student_ID = Student_Society.Student_ID 
JOIN Society ON Student_Society.Society_ID = Society.Society_ID;

SELECT f.*, d.Department_Name  
FROM Faculty f  
JOIN Department d ON f.Department_ID = d.Department_ID;

SELECT c.*, d.Department_Name  
FROM Course c  
JOIN Department d ON c.Department_ID = d.Department_ID;

SELECT e.*, s.Name AS Student_Name, c.Course_Name  
FROM Enrollment e  
JOIN Student s ON e.Student_ID = s.Student_ID  
JOIN Course c ON e.Course_ID = c.Course_ID;

SELECT Exam_ID, AVG(Marks_Obtained) AS Average_Marks  
FROM Marks  
GROUP BY Exam_ID;

SELECT Exam_ID, AVG(Marks_Obtained) AS Average_Marks  
FROM Marks  
GROUP BY Exam_ID;

SELECT s.*  
FROM Student s  
LEFT JOIN Fees f ON s.Student_ID = f.Student_ID 
WHERE f.Student_ID IS NULL;

SELECT f.*  
FROM Faculty f  
LEFT JOIN Course c ON f.Department_ID = c.Department_ID  
WHERE c.Course_ID IS NULL;

SELECT s.*, m.Marks_Obtained  
FROM Student s  
JOIN Marks m ON s.Student_ID = m.Student_ID  
WHERE m.Marks_Obtained > 90;

SELECT c.Course_Name, COUNT(e.Student_ID) AS Enrolled_Students 
FROM Course c 
LEFT JOIN Enrollment e ON c.Course_ID = e.Course_ID 
GROUP BY c.Course_Name;

SELECT d.Department_Name, c.Course_Name 
FROM Department d 
JOIN Course c ON d.Department_ID = c.Department_ID 
ORDER BY d.Department_Name, c.Course_Name;

SELECT d.Department_Name, COUNT(f.Faculty_ID) AS Faculty_Count 
FROM Department d 
LEFT JOIN Faculty f ON d.Department_ID = f.Department_ID 
GROUP BY d.Department_Name;

-- Create a view for student performance analytics
CREATE OR REPLACE VIEW Student_Performance_Analytics AS
SELECT 
    s.Student_ID,
    s.Name AS Student_Name,
    c.Course_ID,
    c.Course_Name,
    AVG(m.Marks_Obtained) AS Average_Marks,
    MAX(m.Marks_Obtained) AS Highest_Marks,
    MIN(m.Marks_Obtained) AS Lowest_Marks,
    COUNT(DISTINCT e.Exam_ID) AS Total_Exams,
    (SELECT COUNT(*) 
     FROM Attendance a 
     JOIN Enrollment en ON a.Enrollment_ID = en.Enrollment_ID 
     WHERE en.Student_ID = s.Student_ID 
     AND en.Course_ID = c.Course_ID 
     AND a.Status = 'PRESENT') AS Attendance_Count,
    (SELECT COUNT(*) 
     FROM Attendance a 
     JOIN Enrollment en ON a.Enrollment_ID = en.Enrollment_ID 
     WHERE en.Student_ID = s.Student_ID 
     AND en.Course_ID = c.Course_ID) AS Total_Classes,
    m.Grade AS Latest_Grade
FROM 
    Student s
    JOIN Enrollment en ON s.Student_ID = en.Student_ID
    JOIN Course c ON en.Course_ID = c.Course_ID
    LEFT JOIN Exam e ON c.Course_ID = e.Course_ID
    LEFT JOIN Marks m ON e.Exam_ID = m.Exam_ID AND s.Student_ID = m.Student_ID
GROUP BY 
    s.Student_ID, s.Name, c.Course_ID, c.Course_Name, m.Grade;

-- Create a function to calculate student performance index
CREATE OR REPLACE FUNCTION Calculate_Performance_Index(
    p_Student_ID NUMBER,
    p_Course_ID NUMBER
) RETURN NUMBER IS
    v_Marks_Weight CONSTANT NUMBER := 0.7;
    v_Attendance_Weight CONSTANT NUMBER := 0.3;
    v_Avg_Marks NUMBER;
    v_Attendance_Percentage NUMBER;
    v_Performance_Index NUMBER;
BEGIN
    -- Get average marks
    SELECT AVG(m.Marks_Obtained)
    INTO v_Avg_Marks
    FROM Marks m
    JOIN Exam e ON m.Exam_ID = e.Exam_ID
    WHERE m.Student_ID = p_Student_ID
    AND e.Course_ID = p_Course_ID;
    
    -- Calculate attendance percentage
    SELECT 
        (COUNT(CASE WHEN a.Status = 'PRESENT' THEN 1 END) * 100.0 / COUNT(*))
    INTO v_Attendance_Percentage
    FROM Attendance a
    JOIN Enrollment en ON a.Enrollment_ID = en.Enrollment_ID
    WHERE en.Student_ID = p_Student_ID
    AND en.Course_ID = p_Course_ID;
    
    -- Calculate performance index
    v_Performance_Index := (v_Marks_Weight * v_Avg_Marks) + 
                          (v_Attendance_Weight * v_Attendance_Percentage);
    
    RETURN v_Performance_Index;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RETURN 0;
END Calculate_Performance_Index;
/

-- Create a procedure to generate student performance report
CREATE OR REPLACE PROCEDURE Generate_Student_Performance_Report(
    p_Student_ID NUMBER
) IS
    CURSOR course_cur IS
        SELECT DISTINCT c.Course_ID, c.Course_Name
        FROM Course c
        JOIN Enrollment e ON c.Course_ID = e.Course_ID
        WHERE e.Student_ID = p_Student_ID;
    
    v_Student_Name VARCHAR2(100);
    v_Performance_Index NUMBER;
    v_Overall_Performance NUMBER := 0;
    v_Course_Count NUMBER := 0;
    v_Performance_Category VARCHAR2(20);
BEGIN
    -- Get student name
    SELECT Name INTO v_Student_Name FROM Student WHERE Student_ID = p_Student_ID;
    
    DBMS_OUTPUT.PUT_LINE('===== PERFORMANCE REPORT FOR ' || v_Student_Name || ' (ID: ' || p_Student_ID || ') =====');
    DBMS_OUTPUT.PUT_LINE('Generated on: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    
    -- Process each course
    FOR course_rec IN course_cur LOOP
        v_Performance_Index := Calculate_Performance_Index(p_Student_ID, course_rec.Course_ID);
        
        -- Determine performance category
        IF v_Performance_Index >= 90 THEN
            v_Performance_Category := 'Excellent';
        ELSIF v_Performance_Index >= 75 THEN
            v_Performance_Category := 'Good';
        ELSIF v_Performance_Index >= 60 THEN
            v_Performance_Category := 'Average';
        ELSE
            v_Performance_Category := 'Needs Improvement';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Course: ' || course_rec.Course_Name);
        DBMS_OUTPUT.PUT_LINE('Performance Index: ' || ROUND(v_Performance_Index, 2));
        DBMS_OUTPUT.PUT_LINE('Performance Category: ' || v_Performance_Category);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
        
        v_Overall_Performance := v_Overall_Performance + v_Performance_Index;
        v_Course_Count := v_Course_Count + 1;
    END LOOP;
    
    -- Calculate and display overall performance
    IF v_Course_Count > 0 THEN
        v_Overall_Performance := v_Overall_Performance / v_Course_Count;
        DBMS_OUTPUT.PUT_LINE('OVERALL PERFORMANCE INDEX: ' || ROUND(v_Overall_Performance, 2));
        
        -- Determine overall performance category
        IF v_Overall_Performance >= 90 THEN
            v_Performance_Category := 'Excellent';
        ELSIF v_Overall_Performance >= 75 THEN
            v_Performance_Category := 'Good';
        ELSIF v_Overall_Performance >= 60 THEN
            v_Performance_Category := 'Average';
        ELSE
            v_Performance_Category := 'Needs Improvement';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('OVERALL PERFORMANCE CATEGORY: ' || v_Performance_Category);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No courses found for this student.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('===== END OF REPORT =====');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student with ID ' || p_Student_ID || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END Generate_Student_Performance_Report;
/

-- Example usage of the performance report procedure
BEGIN
    Generate_Student_Performance_Report(1); -- Generate report for Student ID 1
END;
/
