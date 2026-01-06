create database session07;
use session07;

create table customers (
    id int auto_increment primary key,
    name varchar(100) not null,
    email varchar(100) unique not null
);

create table orders (
    id int auto_increment primary key,
    customer_id int not null,
    order_date date not null,
    total_amount decimal(10,2) not null,
    foreign key (customer_id) references customers(id)
);

create table products (
    id int auto_increment primary key,
    name varchar(100) not null,
    price decimal(10,2) not null
);

create table order_items (
    order_id int not null,
    product_id int not null,
    quantity int not null check (quantity > 0)
);

insert into customers (name, email) values
('nguyen thi lan', 'lan@gmail.com'),
('nguyen van minh', 'minh@gmail.com'),
('nguyen hoang nam', 'nam@gmail.com'),
('nguyen thi thu', 'thu@gmail.com'),
('nguyen quang huy', 'huy@gmail.com'),
('nguyen thi mai', 'mai@gmail.com'),
('nguyen van long', 'long@gmail.com');

insert into orders (customer_id, order_date, total_amount) values
(1, '2024-05-10', 1800000),
(1, '2024-06-20', 2500000),
(2, '2024-07-02', 1200000),
(3, '2024-07-06', 1450000),
(4, '2024-07-15', 760000),
(2, '2024-07-18', 1950000),
(5, '2024-07-22', 990000);

insert into products (name, price) values
('iphone 19 pro mãx ', 21000000),
('samsung galaxy s22', 19500000),
('macbook pro m1', 26000000),
('asus rog strix ', 24000000),
('ipad air', 18000000),
('airpods 2', 4500000),
('smart watch', 9500000);

insert into order_items (order_id, product_id, quantity) values
(1, 1, 1),
(1, 3, 1),
(2, 2, 2),
(2, 5, 1),
(3, 1, 1),
(3, 6, 2),
(4, 4, 1);

-- bai 01
select * 
from customers 
where id in (select customer_id from orders);

-- bai 02
select * 
from products 
where id in (select product_id from order_items);

-- bai 03
select * 
from orders 
where total_amount > (
    select avg(total_amount) 
    from orders
);

-- bai 04
select 
    name as customer_name,
    (select count(*) from orders where orders.customer_id = customers.id) as total_orders
from customers;

-- bai 05
select * 
from customers 
where id in (
    select customer_id 
    from orders 
    group by customer_id
    having sum(total_amount) = (
        select max(total_spent) 
        from (
            select sum(total_amount) as total_spent 
            from orders 
            group by customer_id
        ) as temp
    )
);

-- bai 06
select customer_id 
from orders 
group by customer_id 
having sum(total_amount) > (
    select avg(total_spent) 
    from (
        select sum(total_amount) as total_spent
        from orders
        group by customer_id
    ) as total
);
