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

--Highest Revenue By State
SELECT store.state,DATEPART(year,ord.order_date) AS Year,
SUM(ord_item.list_price * ord_item.quantity) AS Revenue
FROM sales.customers cus
JOIN sales.orders ord ON cus.customer_id = ord.customer_id
JOIN sales.order_items ord_item ON ord.order_id = ord_item.order_id 
JOIN production.products prod ON prod.product_id = ord_item.product_id
JOIN production.categories cat ON cat.category_id = prod.category_id
JOIN sales.stores store ON store.store_id = ord.store_id
JOIN sales.staffs staff ON staff.staff_id = ord.staff_id
JOIN production.brands brands ON brands.brand_id = prod.brand_id
GROUP BY store.state,DATEPART(year,ord.order_date)
ORDER By SUM(ord_item.list_price * ord_item.quantity) DESC,DATEPART(year,ord.order_date) ASC;

---Which categories has the highest sales in NY States
SELECT cat.category_name,
SUM(ord_item.list_price * ord_item.quantity) AS Revenue
FROM sales.customers cus
JOIN sales.orders ord ON cus.customer_id = ord.customer_id
JOIN sales.order_items ord_item ON ord.order_id = ord_item.order_id 
JOIN production.products prod ON prod.product_id = ord_item.product_id
JOIN production.categories cat ON cat.category_id = prod.category_id
JOIN sales.stores store ON store.store_id = ord.store_id
JOIN sales.staffs staff ON staff.staff_id = ord.staff_id
JOIN production.brands brands ON brands.brand_id = prod.brand_id
WHERE cus.state='NY'
GROUP BY cat.category_name
HAVING SUM(ord_item.list_price * ord_item.quantity)>2000000;

--Which brand is the most selling item in stores
SELECT cat.category_name,brands.brand_name,cus.state,
SUM(ord_item.list_price * ord_item.quantity) AS Revenue,
	CASE
		WHEN SUM(ord_item.list_price * ord_item.quantity) >= 1000000 THEN 'High'
		WHEN SUM(ord_item.list_price * ord_item.quantity) < 1000000 THEN 'Low'
	END AS Rank
FROM sales.customers cus
JOIN sales.orders ord ON cus.customer_id = ord.customer_id
JOIN sales.order_items ord_item ON ord.order_id = ord_item.order_id 
JOIN production.products prod ON prod.product_id = ord_item.product_id
JOIN production.categories cat ON cat.category_id = prod.category_id
JOIN sales.stores store ON store.store_id = ord.store_id
JOIN sales.staffs staff ON staff.staff_id = ord.staff_id
JOIN production.brands brands ON brands.brand_id = prod.brand_id
GROUP BY cat.category_name,brands.brand_name,cus.state
ORDER BY Revenue DESC;






