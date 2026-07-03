-- ============================================================
-- 02_load_data.sql
-- Purpose: Load raw Olist CSV files into staging tables
-- Database: ecommerce_sql_analytics
-- ============================================================

TRUNCATE TABLE stg_order_reviews;
TRUNCATE TABLE stg_order_payments;
TRUNCATE TABLE stg_order_items;
TRUNCATE TABLE stg_orders;
TRUNCATE TABLE stg_products;
TRUNCATE TABLE stg_customers;
TRUNCATE TABLE stg_sellers;
TRUNCATE TABLE stg_geolocation;
TRUNCATE TABLE stg_product_category_translation;

COPY stg_customers
FROM 'F:/Projects/ecommerce-sql-analytics/data/raw/olist_customers_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY stg_sellers
FROM 'F:/Projects/ecommerce-sql-analytics/data/raw/olist_sellers_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY stg_products
FROM 'F:/Projects/ecommerce-sql-analytics/data/raw/olist_products_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY stg_product_category_translation
FROM 'F:/Projects/ecommerce-sql-analytics/data/raw/product_category_name_translation.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY stg_orders
FROM 'F:/Projects/ecommerce-sql-analytics/data/raw/olist_orders_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY stg_order_items
FROM 'F:/Projects/ecommerce-sql-analytics/data/raw/olist_order_items_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY stg_order_payments
FROM 'F:/Projects/ecommerce-sql-analytics/data/raw/olist_order_payments_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY stg_order_reviews
FROM 'F:/Projects/ecommerce-sql-analytics/data/raw/olist_order_reviews_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY stg_geolocation
FROM 'F:/Projects/ecommerce-sql-analytics/data/raw/olist_geolocation_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);