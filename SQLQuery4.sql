--  total sales
select sum(sales) 'total sales' 
from Orders ;
--=============================================================================
--  total profit
select sum(profit) 'total profit' 
from Orders ;
--=============================================================================
-- profit margin 
select (cast((sum(sales)/sum(profit)) as decimal(10,1)))
from Orders;
--=============================================================================
-- total sold 
select sum(quantity_ordered) 'total sold',category_name
from Orders as o
left join Products p on o.product_id = p.product_id
join Categories c on c.category_id = p.category_id
group by category_name
order by 'total sold' desc;
--=============================================================================
-- proudct not sold
select sum(quantity_ordered) 'total sold',product_name
from Orders o
right join Products p on o.product_id = p.product_id
join Categories c on c.category_id = p.category_id
where o.product_id is null
group by product_name
order by 'total sold' asc;           -->>>>>> all proudcts are sold <<<<<<--
--=============================================================================
--top 5 proudct 
select top 5
sum(o.sales) as sales,
sum(o.profit) as profit,
count(o.order_id) as order_count,          
avg(o.discount_amount) as avg_discount,
max(p.product_price) over (partition by p.category_id) as max_category_price,
p.product_price,
p.category_id,
p.product_name
from Orders o
join Products p on p.product_id=o.product_id
group by p.product_name, p.product_price ,p.category_id 
order by sales desc 
;
--=============================================================================
-- avg sales by customer segmant
select avg(o.sales) 'avg sales' ,
sum(o.sales) 'total sales',
avg(p.product_price) 'avg product price',
c.customer_segment
from Orders o
join Products p on p.product_id = o.product_id 
left join Customers c on c.customer_id = o.customer_id
group by c.customer_segment
order by 'total sales' desc ;



