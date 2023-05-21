-- 1) Membuat Database: klik kanan pada Databases > Create > Database... dengan nama ecommerce
-- 2) Membuat Table
CREATE TABLE IF NOT EXISTS customers
(
    customer_id varchar NOT NULL,
    customer_unique_id varchar,
    customer_zip_code_prefix varchar,
    customer_city varchar,
    customer_state varchar
);

CREATE TABLE IF NOT EXISTS geolocations
(
    geolocation_zip_code_prefix varchar,
    geolocation_lat numeric,
    geolocation_lng numeric,
    geolocation_city varchar,
    geolocation_state varchar
);

CREATE TABLE IF NOT EXISTS orders
(
    order_id varchar NOT NULL,
    customer_id varchar,
    order_status varchar,
    order_purchase_timestamp timestamp,
    order_approved_at timestamp,
    order_delivered_carrier_date timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp
);

CREATE TABLE IF NOT EXISTS order_items
(
    order_id varchar,
    order_item_id integer,
    product_id varchar,
    seller_id varchar,
    shipping_limit_date timestamp,
    price numeric,
    fright_value numeric
);

CREATE TABLE IF NOT EXISTS payments
(
    order_id varchar,
    payment_sequential integer,
    payment_type varchar,
    payment_installments integer,
    payment_value numeric
);

CREATE TABLE IF NOT EXISTS products
(
    column1 integer,
    product_id varchar NOT NULL,
    product_category_name varchar,
    product_name_lenght numeric,
    product_description_lenght numeric,
    product_photos_qty numeric,
    product_weight_g numeric,
    product_length_cm numeric,
    product_height_cm numeric,
    product_width_cm numeric
);

CREATE TABLE IF NOT EXISTS reviews
(
    review_id varchar,
    order_id varchar,
    review_score integer,
    review_comment_title varchar,
    review_comment_message varchar,
    review_creation_date timestamp,
    review_answer_timestamp timestamp
);

CREATE TABLE IF NOT EXISTS sellers
(
    seller_id varchar NOT NULL,
    seller_zip_code_prefix varchar,
    seller_city varchar,
    seller_state varchar
);

-- 3) Melakukan import data dengan format csv: klik kanan pada nama tabel > Import/Export Data…

-- 4) Menentukan Primary Key dan Foreign Key
-- PRIMARY KEY
ALTER TABLE customers
    ADD CONSTRAINT customer_id PRIMARY KEY (customer_id);
	
ALTER TABLE orders
    ADD CONSTRAINT order_id PRIMARY KEY (order_id);

ALTER TABLE products
    ADD CONSTRAINT product_id PRIMARY KEY (product_id);

ALTER TABLE sellers
    ADD CONSTRAINT seller_id PRIMARY KEY (seller_id);

-- ALTER TABLE geolocations
--     ADD CONSTRAINT geolocation_zip_code_prefix PRIMARY KEY (geolocation_zip_code_prefix);

-- FOREIGN KEY
ALTER TABLE IF EXISTS order_items
    ADD CONSTRAINT order_id FOREIGN KEY (order_id)
    REFERENCES orders (order_id);

ALTER TABLE IF EXISTS order_items
    ADD CONSTRAINT product_id FOREIGN KEY (product_id)
    REFERENCES products (product_id);

ALTER TABLE IF EXISTS order_items
    ADD CONSTRAINT seller_id FOREIGN KEY (seller_id)
    REFERENCES sellers (seller_id);

ALTER TABLE IF EXISTS orders
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id);

ALTER TABLE IF EXISTS payments
    ADD CONSTRAINT order_id FOREIGN KEY (order_id)
    REFERENCES orders (order_id);

ALTER TABLE IF EXISTS reviews
    ADD CONSTRAINT order_id FOREIGN KEY (order_id)
    REFERENCES orders (order_id);
	
-- ALTER TABLE IF EXISTS customers
--     ADD CONSTRAINT zip_code_prefix FOREIGN KEY (customer_zip_code_prefix)
--     REFERENCES geolocations (geolocation_zip_code_prefix);

-- ALTER TABLE IF EXISTS sellers
--     ADD CONSTRAINT zip_code_prefix FOREIGN KEY (seller_zip_code_prefix)
--     REFERENCES geolocations (geolocation_zip_code_prefix);

-- 5) Membuat Entity Relationship Diagram (ERD): klik kanan pada Database ecommerce > Generate ERD