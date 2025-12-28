create database session02;

-- bai 2
use session02;

create table class (
	malop varchar(10) not null primary key,
	tenlop varchar(50) not null,
	namhoc int not null
);

create table student (
	masv varchar(10) not null primary key,
	hoten varchar(100) not null,
	ngaysinh date,
	malop varchar(10) not null,
	constraint fk_lophoc foreign key (malop) references class(malop)
);

-- bai 3
use session02;

create table student_b3 (
	masv varchar(10) not null primary key,
	hoten varchar(100) not null
);

create table subject (
	mamonhoc varchar(10) not null primary key,
	tenmonhoc varchar(100) not null,
	sotinchi int not null,
	constraint chk_sotinchi check (sotinchi > 0)
);

-- bai 4
use session02;

create table enrollment (
	masv varchar(10) not null,
	mamonhoc varchar(10) not null,
	ngaydangky date not null,
	primary key (masv, mamonhoc),
	constraint fk_student_enroll foreign key (masv) references student_b3(masv),
	constraint fk_subject_enroll foreign key (mamonhoc) references subject(mamonhoc)
);

-- bai 5
use session02;

create table teacher (
	magv varchar(10) not null primary key,
	hoten varchar(100) not null,
	email varchar(100) unique
);

alter table subject
add magv varchar(10),
add constraint fk_teacher_subject foreign key (magv) references teacher(magv);

-- bai 6
use session02;

create table score (
	masv varchar(10) not null,
	mamonhoc varchar(10) not null,
	diemquatrinh decimal(4,2),
	diemcuoiky decimal(4,2),
	primary key (masv, mamonhoc),
	constraint fk_student_score foreign key (masv) references student_b3(masv),
	constraint fk_subject_score foreign key (mamonhoc) references subject(mamonhoc),
	constraint chk_diemquatrinh check (diemquatrinh between 0 and 10),
	constraint chk_diemcuoiky check (diemcuoiky between 0 and 10)
);

-- bai 7
use session02;

create table class_b7 (
	malop varchar(10) not null primary key,
	tenlop varchar(50) not null,
	namhoc int not null
);

create table teacher_b7 (
	magv varchar(10) not null primary key,
	hoten varchar(100) not null,
	email varchar(100) unique
);

create table student_b7 (
	masv varchar(10) not null primary key,
	hoten varchar(100) not null,
	ngaysinh date,
	malop varchar(10),
	constraint fk_student_class_b7 foreign key (malop) references class_b7(malop)
);

create table subject_b7 (
	mamonhoc varchar(10) not null primary key,
	tenmonhoc varchar(100) not null,
	sotinchi int not null,
	magv varchar(10),
	constraint chk_sotinchi_b7 check (sotinchi > 0),
	constraint fk_subject_teacher_b7 foreign key (magv) references teacher_b7(magv)
);

create table enrollment_b7 (
	masv varchar(10) not null,
	mamonhoc varchar(10) not null,
	ngaydangky date not null,
	primary key (masv, mamonhoc),
	constraint fk_enroll_student_b7 foreign key (masv) references student_b7(masv),
	constraint fk_enroll_subject_b7 foreign key (mamonhoc) references subject_b7(mamonhoc)
);

create table score_b7 (
	masv varchar(10) not null,
	mamonhoc varchar(10) not null,
	diemquatrinh decimal(4,2),
	diemcuoiky decimal(4,2),
	primary key (masv, mamonhoc),
	constraint fk_score_student_b7 foreign key (masv) references student_b7(masv),
	constraint fk_score_subject_b7 foreign key (mamonhoc) references subject_b7(mamonhoc),
	constraint chk_diemqt_b7 check (diemquatrinh between 0 and 10),
	constraint chk_diemck_b7 check (diemcuoiky between 0 and 10)
);
