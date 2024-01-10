CREATE VIEW bl.metrics AS

WITH sm AS
(SELECT 
	sd.ship_id, 
	sd.shipping_mode AS "Метод доставки",
  	ROUND(SUM(sf.sales), 2) AS "Сумма продаж метода",
   	ROUND(SUM(sf.profit), 2) AS "Сумма прибыли метода",
    ROUND(SUM(sf.profit) / SUM(sf.sales) * 100::NUMERIC, 2) AS "Коэффициент рентабельности метода"
FROM 
   	dw.sales_fact sf JOIN dw.shipping_dim sd ON sf.ship_id = sd.ship_id
GROUP BY 
  	sd.shipping_mode,sd.ship_id), 	
	cm AS
(SELECT ctd.cust_id,
	ctd.customer_name AS "имя заказчика",
	ROUND (SUM(sf.sales) ,2) AS "сумма продаж заказчику",
	ROUND (SUM(sf.profit),2) AS "сумма прибыли от заказчика"
FROM 
	dw.sales_fact sf JOIN dw.customer_dim ctd ON sf.cust_id = ctd.cust_id
GROUP BY 
	ctd.customer_name,ctd.cust_id)
						   
SELECT 
	ROW_NUMBER() OVER() AS "Номер",
	
	-- суммы продаж и прибыли по конкретному продукту
	pd.product_name AS "продукт", 
	ROUND (SUM(sf.sales) OVER (PARTITION BY pd.product_name ),2) AS "сумма продаж продукта",
	ROUND (SUM(sf.profit) OVER (PARTITION BY pd.product_name),2) AS "сумма прибыли продукта",
	SUM(sf.quantity) OVER (PARTITION BY pd.product_name) AS "количество проданного продукта",
	
	-- суммы продаж и прибыли по категории
	pd.category AS "категория",
	ROUND (SUM(sf.sales) OVER (PARTITION BY pd.category),2) AS "сумма продаж категории",
	ROUND (SUM(sf.profit) OVER (PARTITION BY pd.category),2) AS "сумма прибыли категории",
	
	-- суммы продаж и прибыли по сегментам
	pd.segment AS "сегмент",
	ROUND (SUM(sf.sales) OVER (PARTITION BY pd.segment),2) AS "сумма продаж сегмента",
	ROUND (SUM(sf.profit) OVER (PARTITION BY pd.segment),2) AS "сумма прибыли сегмента",
    
	-- метрики методов доставки
	sm."Метод доставки",
	sm."Сумма продаж метода",
	sm."Сумма прибыли метода",
	sm."Коэффициент рентабельности метода",
	
	-- коммулятивная сумма продаж и прибыли по дням
	cd.date AS "Дата",
    ROUND(SUM(sf.sales) OVER (ORDER BY cd.date), 2) AS "Кумулятивная сумма продаж",
    ROUND(SUM(sf.profit) OVER (ORDER BY cd.date), 2) AS "Кумулятивная сумма прибыли",

    -- ранг заказчиков по прибыли , продажи и прибыль на заказачика
	cm."имя заказчика" ,
	DENSE_RANK () OVER (ORDER BY "сумма прибыли от заказчика" DESC) AS "ранг заказчика",
	cm."сумма продаж заказчику",
	cm."сумма прибыли от заказчика",
    
	-- общие метрики
	ROUND(SUM(sf.sales) OVER(),2) AS "общая сумма продаж",
	ROUND(SUM(sf.profit) OVER(),2) AS "общая сумма прибыли",
	(SELECT COUNT(cust_id) FROM dw.customer_dim) AS "количество заказчиков",
	(SELECT ROUND(SUM(sq.profit) / SUM(sq.sales) * 100::NUMERIC, 2) FROM dw.sales_fact AS sq) 
									AS "Коэффициент рентабельности магазина",
	(SELECT ROUND(AVG(profit), 2) FROM dw.sales_fact AS sq) 
									AS "Средняя прибыль за заказ",
	(SELECT ROUND(SUM(sales) / COUNT(DISTINCT cust_id),2) FROM dw.sales_fact) AS "продажи за заказчика",
	(SELECT ROUND(SUM(profit) / COUNT(DISTINCT cust_id),2) FROM dw.sales_fact) AS "прибыль за заказчика"

FROM 
	dw.sales_fact sf JOIN dw.product_dim pd ON sf.prod_id = pd.prod_id
					 JOIN sm ON sf.ship_id = sm.ship_id
  					 JOIN dw.calendar_dim cd ON sf.order_date_id = cd.dateid
					 JOIN cm ON sf.cust_id = cm.cust_id	
					 
					 
