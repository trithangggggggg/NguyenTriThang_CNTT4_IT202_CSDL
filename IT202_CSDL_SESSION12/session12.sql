create database session12;
use session12;

create table users(
  user_id int primary key auto_increment,
  username varchar(50) unique not null,
  password varchar(255) not null,
  email varchar(100) unique not null,
  created_at datetime default current_timestamp
);

create table posts(
  post_id int primary key auto_increment,
  user_id int,
  content text not null,
  created_at datetime default current_timestamp,
  foreign key (user_id) references users(user_id)
);
-- ===== 1) USERS (10 rows) =====
insert into users (username, password, email) values
('user01','pass01','user01@gmail.com'),
('user02','pass02','user02@gmail.com'),
('user03','pass03','user03@gmail.com'),
('user04','pass04','user04@gmail.com'),
('user05','pass05','user05@gmail.com'),
('user06','pass06','user06@gmail.com'),
('user07','pass07','user07@gmail.com'),
('user08','pass08','user08@gmail.com'),
('user09','pass09','user09@gmail.com'),
('user10','pass10','user10@gmail.com');

-- ===== 2) POSTS (10 rows) =====
insert into posts (user_id, content) values
(1, 'Post 1: Hello world!'),
(2, 'Post 2: Today is a good day.'),
(3, 'Post 3: Learning MySQL.'),
(4, 'Post 4: Mini project social network.'),
(5, 'Post 5: I love databases.'),
(6, 'Post 6: Practice makes perfect.'),
(7, 'Post 7: Views and indexes are useful.'),
(8, 'Post 8: Stored procedures are cool.'),
(9, 'Post 9: Working on comments & likes.'),
(10,'Post 10: Done posting!');

-- ===== 3) COMMENTS (10 rows) =====
insert into comments (post_id, user_id, content) values
(1, 2, 'Nice post!'),
(1, 3, 'Hello!'),
(2, 1, 'Agree with you.'),
(3, 4, 'Good luck!'),
(4, 5, 'Interesting project.'),
(5, 6, 'Database is fun.'),
(6, 7, 'Keep going!'),
(7, 8, 'Great info.'),
(8, 9, 'Procedures help a lot.'),
(10,1, 'Congrats!');

-- ===== 4) FRIENDS (10 rows) =====
insert into friends (user_id, friend_id, status) values
(1, 2, 'accepted'),
(1, 3, 'pending'),
(2, 3, 'accepted'),
(2, 4, 'pending'),
(3, 5, 'accepted'),
(4, 5, 'pending'),
(6, 7, 'accepted'),
(7, 8, 'pending'),
(8, 9, 'accepted'),
(9,10, 'pending');

-- ===== 5) LIKES (10 rows) =====
insert into likes (user_id, post_id) values
(2, 1),
(3, 1),
(1, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 6),
(8, 7),
(9, 8),
(10,9);

create table comments(
  comment_id int primary key auto_increment,
  post_id int,
  user_id int,
  content text not null,
  created_at datetime default current_timestamp,
  foreign key (post_id) references posts(post_id),
  foreign key (user_id) references users(user_id)
);

create table friends(
  user_id int,
  friend_id int,
  status varchar(20),
  check (status in ('pending','accepted')),
  foreign key (user_id) references users(user_id),
  foreign key (friend_id) references users(user_id)
);

create table likes(
  user_id int,
  post_id int,
  foreign key (user_id) references users(user_id),
  foreign key (post_id) references posts(post_id)
);


-- bai 2
create view vw_public_users as
select user_id, username, created_at
from users;
select * from vw_public_users;
select * from users;















