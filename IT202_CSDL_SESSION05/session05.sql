create database session05;
use session05;

-- bai 1
create table products (
	product_id int auto_increment primary key,
    product_name varchar(255) not null,
    price decimal(10,2) not null,
    stock int not null,
    status enum('active', 'inactive')
);

insert into products (product_name, price, stock, status) values
('iphone 11', 900000,  100, 'inactive'),
('iphone 12', 1200000, 100, 'inactive'),
('iphone 13', 1500000, 100, 'active'),
('iphone 14', 2000000, 100, 'active'),
('iphone 15', 2500000, 100, 'active'),
('iphone 16', 3500000, 100, 'active');


select * from products;

select * from products 
where  status ='active';

select * from products
where price >= 200;

select * from products
where status = 'active'
order by price asc;

-- bai 2

create table customers (
	customer_id int auto_increment primary key,
    full_name varchar(255),
    email varchar(255),
    city varchar(255),
    status enum('active', 'inactive')
);

insert into customers(full_name, email, city, status) values
('Nguyen tri thang', 'trithang@gmail.com', 'Hcm', 'active'),
('Nguyen tuan minh', 'trithang@gmail.com', 'LC', 'inactive'),
('Vu viet tien', 'trithang@gmail.com', 'Hcm', 'active'),
('Pham Quoc Loc', 'trithang@gmail.com', 'HN', 'active');

select * from customers;

select * from customers
where city = 'Hcm';

select * from customers
where status = 'active'
and city = 'HN';

select * from customers
order by full_name asc;

-- bai 3
create table orders (
	order_id int auto_increment primary key,
    customer_id int,
    total_amount decimal(10,2),
    order_date date,
    status enum('pending', 'completed', 'cancelled')
);


insert into orders (customer_id, total_amount, order_date, status) values
(1, 3000000, '2024-01-01', 'completed'),
(2, 7000000, '2024-01-05', 'pending'),
(3, 9000000, '2024-01-10', 'completed'),
(1, 12000000, '2024-01-15', 'completed'),
(4, 2000000, '2024-01-20', 'cancelled'),
(2, 15000000, '2024-01-25', 'completed'),
(3, 4000000, '2024-02-01', 'pending');

select * from orders
where status = 'completed';

select * from orders
where total_amount > 5000000;

select * from orders
order by order_date desc
limit 5;

select * from orders
where status = 'completed'
order by total_amount desc;


-- bai 4
alter table products
add sold_quantity int;

update products set sold_quantity = 30  where product_id = 1;
update products set sold_quantity = 60  where product_id = 2;
update products set sold_quantity = 90  where product_id = 3;
update products set sold_quantity = 120 where product_id = 4;
update products set sold_quantity = 150 where product_id = 5;
update products set sold_quantity = 180 where product_id = 6;


select * from products;

select * from products
order by sold_quantity desc
limit 10;

select * from products
order by sold_quantity desc
limit 5 offset 10;

select * from products
where price < 2000000
order by sold_quantity desc;

select * from orders
where status != 'cancelled'
order by order_date desc
limit 5;

-- bai 5
select * from orders
where status != 'cancelled'
order by order_date desc
limit 5 offset 5;

select * from orders
where status != 'cancelled'
order by order_date desc
limit 5 offset 10;

-- bai 5
select * from products
where status = 'active'
and price between 1000000 and 3000000
order by price asc
limit 10;

select * from products
where status = 'active'
and price between 1000000 and 3000000
order by price asc
limit 10 offset 10;











