
SELECT * FROM coffee_shop_sales;


alter table coffee_shop_sales
change column transaction_id trans_id int;
describe coffee_shop_sales;


-- calculate total sales for each respective month
SELECT round(sum(transaction_qty * unit_price)) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 5; -- for May month


-- determine month on month increase or decrease in sale
select month(transaction_date) as Month,
round(sum(transaction_qty * unit_price)) as Total_sales,
sum(transaction_qty * unit_price)-lag(sum(transaction_qty * unit_price),1) over (order by (month(transaction_date))) /
lag(sum(transaction_qty * unit_price),1) over (order by (month(transaction_date))) * 100 as percentage_change
from coffee_shop_sales
where month(transaction_date) in (4,5) -- for month April (PM) and May (CM)
group by month(transaction_date)
order by month(transaction_date);


-- total number of orders for respective months
select count(trans_id)
from coffee_shop_sales
where month(transaction_date) = 5; -- for May month


-- determine month on month increase or decrease in orders
select month(transaction_date) as Month,
count(trans_id) as Orders,
(count(trans_id)-lag(count(trans_id),1) over (order by month(transaction_date)))/
lag(count(trans_id),1) over (order by month(transaction_date)) * 100 as percentage_change
from coffee_shop_sales
where month(transaction_date) in (4,5)
group by month(transaction_date)
order by month(transaction_date);


-- total qty sold for respective months
select sum(transaction_qty) as Total_qty
from coffee_shop_sales
where month(transaction_date) = 5;


-- determine month on month increase or decrease in qty
select month(transaction_date) as Month,
sum(transaction_qty) as Total_Qty,
(sum(transaction_qty)-lag(sum(transaction_qty),1)over(order by month(transaction_date))) /
lag(sum(transaction_qty),1)over(order by month (transaction_date)) * 100 as percent_change
from coffee_shop_sales
where month(transaction_date) in (4,5)
group by month(transaction_date)
order by month(transaction_date);


-- calender daily sales, qty and count of orders
select sum(transaction_qty * unit_price) as Total_sales,
count(trans_id) as Total_orders,
sum(transaction_qty) as Total_qty
from coffee_shop_sales
where transaction_date = '2023-05-18';

-- weekday and weekend sales
select 
	case when dayofweek(transaction_date) in (1,7) then 'WeekEnd'
    else 'Weekday'
    end as day_type,
   concat(round(sum(transaction_qty * unit_price)/1000,1),'K') as Total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by 
	case when dayofweek(transaction_date) in (1,7) then 'WeekEnd'
    else 'WeekDay'
    end;
    
-- store locationwise sales
select 
	store_location,
    round(sum(unit_price * transaction_qty),1) as Total_sales
from coffee_shop_sales
where 
	month(transaction_date) = 5
group by 
	store_location
order by
	sum(unit_price * transaction_qty) desc;

-- daily sales with average of sales
select
	avg(Total_sales) as Average_sales
from
	(select 
		round(sum(transaction_qty * unit_price),2) as Total_sales
	from 
		coffee_shop_sales
	where 
		month(transaction_date) = 5
	group by
		transaction_date) as Internal_query;
        
-- daily sale 
select
	day(transaction_date) as day_of_month,
    round(sum(transaction_qty * unit_price),2) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by day(transaction_date)
order by day(transaction_date);
    
    
-- checking daily sales are above average or not
select
	day_of_month,Total_sales,
    case when Total_sales > avg_sales then 'Above Averare'
		 when Total_sales < avg_sales then 'Below Average'
         else 'Equal_to_Average'
         end as sales_status
from 
	(select day(transaction_date) as day_of_month,
			sum(transaction_qty * unit_price) as Total_sales,
            avg(transaction_qty * unit_price) over () as avg_sales
	from coffee_shop_sales
    where month(transaction_date) = 5
    group by day(transaction_date)) as sales_data
    order by day_of_month;
    
    
    -- sales by product category
select 
		product_category,
        sum(transaction_qty * unit_price) as total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by product_category
order by sum(transaction_qty * unit_price) desc;
    
    
    -- sales by top 10 product type
select 
		product_type,
        sum(transaction_qty * unit_price) as total_sales
from coffee_shop_sales
where month(transaction_date) = 5
group by product_type
order by sum(transaction_qty * unit_price) desc
limit 10;


  -- sales by top 10 product type and product category
select 
		product_type,
        sum(transaction_qty * unit_price) as total_sales
from coffee_shop_sales
where month(transaction_date) = 5 and product_category = 'Coffee'
group by product_type
order by sum(transaction_qty * unit_price) desc
limit 10;


-- sales analysis by days and hours
select
	sum(transaction_qty * unit_price) as Total_sales,
    sum(transaction_qty) as Total_Qty_Sold,
    count(*) as Total_Orders
from coffee_shop_sales
where month(transaction_date) = 5 -- may month 
and dayofweek(transaction_date) = 2 -- on Monday
and hour(transaction_time) = 8; -- ate time 8.0 am


-- hours wise sales
select 
	hour(transaction_time),
    sum(transaction_qty*unit_price) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 5   -- month of may
group by hour(transaction_time)
order by hour(transaction_time);


-- daywise sales
select
	case when dayofweek(transaction_date) = 2 then 'Monday'
		 when dayofweek(transaction_date) = 3 then 'Tuesday'
		 when dayofweek(transaction_date) = 4 then 'Wednesday'
		 when dayofweek(transaction_date) = 5 then 'Thursday'
		 when dayofweek(transaction_date) = 6 then 'Friday'
		 when dayofweek(transaction_date) = 7 then 'Saturnday'
		 else 'Sunday'
         end as day_of_week,
	sum(transaction_qty * unit_price) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 5 -- month may
group by
		case when dayofweek(transaction_date) = 2 then 'Monday'
		 when dayofweek(transaction_date) = 3 then 'Tuesday'
		 when dayofweek(transaction_date) = 4 then 'Wedsenday'
		 when dayofweek(transaction_date) = 5 then 'Thursday'
		 when dayofweek(transaction_date) = 6 then 'Friday'
		 when dayofweek(transaction_date) = 7 then 'Saturnday'
		 else 'Sunday'
         end;