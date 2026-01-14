drop database session13;
create database session13;
use session13;

-- kha 1
create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts (
    post_id int auto_increment primary key,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    constraint fk_posts_users
        foreign key (user_id)
        references users(user_id)
        on delete cascade
);

insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

-- thêm bài viết tăng post_count
delimiter //
create trigger trg_after_insert_post
after insert on posts
for each row
begin
    update users
    set post_count = post_count + 1
    where user_id = new.user_id;
end//
delimiter ;

-- xóa bài viết giảm post_count
delimiter //
create trigger trg_after_delete_post
after delete on posts
for each row
begin
    update users
    set post_count = post_count - 1
    where user_id = old.user_id;
end//
delimiter ;

insert into posts (user_id, content, created_at) values
(1, 'hello world from alice!', '2025-01-10 10:00:00'),
(1, 'second post by alice', '2025-01-10 12:00:00'),
(2, 'bob first post', '2025-01-11 09:00:00'),
(3, 'charlie sharing thoughts', '2025-01-12 15:00:00');

select * from users;

delete from posts where post_id = 2;
select * from users;

-- kha 2
create table likes (
    like_id int auto_increment primary key,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    constraint fk_likes_users
        foreign key (user_id)
        references users(user_id)
        on delete cascade,
    constraint fk_likes_posts
        foreign key (post_id)
        references posts(post_id)
        on delete cascade
);

insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

-- lượt thích mới thi tăng like_count
delimiter //
create trigger trg_after_insert_like
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end//
delimiter ;

-- xóa lượt thích thi giảm like_count
delimiter //
create trigger trg_after_delete_like
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end//
delimiter ;

create view user_statistics as
select
    u.user_id,
    u.username,
    u.post_count,
    ifnull(sum(p.like_count), 0) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.post_count;

insert into likes (user_id, post_id, liked_at)
values (2, 4, now());
select * from posts where post_id = 4;
select * from user_statistics;

delete from likes where like_id = 5;
select * from posts where post_id = 4;
select * from user_statistics;

-- gioi 3
-- chặn user like bài của chính mình
delimiter //
create trigger trg_before_insert_like
before insert on likes
for each row
begin
    declare post_owner_id int;

    select user_id
    into post_owner_id
    from posts
    where post_id = new.post_id;

    if new.user_id = post_owner_id then
        signal sqlstate '45000'
        set message_text = 'user dont like your post';
    end if;
end//
delimiter ;

delimiter //
create trigger trg_after_insert_like
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end//
delimiter ;

delimiter //
create trigger trg_after_delete_like
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end//
delimiter ;


delimiter //
create trigger trg_after_update_like
after update on likes
for each row
begin
    if old.post_id <> new.post_id then
        -- giảm like ở post cũ
        update posts
        set like_count = like_count - 1
        where post_id = old.post_id;

        -- tăng like ở post mới
        update posts
        set like_count = like_count + 1
        where post_id = new.post_id;
    end if;
end//
delimiter ;

insert into likes (user_id, post_id)
values (1, 1);


insert into likes (user_id, post_id)
values (2, 1);
select post_id, like_count from posts where post_id = 1;


update likes
set post_id = 3
where like_id = 6;
select post_id, like_count
from posts
where post_id in (1, 3);


delete from likes where like_id = 6;
select post_id, like_count from posts where post_id = 3;

select post_id, user_id, like_count
from posts;
select * from user_statistics;


-- bai 4 gioi 
create table post_history (
    history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    constraint fk_post_history_posts
        foreign key (post_id)
        references posts(post_id)
        on delete cascade
);

delimiter //
create trigger trg_before_update_post
before update on posts
for each row
begin
    if old.content <> new.content then
        insert into post_history (
            post_id,
            old_content,
            new_content,
            changed_at,
            changed_by_user_id
        )
        values (
            old.post_id,
            old.content,
            new.content,
            now(),
            old.user_id
        );
    end if;
end//
delimiter ;

update posts
set content = 'updated content for alice post'
where post_id = 1;

update posts
set content = 'charlie updated his thoughts'
where post_id = 4;

select * from post_history order by history_id;


select post_id, content, like_count from posts where post_id in (1,4);
select * from user_statistics;

-- bai 5
delimiter //
create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users (username, email, created_at)
    values (p_username, p_email, p_created_at);
end//
delimiter ;

delimiter //
create trigger trg_users_before_insert
before insert on users
for each row
begin
    -- kiểm tra email
    if new.email not like '%@%' or new.email not like '%.%' then
        signal sqlstate '45000'
        set message_text = 'invalid email';
    end if;

    -- kiểm tra username
    if new.username not regexp '^[a-za-z0-9_]+$' then
        signal sqlstate '45000'
        set message_text = 'invalid username';
    end if;
end//
delimiter ;

-- hợp lệ
call add_user('user_ok', 'user_ok@example.com', '2025-01-20');

-- email sai
call add_user('user1', 'user1example.com', '2025-01-21');

-- username sai
call add_user('user#2', 'user2@example.com', '2025-01-22');

select * from users;


-- bai 6 gioi

create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending','accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
);


delimiter //
create trigger trg_after_insert_friendship
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end//
delimiter ;

delimiter //
create trigger trg_after_delete_friendship
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users
        set follower_count = follower_count - 1
        where user_id = old.followee_id;
    end if;
end//
delimiter ;

delimiter //
create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending','accepted')
)
begin
    -- không cho tự follow
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'cannot follow yourself';
    end if;

    -- tránh follow trùng
    if exists (
        select 1 from friendships
        where follower_id = p_follower_id
          and followee_id = p_followee_id
    ) then
        signal sqlstate '45000'
        set message_text = 'already followed';
    end if;

    insert into friendships (follower_id, followee_id, status)
    values (p_follower_id, p_followee_id, p_status);
end//
delimiter ;

create view user_profile as
select
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    ifnull(sum(p.like_count),0) as total_likes,
    group_concat(p.content order by p.created_at desc separator ' | ') as recent_posts
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;

call follow_user(2, 1, 'accepted');
call follow_user(3, 1, 'accepted');

select user_id, follower_count from users where user_id = 1;

call follow_user(1, 1, 'accepted'); -- tu follow (loi)\

-- unfollow
delete from friendships
where follower_id = 2 and followee_id = 1;

select user_id, follower_count from users where user_id = 1;

select * from user_profile;
