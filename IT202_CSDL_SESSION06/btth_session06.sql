CREATE DATABASE homework;
USE homework;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, full_name, city) VALUES
(1, 'Nguyễn Trí Thắng', 'Hải Dương'),
(2, 'Nguyễn Quốc Hưng', 'Hưng Yên'),
(3, 'Lê Văn Luyện', 'Hưng Yên'),
(4, 'Phạm Hồng Nhung', 'Hưng Yên'),
(5, 'Hoàng Văn Quân', 'Hải Phòng');

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(101, 1, '2025-01-01', 'completed'),
(102, 1, '2025-01-05', 'pending'),
(103, 2, '2025-01-03', 'completed'),
(104, 3, '2025-01-06', 'cancelled'),
(105, 4, '2025-01-07', 'completed');

SELECT 
    o.order_id,
    c.full_name,
    c.city,
    o.order_date,
    o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT DISTINCT
    c.customer_id,
    c.full_name,
    c.city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;















