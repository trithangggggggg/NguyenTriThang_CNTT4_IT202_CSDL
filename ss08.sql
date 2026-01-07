CREATE DATABASE mini_project_ss08;
USE mini_project_ss08;

-- Xóa bảng nếu đã tồn tại (để chạy lại nhiều lần)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;

-- Bảng khách hàng
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Bảng phòng
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

INSERT INTO guests (guest_name, phone) VALUES
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day) VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 1, '2024-01-10', '2024-01-12'), -- 2 ngày
(1, 3, '2024-03-05', '2024-03-10'), -- 5 ngày
(2, 2, '2024-02-01', '2024-02-03'), -- 2 ngày
(2, 5, '2024-04-15', '2024-04-18'), -- 3 ngày
(3, 4, '2023-12-20', '2023-12-25'), -- 5 ngày
(3, 6, '2024-05-01', '2024-05-06'), -- 5 ngày
(4, 1, '2024-06-10', '2024-06-11'); -- 1 ngày

select * from guests;
select * from rooms;
select * from bookings;

-- Phan 1
-- liet ke ten khach va so dien thoai cho tat ca khach hang 
select guest_name, phone from guests;
-- liet ke cac loai phong khac nhau trong ks
select distinct room_type from rooms;
-- hien thi loai phong va gia thue theo ngay tang dan
select   room_id, room_type, price_per_day from rooms
order by price_per_day asc;
-- hien thi cac phong co gia thue >= 1000000
select * from rooms
where price_per_day >= 1000000; 
-- liet ke cac lan dat phong dien ra trong nam 2024
select * from bookings 
where year(check_out) = 2024;
-- so luong phong cua tung loai phong
select room_type, COUNT(*) as 'SoLuong'
from Rooms group by room_type;

-- phan 2
-- liet ke danh sach cac lan dat phong 
select g.guest_name, r.room_type, b.check_in
from bookings b join guests g 
on b.guest_id = g.guest_id
join rooms r 
on b.room_id = r.room_id;
-- Cho biết mỗi khách đã đặt phòng bao nhiêu lần
select g.guest_name, COUNT(b.booking_id) as 'so_lan_dat'
from guests g left join bookings b 
on g.guest_id = b.guest_id
group by g.guest_name;
-- Tính doanh thu của mỗi phòng, với công thức: “Doanh thu = số ngày ở × giá thuê theo ngày”
select b.booking_id, r.room_id, (datediff(b.check_out, b.check_in) * r.price_per_day) as doanh_thu
from bookings b join rooms r 
on b.room_id = r.room_id;
-- Hiển thị tổng doanh thu của từng loại phòng
select r.room_type, sum(datediff(b.check_out, b.check_in) * r.price_per_day) as 'tong_doanh_thu'
from bookings b join rooms r 
on b.room_id = r.room_id
group by r.room_type;
-- 	Tìm những khách đã đặt phòng từ 2 lần trở lên
select g.guest_name, count(b.booking_id) as 'so_lan_dat'
from guests g join bookings b 
on g.guest_id = b.guest_id
group by g.guest_name
having count(b.booking_id) >= 2;
-- Tìm loại phòng có số lượt đặt phòng nhiều nhất
select r.room_type, count(*) as 'so_luot_dat'
from bookings b join rooms r 
on b.room_id = r.room_id
group by r.room_type
order by so_luot_dat desc
limit 1;

-- phan 3
-- Hiển thị những phòng có giá thuê cao hơn giá trung bình của tất cả các phòng
select * from rooms
where price_per_day > (select avg(price_per_day) from rooms);

-- Hiển thị những khách chưa từng đặt phòng
select g.guest_id , g.guest_name 
from guests g
where not exists (
    select 1
    from bookings bk
    where bk.guest_id = g.guest_id
);

-- tim nhieu nhat 
select room_id, count(*) as so_luot_dat
from bookings
group by room_id
having count(*) = (
    select max(so_luot)
    from (
        select count(*) as so_luot
        from bookings
        group by room_id
    ) as temp
);











