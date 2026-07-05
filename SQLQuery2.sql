-- جدول العملاء
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(150),
    customer_segment VARCHAR(50),
    customer_country VARCHAR(50),
    customer_state VARCHAR(50),
    customer_city VARCHAR(100),
    customer_street VARCHAR(255),
    customer_zipcode INT
);

-- جدول الفئات والأقسام
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100),
    department_id INT,
    department_name VARCHAR(100)
);

-- جدول المنتجات
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    product_price DECIMAL(10,2),
    product_status INT,
    category_id INT FOREIGN KEY REFERENCES Categories(category_id)
);

-- جدول الطلبات والمبيعات  
CREATE TABLE Orders (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
    order_date DATETIME,
    order_status VARCHAR(50),
    order_city VARCHAR(100),
    order_country VARCHAR(100),
    order_region VARCHAR(100),
    sales DECIMAL(10,2),
    quantity_ordered INT,
    order_item_total DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    profit DECIMAL(10,2)
);

-- جدول الشحن واللوجستيات
CREATE TABLE Shipments (
    order_item_id INT PRIMARY KEY FOREIGN KEY REFERENCES Orders(order_item_id),
    order_id INT,
    shipping_mode VARCHAR(50),
    days_shipping_real INT,
    days_shipping_scheduled INT,
    shipping_date DATETIME,
    delivery_status VARCHAR(50),
    late_delivery_risk INT
);


-- =====================================================================
--  توزيع البيانات
-- =====================================================================

--  بيانات العملاء
INSERT INTO Customers (customer_id, customer_name, customer_segment, customer_country, customer_state, customer_city, customer_street, customer_zipcode)
SELECT DISTINCT 
    [Customer_Id], 
    [Customer_name], 
    [Customer_Segment], 
    [Customer_Country], 
    [Customer_State], 
    [Customer_City], 
    [Customer_Street], 
    [Customer_Zipcode]
FROM Book1;

--  بيانات الفئات والأقسام
INSERT INTO Categories (category_id, category_name, department_id, department_name)
SELECT DISTINCT 
    [Category_Id], 
    [Category_Name], 
    [Department_Id], 
    [Department_Name]
FROM Book1;

--  بيانات المنتجات
INSERT INTO Products (product_id, product_name, product_price, product_status, category_id)
SELECT DISTINCT 
    [Product_Card_Id], 
    [Product_Name], 
    [Product_Price], 
    [Product_Status], 
    [Category_Id]
FROM Book1;

--  بيانات الطلبات 
INSERT INTO Orders (order_item_id, order_id, customer_id, product_id, order_date, order_status, order_city, order_country, order_region, sales, quantity_ordered, order_item_total, discount_amount, profit)
SELECT 
    [Order_Item_Id], 
    [Order_Id], 
    [Order_Customer_Id], 
    [Product_Card_Id], 
    TRY_CAST([order_date_DateOrders] AS DATETIME), 
    [Order_Status], 
    [Order_City], 
    [Order_Country], 
    [Order_Region], 
    [Sales], 
    [Order_Item_Quantity], 
    [Order_Item_Total], 
    [Order_Item_Discount], 
    [Order_Profit_Per_Order]
FROM Book1;

--  بيانات الشحن 
INSERT INTO Shipments (order_item_id, order_id, shipping_mode, days_shipping_real, days_shipping_scheduled, shipping_date, delivery_status, late_delivery_risk)
SELECT 
    [Order_Item_Id], 
    [Order_Id], 
    [Shipping_Mode], 
    [Days_for_shipping_real], 
    [Days_for_shipment_scheduled], 
    TRY_CAST([shipping_date_DateOrders] AS DATETIME), 
    [Delivery_Status], 
    [Late_delivery_risk]
FROM Book1;

--=====================================================================
--factors of delay
select sum(s.late_delivery_risk) as total ,
c.category_name ,
o.order_region ,
s.shipping_mode
from Shipments as s
join Orders as o on s.order_item_id=o.order_item_id
join Products as p on p.product_id = o.product_id
join Categories as c on c.category_id=p.category_id
where s.late_delivery_risk = 1
group by c.category_name ,o.order_region ,s.shipping_mode
order by total desc
;
--=====================================================================
--shipping mode effect on delay
select count(s.late_delivery_risk) T,
s.shipping_mode
from Shipments as s
where s.late_delivery_risk =1
group by s.shipping_mode
order by T desc;
--=====================================================================
--category effect on delay
select count(s.late_delivery_risk) T,
c.category_name
from Shipments as s
join Orders as o on s.order_item_id=o.order_item_id
join Products as p on p.product_id = o.product_id
join Categories as c on c.category_id=p.category_id
where s.late_delivery_risk =1
group by c.category_name
order by T desc
;
--=====================================================================
--region effect on delay
select count(s.late_delivery_risk) T,
o.order_region
from Shipments as s
join Orders as o on s.order_item_id=o.order_item_id
where s.late_delivery_risk =1
group by o.order_region
order by T desc
;
--=====================================================================
--lost profit
select sum(o.profit) as 'lost profit' ,
s.shipping_mode 
from Shipments as s
join Orders as o on s.order_item_id=o.order_item_id
where s.shipping_mode='Standard class' and s.late_delivery_risk =1
group by s.shipping_mode
;

--=====================================================================


