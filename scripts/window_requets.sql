SELECT provider_id FROM wt.item
GROUP BY provider_id
HAVING AVG(cost) > 12000
ORDER BY provider_id ASC;

SELECT * FROM wt.provider
ORDER BY valid_from;

SELECT item_id, name,provider_id,
COUNT(*) over (partition by provider_id) as count_items_from_provider FROM wt.item;

SELECT item_id, order_id,
ROW_NUMBER() over (ORDER BY item_id) as count_items_from_provider FROM wt.goods_in_order;

SELECT item_id, order_id,
row_number() OVER (PARTITION BY order_id ORDER BY item_id ASC)
FROM wt.goods_in_order;

SELECT warehouse_id, waybill_id,
FIRST_VALUE(waybill_id) OVER (PARTITION BY warehouse_id ORDER BY date ASC)
FROM wt.shipment;
