CREATE VIEW blur_card_info AS
SELECT provider_id, provider_name, contact_person, telephone, email,
regexp_replace(banking_details, '(^\d{4})(.*)(\d{4}$)', '\1**********\3') AS banking_details, valid_from, valid_to
FROM wt.provider;


-- в поле с банковской картой оставляет только первые и последние 4 цифры, заменяя остальные на *

CREATE VIEW blur_telephone_info AS
SELECT provider_id, provider_name, contact_person, email,
regexp_replace(telephone, '(^\S{5})(.*)(\S{4}$)', '\1**********\3') AS telephone
FROM wt.provider;

-- в поле с номером телефона только код (первые триц цифры в скобочках) и последние 4 цифры, заменяя остальное на *

CREATE VIEW blur_address AS
SELECT warehouse_id, warehouse_name,
regexp_replace(address, '(^.* )(.*)($)', '\1**********\3') AS address
FROM wt.warehouse;

-- в поле с адресом склада заменяет на звездочки часть адреса

CREATE VIEW without_technical_information AS
SELECT item_id, name, description, cost
FROM wt.item;


-- таблица товаров без технической информации: данные о поставщике и пространстве, которое занимает товар.

CREATE VIEW orders_info AS
SELECT order_id, MIN(date) AS date, SUM(cost) AS total_cost_of_order, COUNT(*) AS num_of_items
FROM (SELECT o.order_id AS order_id, date, item_id
	  FROM
		wt.goods_in_order gio INNER JOIN wt.order o ON gio.order_id = o.order_id) AS first_join
INNER JOIN wt.item i ON first_join.item_id = i.item_id
GROUP BY order_id;
SELECT * FROM orders_info;

-- сводная таблица по заказам: для каждого заказа посчитана суммарная стоимость, количество товаров в нем и дата совершения.

CREATE VIEW item_popularity AS
SELECT i.item_id AS item_id, name, SUM(cost) AS total_cost_of_order, COUNT(*) AS num_of_items
FROM (SELECT o.order_id AS order_id, date, item_id
	  FROM
		wt.goods_in_order gio INNER JOIN wt.order o ON gio.order_id = o.order_id) AS first_join
INNER JOIN wt.item i ON first_join.item_id = i.item_id
GROUP BY i.item_id
ORDER BY num_of_items DESC;

-- самые поплурняые товары по количеству заказов
CREATE OR REPLACE VIEW items_in_warehouse AS
SELECT warehouse_id, i.item_id AS item_id, name, cost, SUM(first_join.item_count) AS num_of_items_in_warehouse, SUM(space) AS summary_taken_space
FROM (SELECT w.warehouse_id AS warehouse_id, item_count, item_id
	  FROM
		wt.goods_in_warehouse giw INNER JOIN wt.warehouse w ON giw.warehouse_id = w.warehouse_id) AS first_join
INNER JOIN wt.item i ON first_join.item_id = i.item_id
GROUP BY warehouse_id, i.item_id
ORDER BY warehouse_id;

SELECT * FROM item_popularity;
-- табличка, связывающая товары и склады, по ней можно быстро находить суммарное занимаемое место на складе, суммарное количество товаров и т.д.