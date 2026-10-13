-- dim_table
create table dim_date(
date_id int auto_increment primary key,
full_date date,
year int,
month int,
month_name varchar(20),
quarter int,
day int,
week int);
-- dim_location
create table dim_location(
location_id int auto_increment primary key,
state varchar(100),
city varchar(100),
location varchar(100));
-- dim_restaurant
create table dim_restaurant(
restaurant_id int auto_increment primary key,
restaurant_name varchar(100));
-- dim_category
create table dim_category(
category_id int auto_increment primary key,
category varchar(100));
-- dim_dish
create table dim_dish(
dish_id int auto_increment primary key,
dish_name varchar(100)); 
-- fact table
create table fact_swiggyorders(
order_id int auto_increment primary key,
date_id int,
price_inr decimal(10,2),
rating decimal(4,2),
rating_count int,
location_id int,
restaurant_id int,
category_id int,
dish_id int,
foreign key(date_id) references dim_date(date_id),
foreign key(location_id) references dim_location(location_id),
foreign key(restaurant_id) references dim_restaurant(restaurant_id),
foreign key(category_id) references dim_category(category_id),
foreign key(dish_id) references dim_dish(dish_id)
);
-- INSERTING VALUES
-- dim_data values
insert into dim_date(full_date,year,month,month_name,quarter,day,week)
select distinct
order_date,
year(order_date),
month(order_date),
monthname(order_date),
quarter(order_date),
day (order_date),
week(order_date)
from swiggy_full
where order_date is not null;
/*select * from dim_date
-- dim_location value*/
insert into dim_location(state,city,location)
select distinct
state,city,location
from swiggy_full;
select * from dim_location;
-- dim_restaurant
insert into dim_restaurant(restaurant_name)
select distinct 
Restaurant_name
from swiggy_full;
select * from dim_restaurant;
-- dim_category 
insert into dim_category(category)
select distinct 
category
from swiggy_full;
select * from dim_category;
-- dim_dish
insert into dim_dish(dish_name)
select distinct dish_name from swiggy_full;
select * from dim_dish;

-- fact_swiggyorders
insert into fact_swiggyorders(date_id,price_inr,rating,rating_count,location_id,restaurant_id,category_id,dish_id)
select dd.date_id,s.price_inr,s.rating,s.rating_count,l.location_id,r.restaurant_id,c.category_id,d.dish_id
from swiggy_full s
join dim_date dd on dd.full_date=s.order_date
join dim_location l on l.state=s.state and l.city=s.city and l.location=s.location
join dim_restaurant r on r.restaurant_name=s.restaurant_name
join dim_category c on c.category=s.category
join dim_dish d on d.dish_name=s.dish_name ;
select * from fact_swiggyorders;

-- joinning fact and dimensional tables
select * from fact_swiggyorders f
join dim_date dd on f.date_id=dd.date_id
join dim_location l on f.location_id=l.location_id
join dim_restaurant r on f.restaurant_id=r.restaurant_id
join dim_category c on f.category_id=c.category_id
join dim_dish d on f.dish_id=d.dish_id;
select * from swiggy_full;
