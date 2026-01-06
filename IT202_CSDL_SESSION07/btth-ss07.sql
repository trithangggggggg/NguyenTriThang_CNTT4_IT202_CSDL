create database btthsession07;
use btthsession07;

create table student(
	stu_id int auto_increment primary key,
    stu_name varchar(255) not null,
	class varchar(50)
);

create table subject (
    subject_id int auto_increment primary key,
    subject_name varchar(100),
    credit int
);

create table exam (
    exam_id int auto_increment primary key,
    stu_id int,
    subject_id int,
    mark int,
    exam_date date,
    foreign key (stu_id) references student(stu_id),
    foreign key (subject_id) references subject(subject_id)
);

insert into student (stu_id, stu_name, class) values
(1, 'an', 'cntt1'),
(2, 'bình', 'cntt1'),
(3, 'chi', 'cntt2');

select * from student;

insert into subject (subject_id, subject_name, credit) values
(1, 'sql', 3),
(2, 'java', 4),
(3, 'oop', 3);

select * from subject;

insert into exam (exam_id, stu_id, subject_id, mark, exam_date) values
(1, 1, 1, 8, '2024-06-01'),
(2, 1, 1, 9, '2024-07-01'),
(3, 2, 1, 6, '2024-06-01'),
(4, 2, 2, 7, '2024-06-01'),
(5, 3, 1, 9, '2024-06-01');

select * from exam;


-- bai 1 diem cao hon diem trung binh mon
select distinct s.stu_id, s.stu_name
from student s join exam e 
on s.stu_id = e.stu_id
where e.subject_id = 1
and e.mark > ( 
	select avg(mark) 
    from exam 
    where subject_id = 1 
);

-- bai 2 sinh vien co it nhat 1 mon >= avg cua sinh vien 1
select distinct s.stu_id, s.stu_name
from student s join exam e 
on s.stu_id = e.stu_id
where e.mark >= any (
    select mark
    from exam
    where stu_id = 1
);

-- bai 3 sinh vien cs diem cao hon tat ca diem cua sinh vien 2
select s.stu_id, s.stu_name
from student s
where not exists (
    select 1
    from exam e
    where e.stu_id = s.stu_id
    and e.mark <= all (
        select mark
        from exam
        where stu_id = 2
    )
);







