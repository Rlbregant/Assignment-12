create database if not exists pizza_restaurant;

use pizza_restaurant;

drop table if exists Order_Items;
drop table if exists Pizzas;
drop table if exists Orders;
drop table if exists Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_datetime DATETIME NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES Customers (customer_id)
);

CREATE TABLE Pizzas (
    pizza_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(6 , 2 ) NOT NULL
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    pizza_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES Orders (order_id),
    FOREIGN KEY (pizza_id)
        REFERENCES Pizzas (pizza_id)
);

insert into Customers (name, phone_number) values
  ('Trevor Page', '226-555-4982'),
  ('John Doe', '555-555-9498');

insert into Pizzas (name, price) values
  ('Pepperoni & Cheese', 7.99),
  ('Vegetarian', 9.99),
  ('Meat Lovers', 14.99),
  ('Hawaiian', 12.99);

insert into Orders (customer_id, order_datetime) values
  (1, '2014-09-10 09:47:00'),
  (2, '2014-09-10 13:20:00');

set @order_id := last_insert_id();

insert into Order_Items (order_id, pizza_id, quantity) values (@order_id, 1, 1);

set @order_item_id := last_insert_id();

insert into Order_Items (order_id, pizza_id, quantity) values (@order_id, 3, 1);

insert into Orders (customer_id, order_datetime) values
  (1, '2014-09-10 09:47:00');

set @order_id := last_insert_id();

insert into Order_Items (order_id, pizza_id, quantity) values (@order_id, 3, 1);

insert into Order_Items (order_id, pizza_id, quantity) values (@order_id, 4, 1);

insert into Orders (customer_id, order_datetime) values
  (2, '2014-09-10 13:20:00');

set @order_id := last_insert_id();

insert into Order_Items (order_id, pizza_id, quantity) values (@order_id, 2, 1);

insert into Order_Items (order_id, pizza_id, quantity) values (@order_id, 3, 2);

insert into Orders (customer_id, order_datetime) values
  (1, '2014-09-10 09:47:00');

-- --Q4
SELECT 
    c.name,
    c.phone_number,
    SUM(p.price * oi.quantity) AS total_spent
FROM
    Customers c
        JOIN
    Orders o ON c.customer_id = o.customer_id
        JOIN
    Order_Items oi ON o.order_id = oi.order_id
        JOIN
    Pizzas p ON oi.pizza_id = p.pizza_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

-- Q5
SELECT 
    c.name AS customer_name,
    c.phone_number,
    DATE(o.order_datetime) AS order_date,
    SUM(oi.quantity * p.price) AS total_spent
FROM
    Customers c
        INNER JOIN
    Orders o ON c.customer_id = o.customer_id
        INNER JOIN
    Order_Items oi ON o.order_id = oi.order_id
        INNER JOIN
    Pizzas p ON oi.pizza_id = p.pizza_id
GROUP BY c.customer_id , DATE(o.order_datetime)
ORDER BY c.customer_id , DATE(o.order_datetime);