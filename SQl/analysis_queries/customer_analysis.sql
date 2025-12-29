create database customer_behaviour;

use customer_behaviour;



select * from customer;


-- Q1 what is the Total Revenue genrate by male vs female customers?

select gender,sum(purchase_amount) as total_revenue from customer
group by gender;


-- Q2 which customer used discount but still spent more than the average purchase amount ? 

select avg(purchase_amount) from customer;

select customer_id,purchase_amount from customer 
where discount_applied = 'yes' and purchase_amount > (select avg(purchase_amount) from customer);



-- Q3 which are the top 5 product with the heighest avg rating ? 

select * from customer;

select item_purchased,round(avg(review_rating),2) as avg_rating from customer 
group by item_purchased
order by avg_rating  desc
limit 5;


-- Q4 compare the  avg purchase  amount between express and standard shipping

select shipping_type,round(avg(purchase_amount),2) as avg_amount from customer 
where shipping_type in('Express','Standard')
group by shipping_type;



-- Q5 do subscribe customer spend more ? compare avg spent and total revenue between subsciber and non -sub 


select subscription_status,count(customer_id) as total_customer ,
avg(purchase_amount) as avg_amount,
sum(purchase_amount) as revenue_amount 
from customer
group by subscription_status
order by avg_amount,revenue_amount;


-- Q6 segement customer into new returning and loyal customer based on their total number of previous purchase and count od each segemnt 

select * from customer;

with customer_type as ( 
select customer_id,previous_purchases,
case 
    when previous_purchases = 1 then 'New'
    when previous_purchases between 2 and 10 then 'Returning'
    else 'Loyal'
    end customer_segment 
    from customer
    
)

select customer_segment,count(*) as total_customer from customer_type
group by customer_segment
order by total_customer desc;


-- Q7 what are the top  3 most purchase product within each category ? 

select * from customer;
with rnk_items as (
select category,item_purchased,count(customer_id) as total_orders,
row_number()over(partition by category order by count(customer_id) desc) as item_rnk
from customer
group by category,item_purchased)

select category,item_purchased,total_orders from rnk_items
where item_rnk <=3;



-- Q8 what is the revenue contribution by age group 

select * from customer;

select age_group,sum(purchase_amount) as total_revenue from customer 
group by age_group
order by total_revenue desc;



-- Q9 revenue genrate by top 2 season and location ?

with rnk_by_season as (
select location,season,sum(purchase_amount) as total_revenue,
row_number() over(partition by season order by sum(purchase_amount) desc) as rnk_season 
from customer
group by location,season 
)

select season,location,total_revenue from rnk_by_season 
where  rnk_season <= 2
group by season,location;








