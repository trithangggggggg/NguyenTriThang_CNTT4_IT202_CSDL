create database if not exists session141;
use session141;

create table users (
  user_id int auto_increment primary key,
  username varchar(50) not null,
  post_count int default 0,
  following_count int default 0,
  followers_count int default 0,
  friends_count int default 0
);

create table posts (
  post_id int auto_increment primary key,
  user_id int not null,
  content text not null,
  created_at datetime default current_timestamp,
  like_count int default 0,
  comments_count int default 0,
  foreign key (user_id) references users(user_id)
);

insert into users (username, post_count) values
('alice', 2),
('bob', 1),
('charlie', 1),
('david', 1),
('emma', 1),
('frank', 1),
('grace', 0);

insert into posts (user_id, content) values
(1, 'bai viet thu nhat cua alice'),
(1, 'bai viet thu hai cua alice'),
(2, 'bai viet cua bob'),
(3, 'bai viet cua charlie'),
(4, 'bai viet cua david'),
(5, 'bai viet cua emma'),
(6, 'bai viet cua frank');

start transaction;
insert into posts (user_id, content)
values (1, 'tien dep trai');
update users
set post_count = post_count + 1
where user_id = 1;
commit;

start transaction;
insert into posts (user_id, content)
values (99, 'tien dep trai');
update users
set post_count = post_count + 1
where user_id = 999;
rollback;

create table likes (
  like_id int auto_increment primary key,
  post_id int not null,
  user_id int not null,
  foreign key (post_id) references posts(post_id),
  foreign key (user_id) references users(user_id)
);

insert into likes (post_id, user_id) values
(1, 2),
(1, 3),
(2, 4),
(3, 1),
(4, 5),
(5, 6),
(6, 7);

start transaction;
insert into likes (post_id, user_id)
values (1, 2);
update posts
set like_count = like_count + 1
where post_id = 1;
commit;

start transaction;
insert into likes (post_id, user_id)
values (1, 2);
update posts
set like_count = like_count + 1
where post_id = 1;
rollback;

create table followers (
  follower_id int,
  followed_id int,
  primary key (follower_id, followed_id),
  foreign key (follower_id) references users(user_id),
  foreign key (followed_id) references users(user_id)
);

create table follow_log (
  log_id int auto_increment primary key,
  follower_id int,
  followed_id int,
  error_message varchar(255),
  log_time datetime default current_timestamp
);

delimiter //

create procedure sp_follow_user (
  in p_follower_id int,
  in p_followed_id int
)
begin
  declare v_count int;

  start transaction;

  select count(*) into v_count
  from users
  where user_id in (p_follower_id, p_followed_id);

  if v_count < 2 then
    insert into follow_log
    values (null, p_follower_id, p_followed_id, 'user khong ton tai', now());
    rollback;

  elseif p_follower_id = p_followed_id then
    insert into follow_log
    values (null, p_follower_id, p_followed_id, 'khong duoc tu follow', now());
    rollback;

  elseif exists (
    select 1 from followers
    where follower_id = p_follower_id
      and followed_id = p_followed_id
  ) then
    insert into follow_log
    values (null, p_follower_id, p_followed_id, 'da follow truoc do', now());
    rollback;

  else
    insert into followers
    values (p_follower_id, p_followed_id);

    update users
    set following_count = following_count + 1
    where user_id = p_follower_id;

    update users
    set followers_count = followers_count + 1
    where user_id = p_followed_id;

    commit;
  end if;
end;
//
delimiter ;

create table comments (
  comment_id int auto_increment primary key,
  post_id int,
  user_id int,
  content text,
  created_at datetime default current_timestamp,
  foreign key (post_id) references posts(post_id),
  foreign key (user_id) references users(user_id)
);

delimiter //

create procedure sp_post_comment (
  in p_post_id int,
  in p_user_id int,
  in p_content text
)
begin
  start transaction;

  insert into comments (post_id, user_id, content)
  values (p_post_id, p_user_id, p_content);

  savepoint after_insert;

  update posts
  set comments_count = comments_count + 1
  where post_id = p_post_id;

  if row_count() = 0 then
    rollback to after_insert;
  else
    commit;
  end if;
end;
//
delimiter ;

delimiter //

create procedure sp_delete_post (
  in p_post_id int,
  in p_user_id int
)
begin
  declare v_owner int;

  start transaction;

  select user_id into v_owner
  from posts
  where post_id = p_post_id;

  if v_owner is null then
    rollback;

  elseif v_owner <> p_user_id then
    rollback;

  else
    delete from likes where post_id = p_post_id;
    delete from comments where post_id = p_post_id;
    delete from posts where post_id = p_post_id;

    update users
    set post_count = post_count - 1
    where user_id = p_user_id
      and post_count > 0;

    commit;
  end if;
end;
//
delimiter ;

create table friend_requests (
  request_id int auto_increment primary key,
  from_user_id int,
  to_user_id int,
  status varchar(20),
  foreign key (from_user_id) references users(user_id),
  foreign key (to_user_id) references users(user_id)
);

create table friends (
  user_id int,
  friend_id int,
  primary key (user_id, friend_id),
  foreign key (user_id) references users(user_id),
  foreign key (friend_id) references users(user_id)
);

delimiter //

create procedure sp_accept_friend_request (
  in p_request_id int,
  in p_to_user_id int
)
begin
  declare v_from_user int;
  declare v_status varchar(20);

  set transaction isolation level repeatable read;
  start transaction;

  select from_user_id, status
  into v_from_user, v_status
  from friend_requests
  where request_id = p_request_id
    and to_user_id = p_to_user_id
  for update;

  if v_from_user is null or v_status <> 'pending' then
    rollback;

  elseif exists (
    select 1 from friends
    where user_id = p_to_user_id
      and friend_id = v_from_user
  ) then
    rollback;

  else
    insert into friends (user_id, friend_id)
    values
      (p_to_user_id, v_from_user),
      (v_from_user, p_to_user_id);

    update users
    set friends_count = friends_count + 1
    where user_id in (p_to_user_id, v_from_user);

    update friend_requests
    set status = 'accepted'
    where request_id = p_request_id;

    commit;
  end if;
end;
//
delimiter ;
