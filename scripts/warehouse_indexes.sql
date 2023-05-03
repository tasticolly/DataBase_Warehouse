CREATE INDEX "goods_in_shipment.waybill_id_item_id"
    ON wt.goods_in_shipment
    USING btree
    (waybill_id, item_id);

CREATE INDEX "goods_in_shipment.item_id_waybill_id"
    ON wt.goods_in_shipment
    USING btree
    (item_id, waybill_id);

-- предыдущие два индекса нужны для быстрого джоина таблиц shipment и good при 
-- помощи вспомогательной таблицы goods_in
-- в следующих 4 индексах сделано аналогично для других отношений в концептуальной модели 
-- которых предполагалось отношение многие ко многим. 

CREATE INDEX "goods_in_order.order_id_item_id"
    ON wt.goods_in_order
    USING btree
    (order_id, item_id);


CREATE INDEX "goods_in_order.item_id_order_id"
    ON wt.goods_in_order
    USING btree
    (item_id, order_id);


CREATE INDEX "goods_in_warehouse.warehouse_id_item_id"
    ON wt.goods_in_warehouse
    USING btree
    (warehouse_id, item_id);

CREATE INDEX "goods_in_warehouse.item_id_warehouse_id"
    ON wt.goods_in_warehouse
    USING btree
    (item_id, warehouse_id);
--

CREATE INDEX "provider.bankingdetails"
    ON wt.provider
    USING btree
    (banking_details);

-- для быстрого получения реквизитов, так как они очень редко меняются и часто использвуются.

CREATE INDEX "item.cost"
    ON wt.item
    USING btree
    (cost);

-- для быстрого получение стоимости товара, так как это очень популярный запрос.


