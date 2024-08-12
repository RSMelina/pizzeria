-- Client Brief- Jon's Pizzeria

/*
Stock control requirements:
- Wants to be able to know when it's time to order new stock
- To do this we're going to need more information about:
	- what ingredients go into each pizza
    - their quantity based on the size of the pizza
    - the existing stock level
    
* Assumption:
   Lead time delivery is the same for all ingredients
   
Staff data requirements:
- Wants to know which staff members areworking when
- Based on the staff salary info, how much each pizza costs (ingredients + chef + delivery)
*/

/*
Dashboard 1- ORDER ACTIVITY
The required data:
1. Total orders
2. Total sales
3. Total items
4. Average order value
5. Sales by category
6. Top selling items
7. Orders by hour
8. Sales by hour
9. Orders by address
10. Orders by delivery/pick up
*/

SELECT
o.order_id,
i.item_price,
o.quantity,
i.item_cat,
i.item_name,
o.created_at,
a.delivery_address1,
a.delivery_city,
a.delivery_zipcode,
o.delivery
FROM
orders o
LEFT JOIN item i ON o.item_id= i.item_id
LEFT JOIN address a ON o.add_id = a.add_id;

/*
Dashboard 2- INVENTORY MANAGEMENT
Calculate how much inventory is being used and identify inventory that needs reordering.
Calculate how much each pizza costs to make based on the cost of the ingredients to keep an eye on pricing and P/L.
The required data:
1. Total quantity by ingredient
2. Total cost of ingredients
3. Calculated cost of pizza
4. Percentage stock remaining by ingredient
*/

-- 1. Total quantity by ingredient:
-- (No. of orders x ingredient quantity in recipe)

SELECT
s1.item_name,
s1.ing_id,
s1.ing_name,
s1.ing_weight,
s1.ing_price,
s1.order_quantity,
s1.recipe_quantity,
s1.order_quantity * s1.recipe_quantity AS ordered_weight,
s1.ing_price/s1.ing_weight AS unit_cost,
(s1.order_quantity * s1.recipe_quantity)*(s1.ing_price/s1.ing_weight) AS ingredient_cost
FROM (SELECT
o.item_id,
i.sku,
i.item_name,
r.ing_id,
ing.ing_name,
r.quantity AS recipe_quantity,
sum(o.quantity) as order_quantity,
ing.ing_weight,
ing.ing_price
FROM orders o
LEFT JOIN item i ON o.item_id=i.item_id
LEFT JOIN recipe r ON i.sku= r.recipe_id
LEFT JOIN ingredient ing ON ing.ing_id = r.ing_id
GROUP BY 
o.item_id, 
i.sku, 
i.item_name,
r.ing_id,
r.quantity,
ing.ing_name,
ing.ing_weight,
ing.ing_price) s1;

SELECT
ing_name,
SUM(ordered_weight)
FROM
stock1;