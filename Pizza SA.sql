create database sales_agg;

create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id) ); 

create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id varchar(255), 
quantity int,
primary key(order_details_id));  

-- Retrieve the total number of orders placed. 
select count(order_id) as Total_Orders_Placed from orders; 

-- Calculate the total revenue generated from pizza sales 
select round(sum(price*order_details.quantity),2) as Total_Revenue 
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.
select pizza_types.name as Highest_Priced_Pizza
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
where pizzas.price = (SELECT MAX(price) FROM pizzas);  

-- Identify the most common pizza size ordered 
select pizzas.size, count(order_details.quantity) as order_quantity 
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_quantity desc;  

-- List the top 5 most ordered pizza types along with their quantities 
select pizza_types.name, sum(order_details.quantity) as tot_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by tot_quantity desc limit 5; 

-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category , sum(order_details.quantity) as tot_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by tot_quantity desc; 

-- Determine the top 3 most ordered pizza types based on revenue.
 select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue
 from pizzas join order_details
 on pizzas.pizza_id = order_details.pizza_id
 join pizza_types 
 on pizza_types.pizza_type_id = pizzas.pizza_type_id
 group by pizza_types.name order by revenue desc limit 3;  
 
-- Join relevant tables to find the category-wise distribution of pizzas.
 select category,count(name) as dist 
 from pizza_types 
 group by category order by dist desc;   
 
-- Determine the distribution of orders by hour of the day. 
select hour(order_time) as hours, count(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by hours order by quantity desc;  

-- Group the orders by date and calculate the average number of pizzas ordered per day
select month(orders.order_date) as Month, avg(order_details.quantity) as avg_sales
from orders join order_details
on orders.order_id = order_details.order_id
group by Month order by avg_sales desc; 

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category 
select pizza_types.category as Cat, 
round(sum(pizzas.price*order_details.quantity)/(select round(sum(pizzas.price*order_details.quantity),2) from pizzas join order_details on pizzas.pizza_id = order_details.pizza_id )*100,2) as reveneu
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by Cat order by reveneu desc limit 3; 
 
 -- Analyze the cumulative revenue generated over time
select monthname(order_date) as Month, round(sum(order_details.quantity*pizzas.price),2) as Revenue 
from order_details join orders
on order_details.order_id = orders.order_id
join pizzas
on order_details.pizza_id = pizzas.pizza_id
group by Month order by Revenue; 

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category
select pizza_types.category as cat, round(sum(order_details.quantity*pizzas.price),2) as Revenue 
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by cat order by Revenue desc limit 3; 

 -- Pizza size contribution to sales  
 select pizzas.size as Size, round(sum(pizzas.price*order_details.quantity),2) as Revenue
 from pizzas join order_details
 on pizzas.pizza_id = order_details.pizza_id
 group by Size order by Revenue desc;
 