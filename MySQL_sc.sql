  SELECT 
    order_status, 
    COUNT(*) AS orders
FROM
    orders
GROUP BY order_status;
  
  
  -- How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are
   select
   
   COUNT(DISTINCT s.seller_id) as all_sellers, 
   COUNT(DISTINCT CASE WHEN pn.product_category_name_english IN ('audio' ,'consoles_games','electronics','audio','cds_dvds_musicals','dvds_blu_ray','computers_accessories','tablets_printing_image','','pc_gamer','computers','signaling_and_security','fixed_telephony','telephony')
   THEN s.seller_id END) as Tech_sellers,
   
   
    (COUNT(DISTINCT CASE WHEN pn.product_category_name_english IN ('audio' ,'consoles_games','electronics','audio','cds_dvds_musicals','dvds_blu_ray','computers_accessories','tablets_printing_image','','pc_gamer','computers','signaling_and_security','fixed_telephony','telephony')
    THEN s.seller_id END) / COUNT(DISTINCT s.seller_id)) * 100 AS tech_sellers_percentage
     FROM 
    sellers s
left JOIN 
    order_items oi ON s.seller_id = oi.seller_id
right join 
    products p ON oi.product_id = p.product_id
 left JOIN 
    product_category_name_translation pn ON p.product_category_name = pn.product_category_name
    
 ;
 
 
 -- What is the total amount earned by all sellers?
 SELECT 
    SUM(price) AS total_amount_earned
FROM 
    order_items;

 -- What is the total amount earned by all Tech sellers?
    SELECT 
    SUM(o.price) AS total_amount_earned_tech_sellers
FROM 
    order_items o
left JOIN 
    products p ON o.product_id = p.product_id
 left JOIN 
    product_category_name_translation pn ON p.product_category_name = pn.product_category_name
WHERE 
    pn.product_category_name_english in ('audio' ,'consoles_games','electronics,computers_accessories','telephony');
    
    
    

   -- How many months of data are included in the magist database?
    SELECT 
    TIMESTAMPDIFF(MONTH, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp))  AS months
FROM 
    orders;
    
    
    SELECT 
    AVG(price) AS average_monthly_income_all_sellers
FROM 
    order_items
GROUP BY 
    YEAR(o), MONTH(o);

  -- Is Magist having user growth?  
SELECT 
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    COUNT(customer_id)
FROM
    orders
GROUP BY year_ , month_
ORDER BY year_ , month_;
SELECT 
order_status,
    COUNT(*) AS order_count
FROM 
    orders
GROUP BY 
  order_status;
-- order satatus
SELECT 
order_status,
    COUNT(order_id) AS order_count
FROM 
    orders
GROUP BY 
  order_status;



  -- How many orders are delivered on time vs orders delivered with a delay?
  SELECT 
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On Time'
        ELSE 'Delayed'
    END AS order_status,
    COUNT(*) AS order_count
FROM 
    orders
    
    
    GROUP BY 
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On Time'
        ELSE 'Delayed'
    END
;


-- all orders , tech orders and the percentage of tech

 select
   
   COUNT(DISTINCT s.order_id) as all_orders, 
   COUNT(DISTINCT CASE WHEN pn.product_category_name_english IN ('audio' ,'consoles_games','electronics','audio','cds_dvds_musicals','dvds_blu_ray','computers_accessories','tablets_printing_image','','pc_gamer','computers','signaling_and_security','fixed_telephony','telephony')
   THEN s.order_id END) as Tech_orders,
   
   
    (COUNT(DISTINCT CASE WHEN pn.product_category_name_english IN ('audio' ,'consoles_games','electronics','audio','cds_dvds_musicals','dvds_blu_ray','computers_accessories','tablets_printing_image','','pc_gamer','computers','signaling_and_security','fixed_telephony','telephony')
    THEN s.order_id END) / COUNT(DISTINCT s.order_id)) * 100 AS tech_orders_percentage
     FROM 
   order_items s
left JOIN 

    products p ON s.product_id = p.product_id
 left JOIN 
    product_category_name_translation pn ON p.product_category_name = pn.product_category_name
    
 ;


 -- all orders revenue , tech orders revenue and the percentage of tech revenue
  select
   
   sum(price) as all_orders_revenue, 
  sum( CASE WHEN pn.product_category_name_english IN ('audio' ,'consoles_games','electronics','audio','cds_dvds_musicals','dvds_blu_ray','computers_accessories','tablets_printing_image','','pc_gamer','computers','signaling_and_security','fixed_telephony','telephony')
   THEN price END) as Tech_orders_revenue,
   
   
    (sum(CASE WHEN pn.product_category_name_english IN ('audio' ,'consoles_games','electronics','audio','cds_dvds_musicals','dvds_blu_ray','computers_accessories','tablets_printing_image','','pc_gamer','computers','signaling_and_security','fixed_telephony','telephony')
    THEN price END) /  sum(price)) * 100 AS tech_orders_revenue_percentage
     FROM 
   order_items s
left JOIN 

    products p ON s.product_id = p.product_id
 left JOIN 
    product_category_name_translation pn ON p.product_category_name = pn.product_category_name
    
 ;


-- avg delay and all delivery
SELECT
    order_status,
    AVG(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) END) AS average_delay_delivered_orders,
    AVG( DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) ) AS average_delay_all_orders
FROM
    orders
WHERE
    order_status='Delivered'
GROUP BY
    order_status;
    