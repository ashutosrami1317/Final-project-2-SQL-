====== Final Project =======


CREATE DATABASE UniversityDB;

USE UniversityDB;

CREATE TABLE Departments
( DepartmentID INT PRIMARY KEY,
DepartmentName VARCHAR(100));


CREATE TABLE Students
(
    StudentID INT PRIMARY KEY,
    FristName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);


CREATE TABLE Courses
(
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);



CREATE TABLE Instructors
(
    InstructorID INT PRIMARY KEY,
    FristName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Salary DECIMAL(10,2),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID)
    REFERENCES Departments(DepartmentID)
);


CREATE TABLE Enrollments
(
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID)
    REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID)
    REFERENCES Courses(CourseID)
);

===== Departments ========


INSERT INTO Departments VALUES
(1,'Computer Science'),
(2,'Mathematics');

====== Students =========


INSERT INTO Students VALUES
(1,'John','Doe','john.doe@email.com','2000-01-15','2022-08-01'),
(2,'Jane','Smith','jana.smith@email.com','1999-05-25','2021-08-01'),
(3,'David','Brown','davi@email.com','2001-04-20','2023-01-10'),
(4,'Sara','Willson','sara@email.com','2002-07-15','2022-09-15'),
(5,'Mike','Taylor','mike@email.com','2000-03-18','2020-08-20'),
(6,'Emma','Thomes','ema@email.com','1998-06-22','2019-08-15');


======= Courses ========

INSERT INTO Courses VALUES
(101,'Introduction to SQL',1,3),
(102,'Date Structures',2,4);


======= Instructors ========

INSERT INTO Instructors VALUES
(1,'Alice','Johnson','alice@univ.com',70000,1),
(2,'Bob','Lee','bob@uni.com',65000,2);


======== Enrollments =========

INSERT INTO Enrollments VALUES
(1,1,101,'2022-08-01'),
(2,2,102,'2021-08-01'),
(3,3,101,'2023-01-10'),
(4,4,101,'2022-09-15'),
(5,5,102,'2020-08-20'),
(6,6,101,'2019-08-15');


####### CRUD Operations ########

======= Create ======

INSERT INTO Students
VALUES
(7,'Chris','Martin','chirs@email.com','2002-10-10','2023-08-01');


======= Read ========

SELECT * FROM Students;


====== Update ======

UPDATE Students
SET Email='john123@email.com'
WHERE StudentID=1;

====== DELETE ======

DELETE FROM Students
WHERE StudentID=7;

===== Students enrolled after 2022 =======

SELECT *
FROM Students
WHERE EnrollmentDate>'2022-12-31';

====== Mathematics Department Courses =======

SELECT *
from Courses
WHERE DepartmentID=
(
    SELECT DepartmentID
    from Departments
    WHERE DepartmentName='Mathematics'
)
limit 5;


====== Courses having more than 5 students =======


SELECT CourseID,
COUNT(StudentID) AS TotalStudents
from Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID)>5;


====== Students enrolled in both courses =======


SELECT StudentID
from Enrollments
WHERE CourseID in (101,102)
GROUP BY StudentID
HAVING COUNT(DISTINCT CourseID)=2;


======= Students enrolled in either course =======

SELECT DISTINCT StudentID
from Enrollments
WHERE CourseID in (101,102);


======= Average credits =======


SELECT AVG(Credits) as AverageCredits
from Courses;


======= Maximum salary in Computer Science ========


SELECT MAX(Salary)
from Instructors
WHERE DepartmentID=
(
    SELECT DepartmentID
    from Departments
    WHERE DepartmentName='Computer Science'
);


======== Students in each Department =========

SELECT d.DepartmentName,
COUNT(e.StudentID) as TotalStudents
from Departments d
join courses c
ON d.DepartmentID=c.DepartmentID
join Enrollments e
ON c.CourseID=e.CourseID
GROUP BY d.DepartmentName;


======= INNER JOIN =======


SELECT s.FristName,
s.LastName,
c.CourseName
from students s 
INNER JOIN Enrollments e 
ON s.StudentID=e.StudentID
INNER JOIN Courses c 
ON e.CourseID=c.CourseID;


======== LEFT JOIN ========

SELECT s.FristName,
s.LastName,
FROM Students s 
LEFT JOIN Enrollments e 
ON s.StudentID=e.StudentID
LEFT JOIN Courses c 
ON e.CourseID=c.CourseID;

====== Students in course whith more than 10 students ======


SELECT *
FROM Students
WHERE StudentID IN
(
SELECT StudentID
FROM Enrollments
WHERE CourseID IN
(
SELECT CourseID
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(*)>10
)
);


====== Extract year =======


SELECT StudentID,
YEAR(EnrollmentDate) AS EnrollmentYEAR
FROM Students;


====== Instructors Full name =======


SELECT CONCAT(FristName,' ',LastName) AS InstructorName 
FROM Instructors;


======= Running total (window Function) =======

SELECT
EnrollmentID,
StudentID,
COUNT(StudentID)
OVER(ORDER BY EnrollmentID)
AS RunningTotal
FROM Enrollments;


======== CASE Statement =======

SELECT
FristName,
EnrollmentDate,
CASE
WHEN TIMESTAMPDIFF(YEAR,EnrollmentDate,CURDATE())>4
THEN 'Senior'
ELSE 'Junior'
END AS StudentLevel
FROM Students;