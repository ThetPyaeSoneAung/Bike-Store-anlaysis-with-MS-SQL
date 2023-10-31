
-- Total Revenue By Year
SELECT DATEPART(year,order_date) AS Year FROM sales.orders;
SELECT SUM(list_price*quantity) AS Revenue FROM sales.order_items;

SELECT
    DATEPART(year,o.order_date) AS Year,
    (SELECT SUM(oi.list_price * oi.quantity) FROM sales.order_items oi) AS Revenue
FROM
    sales.orders o
JOIN sales.order_items oi ON o.order_id=oi.order_id
GROUP BY DATEPART(year,o.order_date)
ORDER BY Year;

---Revenue By month (Year Filter)

SELECT
    DATEPART(year, o.order_date) AS Year,
    DATEPART(month, o.order_date) AS Month,
    DATENAME(month, DATEFROMPARTS(DATEPART(year, o.order_date), DATEPART(month, o.order_date), 1)) AS MonthName,
    SUM(oi.list_price * oi.quantity) AS Revenue
FROM
    sales.orders o
JOIN
    sales.order_items oi ON o.order_id = oi.order_id
WHERE
    DATEPART(year, o.order_date) IN (2016, 2017, 2018)
GROUP BY
    DATEPART(year, o.order_date),
    DATEPART(month, o.order_date),
    DATENAME(month, DATEFROMPARTS(DATEPART(year, o.order_date), DATEPART(month, o.order_date), 1))
ORDER BY
    Year, Month;

--Total Revenue By Products
SELECT
	DATEPART(year, ord.order_date) AS Year,
	CONCAT(cus.first_name, ' ', cus.last_name) AS Name,
	SUM(ord_item.list_price * ord_item.quantity) AS Revenue,
	prod.product_name,
	cat.category_name,
	cus.city,
	cus.state,
	ord.order_date,
	prod.product_name,
	cat.category_name,
	brands.brand_name,
	store.store_name
FROM sales.customers cus
JOIN sales.orders ord ON cus.customer_id = ord.customer_id
JOIN sales.order_items ord_item ON ord.order_id = ord_item.order_id 
JOIN production.products prod ON prod.product_id = ord_item.product_id
JOIN production.categories cat ON cat.category_id = prod.category_id
JOIN sales.stores store ON store.store_id = ord.store_id
JOIN sales.staffs staff ON staff.staff_id = ord.staff_id
JOIN production.brands brands ON brands.brand_id = prod.brand_id
GROUP BY DATEPART(year, ord.order_date),CONCAT(cus.first_name,' ',cus.last_name),ord.order_id,prod.product_name,cat.category_name,cus.city,cus.state,ord.order_date,prod.product_name,cat.category_name,
	brands.brand_name,
	store.store_name;

--Top 10 customers with Max Revenue 
SELECT 
DATEPART(year,ord.order_date) AS Year,
CONCAT(cus.first_name, ' ', cus.last_name) AS Name 
FROM sales.customers cus
JOIN sales.orders ord ON cus.customer_id = ord.customer_id
GROUP BY DATEPART(year,ord.order_date),CONCAT(cus.first_name,' ',cus.last_name); 






