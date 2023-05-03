CREATE SCHEMA IF NOT EXISTS wt;

CREATE TABLE IF NOT EXISTS wt.provider (
	provider_id INT NOT NULL PRIMARY KEY,
	provider_name VARCHAR(50) NOT NULL,
	contact_person VARCHAR(50) NOT NULL,
	telephone VARCHAR(50) NOT NULL,
	email VARCHAR(100) NOT NULL,
	banking_details VARCHAR(100) NOT NULL,
	valid_from TIMESTAMP NOT NULL,
	valid_to TIMESTAMP DEFAULT '9999-12-31'
);


CREATE TABLE IF NOT EXISTS wt.item (
	item_id INT NOT NULL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	description VARCHAR(200),
	cost FLOAT NOT NULL,
	space FLOAT NOT NULL,
	provider_id INT NOT NULL,
	CONSTRAINT  fk_item_to_provider FOREIGN KEY (provider_id) REFERENCES wt.provider(provider_id)
);


CREATE TABLE IF NOT EXISTS wt.order (
	order_id INT NOT NULL PRIMARY KEY,
	date TIMESTAMP NOT NULL,
	provider_id INT NOT NULL,
	CONSTRAINT  fk_order_to_provider FOREIGN KEY (provider_id) REFERENCES wt.provider(provider_id)
);

CREATE TABLE IF NOT EXISTS wt.goods_in_order (
	order_id INT NOT NULL,
	item_id INT NOT NULL,
	PRIMARY KEY(order_id, item_id),
	CONSTRAINT  fk_goods_ord_to_order FOREIGN KEY (order_id) REFERENCES wt.order(order_id),
	CONSTRAINT  fk_goods_ord_to_item FOREIGN KEY (item_id) REFERENCES wt.item(item_id)
);


CREATE TABLE IF NOT EXISTS wt.warehouse (
	warehouse_id INT NOT NULL PRIMARY KEY,
	warehouse_name VARCHAR(50) NOT NULL,
	address VARCHAR(50) NOT NULL
);


CREATE TABLE IF NOT EXISTS wt.shipment (
	waybill_id INT NOT NULL PRIMARY KEY,
	date TIMESTAMP NOT NULL,
	warehouse_id INT NOT NULL,
	CONSTRAINT  fk_shipment_to_warehouse FOREIGN KEY (warehouse_id) REFERENCES wt.warehouse(warehouse_id)
);

CREATE TABLE IF NOT EXISTS wt.goods_in_shipment (
	waybill_id INT NOT NULL,
	item_id INT NOT NULL,
	PRIMARY KEY(waybill_id, item_id),
	CONSTRAINT  fk_goods_ship_to_shipment FOREIGN KEY (waybill_id) REFERENCES wt.shipment(waybill_id),
	CONSTRAINT  fk_goods_ship_to_item FOREIGN KEY (item_id) REFERENCES wt.item(item_id)
);


CREATE TABLE IF NOT EXISTS wt.goods_in_warehouse (
	warehouse_id INT NOT NULL,
	item_id INT NOT NULL,
	item_count INT NOT NULL DEFAULT 0,
	PRIMARY KEY(warehouse_id, item_id),
	CONSTRAINT  fk_goods_wh_to_wh FOREIGN KEY (warehouse_id) REFERENCES wt.warehouse(warehouse_id),
	CONSTRAINT  fk_goods_wh_to_item FOREIGN KEY (item_id) REFERENCES wt.item(item_id)
);
