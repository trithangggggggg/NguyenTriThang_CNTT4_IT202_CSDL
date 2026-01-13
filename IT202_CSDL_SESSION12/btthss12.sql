CREATE DATABASE StudentDB;
USE StudentDB;
-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID CHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID CHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID CHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID CHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID CHAR(6),
    CourseID CHAR(6),
    Score FLOAT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);



INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','C Programming',3),
('C00003','Microeconomics',2),
('C00004','Financial Accounting',3);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00001','C00002',7.0),
('S00002','C00001',6.5),
('S00003','C00003',7.5),
('S00004','C00004',8.0),
('S00005','C00001',9.0),
('S00006','C00003',6.0),
('S00007','C00004',7.0),
('S00008','C00001',5.5),
('S00008','C00002',6.5);

select * from Department;
select * from Student;
select * from Course;
select * from Enrollment;

-- A 
--  cau 1 Tạo View View_StudentBasic hiển thị: StudentID, FullName , DeptName. Sau đó truy vấn toàn bộ View_StudentBasic;
create view view_studentbasic as
select s.studentid, s.fullname, d.deptname
from student s
join department d on s.deptid = d.deptid;
select * from view_studentbasic;

-- cau 2 Tạo Regular Index cho cột FullName của bảng Student.
create index idx_student_fullname
on student(fullname);

-- cau 3 Viết Stored Procedure 	
-- ●Không có tham số
-- ●Chức năng: hiển thị toàn bộ sinh viên thuộc khoa Information Technology trong bảng Student + DeptName từ bảng Department.
-- ●Gọi đến procedue GetStudentsIT.
delimiter //
create procedure GetStudentsIT()
begin
	select s.studentid, s.fullname, s.gender, s.birthdate, d.deptname
	from student s join department d 
    on s.deptid = d.deptid
    where d.deptname = 'Information Technology';
end // 
delimiter ;
call GetStudentsIT();

-- B 
-- cau 4
-- a)Tạo View View_StudentCountByDept hiển thị: DeptName, TotalStudents (số sinh viên mỗi khoa).
-- b)Từ View trên, viết truy vấn hiển thị khoa có nhiều sinh viên nhất.
drop view view_studentcountbydept;
create view view_studentcountbydept as
select d.deptname, count(s.studentid) as totalstudents
from department d left join student s 
on s.deptid = d.deptid
group by d.deptname;
select * from view_studentcountbydept;

-- cau 5
-- Viết Stored Procedure GetTopScoreStudent
-- a)
-- ●Tham số: IN p_CourseID
-- ●Chức năng: Hiển thị sinh viên có điểm cao nhất trong môn học được truyền vào. 
-- b) Gọi thủ tục trên để tìm sinh viên có điểm cao nhất môn Database Systems (C00001).



delimiter //
create procedure gettopscorestudent (
    in p_courseid char(6)
)
begin
    select s.studentid, s.fullname,c.coursename,  e.score
    from enrollment e join student s 
    on e.studentid = s.studentid
    join course c on e.courseid = c.courseid
    where e.courseid = p_courseid
      and e.score = (
          select max(score)
          from enrollment
          where courseid = p_courseid
      );
end //
delimiter ;
call gettopscorestudent('C00001');





















