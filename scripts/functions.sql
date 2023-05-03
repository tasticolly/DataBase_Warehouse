-- функция, которая возвращают информацию о товаре: имя, опипсание, количество на всех складах, стоимость,
-- занимаемое пространство, порядковый номер в топе по частоте заказа товаров, номер поставщика

CREATE OR REPLACE FUNCTION wt.get_item_info(i_id INTEGER)
	RETURNS TABLE
	 (
	 	name VARCHAR(50),
		description VARCHAR(100),
		count NUMERIC,
		cost FLOAT,
		space FLOAT,
		frequency_top BIGINT,
		provider_id INT
	 )
AS
$$
#variable_conflict use_column
BEGIN
  RETURN QUERY
     SELECT name, description,(SELECT SUM(num_of_items_in_warehouse) FROM items_in_warehouse
							   WHERE item_id = i_id) AS count,
	  cost, space, (SELECT row_number FROM (SELECT item_id, row_number() OVER (ORDER BY num_of_items DESC) FROM item_popularity) AS ranged
				    WHERE item_id = i_id) AS frequency_top, provider_id FROM wt.item
	 WHERE item_id = i_id;
END;
$$ LANGUAGE plpgsql;



-- возвращает суммарную стоимость товаров в заданной отгрузке (по id)

CREATE OR REPLACE FUNCTION  wt.get_summary_cost_of_shipment(shpm_id INTEGER)
	RETURNS TABLE (waybill_id INT,
				  summary_cost FLOAT)
AS
$$
#variable_conflict use_column
BEGIN
  RETURN QUERY
	SELECT waybill_id, SUM(cost) AS summary_cost
	FROM (SELECT s.waybill_id AS waybill_id, item_id
		  FROM
			wt.goods_in_shipment gis INNER JOIN wt.shipment s ON gis.waybill_id = s.waybill_id) AS first_join
	INNER JOIN wt.item i ON first_join.item_id = i.item_id
	GROUP BY waybill_id
	HAVING waybill_id = shpm_id;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM wt.get_summary_cost_of_shipment(3);

