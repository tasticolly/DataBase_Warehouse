UPDATE wt.item
SET name = 'Zep Argo'
WHERE item_id = 5;

UPDATE wt.item
SET name = 'Spinner'
WHERE item_id = 21;

SELECT * FROM wt.item
LIMIT 5;

SELECT * FROM wt.item
ORDER BY cost DESC;

DELETE FROM wt.item
WHERE cost < 0.1;

DELETE FROM wt.item
WHERE item_id = 1;

INSERT INTO wt.goods_in_shipment (waybill_id,item_id)
VALUES (22, 2), (34, 2);

UPDATE wt.warehouse
SET address = 'Pervomayskaya street,32 B,2'
WHERE warehouse_id = 3;

SELECT * FROM wt.warehouse;

INSERT INTO wt.goods_in_order (order_id,item_id)
VALUES
  (42,21),
  (37,18),
  (13,4),
  (7,4),
  (31,1);


SELECT DISTINCT warehouse_id FROM wt.goods_in_warehouse
WHERE item_id = 5;
