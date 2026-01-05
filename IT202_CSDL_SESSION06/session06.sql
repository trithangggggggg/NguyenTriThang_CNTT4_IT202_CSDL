create database session6;
use session06;


-- bai 1
create table customers(
	customer_id int auto_increment primary key,
    full_name varchar(255),
    city varchar(255)
);

create table orders(
	order_id int auto_increment primary key,
    customer_id int not null,
    order_date date not null,
    status enum('pending', 'completed', 'cancelled')
);

insert into customers (full_name, city) values
('Nguyen tri thang','HD'),
('Nguyen viet tien','NB'),
('Nguyen tuan minh','LC'),
('Nguyen quoc loc','HN'),
('Nguyen xuan khanh','HY');


insert into orders (customer_id, order_date, status) values
(1, '2024-01-10', 'completed'),
(1, '2024-02-05', 'pending'),
(2, '2024-01-20', 'completed'),
(3, '2024-03-01', 'cancelled'),
(3, '2024-03-15', 'completed');


select * from customers;
select * from orders;

select o.order_id, c.full_name, o.order_date, o.status 
from orders o join customers c 
on o.customer_id = c.customer_id ;

-- moi khach hang dat bao nhieu on hang
select c.customer_id, c.full_name, COUNT(o.order_id) as 'total_orders'
from customers c left join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

-- hien thi khach hang co >= 1 don 
select c.customer_id, c.full_name, COUNT(o.order_id) as total_orders
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.full_name
having COUNT(o.order_id) >= 1;

-- bai 2 
alter table orders
add total_amount decimal(10,2);

update orders set total_amount = 1500000 where order_id = 1;
update orders set total_amount = 800000  where order_id = 2;
update orders set total_amount = 1200000 where order_id = 3;
update orders set total_amount = 500000  where order_id = 4;
update orders set total_amount = 2000000 where order_id = 5;

-- tong tien da tieu 
select  c.customer_id, c.full_name, sum(o.total_amount) as total_spent
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

-- don hang cao nhat 
select c.customer_id, c.full_name, max(o.total_amount) as max_order_value
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

-- sap xep giam dan tien 
select c.customer_id, c.full_name, sum(o.total_amount) as total_spent
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.full_name
order by total_spent desc;

-- bai 3 
-- tong doanh thu 
select  order_date, sum(total_amount) as total_revenue
from orders
where status = 'completed'
group by order_date;

-- luong don 1 ngay 
select order_date, count(order_id) as total_orders
from orders
where status = 'completed'
group by order_date;

-- >= 10000000
select order_date, sum(total_amount) as total_revenue,
count(order_id) as total_orders
from orders
where status = 'completed'
group by order_date
having sum(total_amount) > 10000000;


-- bai 4
create table products (
    product_id int auto_increment primary key,
    product_name varchar(255),
    price decimal(10,2)
);

create table order_items (
    order_id int,
    product_id int,
    quantity int,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

insert into products (product_name, price) values
('laptop dell', 15000000),
('chuot logitech', 500000),
('ban phim co', 1200000),
('man hinh lg', 7000000),
('tai nghe sony', 2500000);

insert into order_items (order_id, product_id, quantity) values
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 1),
(3, 5, 2);

-- san pham ban duoc 
select p.product_id,  p.product_name, sum(oi.quantity) as total_quantity_sold
from products p join order_items oi
on p.product_id = oi.product_id
group by p.product_id, p.product_name;

-- doanh thu moi san pham
select p.product_id, p.product_name, sum(oi.quantity * p.price) as revenue
from products p join order_items oi
on p.product_id = oi.product_id
group by p.product_id, p.product_name;

-- san pham doanh thu >= 5000000
select p.product_id, p.product_name, sum(oi.quantity * p.price) as revenue
from products p join order_items oi
on p.product_id = oi.product_id
group by p.product_id, p.product_name
having sum(oi.quantity * p.price) > 5000000;


-- bai 5
select 
    c.customer_id,
    c.full_name,
    count(o.order_id) as total_orders,
    sum(o.total_amount) as total_spent,
    avg(o.total_amount) as avg_order_value
from customers c
join orders o
    on c.customer_id = o.customer_id
where o.status = 'completed'
group by c.customer_id, c.full_name
having 
    count(o.order_id) >= 3
    and sum(o.total_amount) > 10000000
order by total_spent desc;


-- bai 6 
select 
    p.product_name,
    sum(oi.quantity) as total_quantity_sold,
    sum(oi.quantity * p.price) as total_revenue,
    avg(p.price) as avg_price 
from products p
join order_items oi
    on p.product_id = oi.product_id
join orders o
    on oi.order_id = o.order_id
where o.status = 'completed'
group by p.product_id, p.product_name
having sum(oi.quantity) >= 10
order by total_revenue desc
limit 5;




