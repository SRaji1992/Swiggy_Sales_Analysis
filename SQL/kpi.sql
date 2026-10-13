-- Total orders
select count(*) as Total_orders
from fact_swiggyorders;
-- total revenue
select sum(price_inr) as Total_Revenue
from fact_swiggyorders;
-- total_revenue in format
select CONCAT(FORMAT(SUM(CAST(price_inr AS DECIMAL(15,2))) / 1000000, 2), ' INR Million')
as Total_Revenue
from fact_swiggyorders;
-- Average dish_price
select concat(format(avg(cast(price_inr as decimal(10,2))),2),'INR')
as Average_Dish_Price
from fact_swiggyorders;
-- Average Rating
select format(avg(cast(rating as decimal(10,2))),2) as Average_Rating
from fact_swiggyorders;
-- Monthly order trends
select d.year,d.month,d.month_name,count(*) as Total_orders
from fact_swiggyorders f
join dim_date d on d.date_id=f.date_id
group by d.year,d.month,d.month_name
order by count(*) desc;
-- quarterly trends
select d.year,d.quarter,count(*) as Total_orders
from fact_swiggyorders f
join dim_date d on d.date_id=f.date_id
group by d.year,d.quarter
order by count(*) desc;
-- yearly trends
select d.year,count(*) as Total_orders
from fact_swiggyorders f
join dim_date d on d.date_id=f.date_id
group by d.year;
-- week day trends
select dayname(d.full_date) as day_name,count(*) as total_orders
from fact_swiggyorders f 
join dim_date d on d.date_id=f.date_id
group by  dayname(d.full_date)
order by count(*) desc;
-- top 10 cities by order 
select l.city, count(*) as Total_orders
from fact_swiggyorders f
join dim_location l on l.location_id=f.location_id 
group by l.city
order by Total_orders desc
limit 10;
-- top 10 cities by total revenue
select l.city, sum(price_inr) as Total_Revenue
from fact_swiggyorders f
join dim_location l on l.location_id=f.location_id 
group by l.city
order by Total_Revenue desc
limit 10;
-- Revenue contribution by States
select l.state, sum(price_inr) as Total_Revenue
from fact_swiggyorders f
join dim_location l on l.location_id=f.location_id 
group by l.state
order by Total_Revenue desc
limit 10;
-- FOOD PERFORMANCES
-- Top 10 restaurants by revenue
select r.Restaurant_Name, sum(price_inr) as Total_revenue
from fact_swiggyorders f 
join dim_restaurant r on r.restaurant_id = f.restaurant_id
group by r.restaurant_name
order by Total_revenue desc
limit 10;
-- top categories by order volume
select c.category,count(*) as total_orders
from fact_swiggyorders f
join dim_category c on c.category_id = f.category_id
group by c.category
order by total_orders desc
limit 10;
-- Most ordered dish
select d.dish_name, count(*) as Order_count
from fact_swiggyorders f
join dim_dish d on d.dish_id=f.dish_id
group by d.dish_name
order by Order_count desc
limit 10;
-- Cuisine Performances
select c.category, count(*) as Total_orders,avg(f.rating) as Average_rating
from fact_swiggyorders f 
join dim_category c on c.category_id=f.category_id
group by c.category
order by Total_orders desc
limit 15;
-- CUSTOMER SPENDING INSIGHTS
-- Total orders by price range
select 
case 
when Price_Inr < 100 then 'Under 100'
when price_inr between 100 and 199 then '100 - 199'
when price_inr between 200 and 299 then '200 - 299'
when price_inr between 300 and 399 then '300 - 399'
when price_inr between 400 and 499 then '400 - 499'
else '500+'
end as Price_range,
count(*) as Total_orders
from fact_swiggyorders
group by
case 
when Price_Inr < 100 then 'Under 100'
when price_inr between 100 and 199 then '100 - 199'
when price_inr between 200 and 299 then '200 - 299'
when price_inr between 300 and 399 then '300 - 399'
when price_inr between 400 and 499 then '400 - 499'
else '500+'
end
order by Total_orders desc;
-- RATING ANALYSIS
select rating,count(*) as rating_count
from fact_swiggyorders
group by rating
order by rating_count desc;



