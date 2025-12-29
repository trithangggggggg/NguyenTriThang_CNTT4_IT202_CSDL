create database session03;
use session03;

-- bai 1
create table Student (	
  student_id int auto_increment primary key, 
  full_name varchar(100) not null,
  date_of_birth date , 
  email varchar(100) unique
);
insert into Student (full_name, date_of_birth, email)
values 
('nguyen tri thang', '2006-02-02','trithangne14112@gmail.com' ),
('vu viet tien', '2006-12-02','tienlo@gmail.com' ),
('nguyen tuan minh', '2006-12-02','minhlo@gmail.com' );

select * from Student;
select student_id, full_name from Student;

-- bai 2
update Student
set email = 'emaildaduocthaydoi@gmail.com'
where student_id = '3';

update Student
set date_of_birth = '2006-09-30'
where student_id='2';

delete from Student
where student_id = '3';

select * from Student;

-- bai 3
create table Subjects (
	subject_id int auto_increment primary key,
    subject_name varchar(100),
    credit int not null check (credit >0)
);

insert into Subjects (subject_name, credit)
value 	
    ('python co ban', 5),
    ('huong dan mua flo tu co ban den nang cao',36);
select* from Subjects;

update Subjects
set subject_name = 'python nang cao', credit = '3636'
where subject_id = '1';

-- bai 4
create table Enrollment (
	Student_id int,
    Subject_id int,
    Enroll_date date,
    foreign key(Student_id) references Student(Student_id),
    foreign key(Subject_id) references Subjects(Subject_id)
);
insert into Enrollment (student_id, subject_id, enroll_date)
value 
    (1, 1, '2025-12-20'),
    (1, 2, '2025-12-20'),
    (2, 1, '2025-12-20');
select* from Enrollment;
select* from Enrollment where  student_id = 1;
select* from Enrollment where  student_id = 2;

-- bai 5
create table Score(	
   student_id int , 
   subject_id int , 
   mid_score double not null check(mid_score > 0 and mid_score <= 10),
   final_score double not null check(final_score > 0 and final_score <= 10),
   foreign key(student_id) references Student(student_id),
   foreign key(subject_id) references Subjects(subject_id)
);
insert into Score ( student_id , subject_id, mid_score ,final_score) 
value 
    (1,1,9.4,8.2),
    (2,2,5,8),
    (2,2,6,9);
update Score 
set final_score = 4
where student_id = 2;

select * from Score;
select * from Score where  final_score>= 8;

insert into Student (full_name, date_of_birth, email)
value 
    ('nguyen quoc hung', '2006-02-22', 'hung3636@gmail.com');

insert into Enrollment (student_id, subject_id, enroll_date)
value 
    (2, 1, '2025-12-29'),
    (2, 2, '2025-12-29');
insert into Score ( student_id , subject_id, mid_score ,final_score) 
value 
    (1,1,9.9,8.2);
    
update Score 
set  final_score = 1
where student_id = 1;
select * from Student where student_id = 1;
select * from Score where student_id = 1;

delete from Enrollment
where student_id = 2;

select * from Enrollment ;






