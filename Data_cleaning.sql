/*blank or empty strings*/
select * from swiggy_full
where state = '' or city = '' or Restaurant_Name = '' or location = '' or category = ''
or Dish_Name = '' or Price_INR = '' or Rating = '' or Rating_Count = '';
/* duplicate detection*/
/*select State,City,order_date,Restaurant_Name,Location,Category,Dish_Name,Price_INR,Rating,Rating_Count,count(*) as count
from swiggy_full
group by State,City,order_date,Restaurant_Name,Location,Category,Dish_Name,Price_INR,Rating,Rating_Count
having count(*) > 1*/
/*another way to detect duplicates*/
SELECT Restaurant_Name, Dish_Name, order_date, COUNT(*) 
FROM swiggy_full
GROUP BY Restaurant_Name, Dish_Name, order_date
HAVING COUNT(*) > 1;
/*delete duplicates*/
-- Step 1: Temporarily disable safe updates if MySQL Workbench blocks the delete
SET SQL_SAFE_UPDATES = 0;

-- Step 2: Use the CTE combined with a JOIN to delete duplicates
WITH cte AS (
    SELECT *, 
           ROW_NUMBER() OVER( 
               PARTITION BY State, City, order_date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count 
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM swiggy_full
)
DELETE t1 
FROM swiggy_full t1
INNER JOIN cte t2 
	ON  t1.State = t2.State
    AND t1.City = t2.City
    AND t1.order_date = t2.order_date
    AND t1.Restaurant_Name = t2.Restaurant_Name
    AND t1.Location = t2.Location
    AND t1.Category = t2.Category
    AND t1.Dish_Name = t2.Dish_Name
    AND t1.Price_INR = t2.Price_INR
    AND t1.Rating = t2.Rating
    AND t1.Rating_Count = t2.Rating_Count
WHERE t2.rn > 1;

-- Step 3: Re-enable safe updates
SET SQL_SAFE_UPDATES = 1;
select * from swiggy_full;
