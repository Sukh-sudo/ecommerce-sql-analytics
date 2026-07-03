-- ============================================================
-- 03_data_quality_checks.sql
-- Purpose: Validate raw staging table loads
-- ============================================================
SELECT 'stg_customers' AS table_name, COUNT(*) AS row_count FROM stg_customers
UNION ALL
SELECT 'stg_sellers', COUNT(*) FROM stg_sellers
UNION ALL
SELECT 'stg_products', COUNT(*) FROM stg_products
UNION ALL
SELECT 'stg_product_category_translation', COUNT(*) FROM stg_product_category_translation
UNION ALL
SELECT 'stg_orders', COUNT(*) FROM stg_orders
UNION ALL
SELECT 'stg_order_items', COUNT(*) FROM stg_order_items
UNION ALL
SELECT 'stg_order_payments', COUNT(*) FROM stg_order_payments
UNION ALL
SELECT 'stg_order_reviews', COUNT(*) FROM stg_order_reviews
UNION ALL
SELECT 'stg_geolocation', COUNT(*) FROM stg_geolocation
ORDER BY table_name;

-- ============================================================
-- 2. Order status distribution
-- Helps understand delivered, cancelled, shipped, and unavailable orders.
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS order_count
FROM stg_orders
GROUP BY order_status
ORDER BY order_count DESC;


-- ============================================================
-- 3. Duplicate key checks
-- Identifies duplicate records in core entity tables.
-- ============================================================

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM stg_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM stg_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT
    seller_id,
    COUNT(*) AS duplicate_count
FROM stg_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM stg_products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 4. Missing delivery date checks
-- Delivered orders should usually have customer delivery dates.
-- ============================================================

SELECT
    COUNT(*) AS delivered_orders_missing_customer_delivery_date
FROM stg_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;


SELECT
    COUNT(*) AS delivered_orders_missing_carrier_date
FROM stg_orders
WHERE order_status = 'delivered'
  AND order_delivered_carrier_date IS NULL;


-- ============================================================
-- 5. Timestamp sequence checks
-- Validates whether order lifecycle timestamps occur in logical order.
-- ============================================================

SELECT
    COUNT(*) AS approved_before_purchase
FROM stg_orders
WHERE order_approved_at < order_purchase_timestamp;


SELECT
    COUNT(*) AS carrier_before_approval
FROM stg_orders
WHERE order_delivered_carrier_date < order_approved_at;


SELECT
    COUNT(*) AS customer_delivery_before_carrier
FROM stg_orders
WHERE order_delivered_customer_date < order_delivered_carrier_date;


-- ============================================================
-- 6. Orders delivered late
-- Counts delivered orders where actual delivery date exceeded estimate.
-- ============================================================

SELECT
    COUNT(*) AS delivered_orders,
    SUM(
        CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_order_rate_percent
FROM stg_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- ============================================================
-- 7. Negative price or freight checks
-- Prices and freight values should not be negative.
-- ============================================================

SELECT
    COUNT(*) AS negative_price_or_freight_rows
FROM stg_order_items
WHERE price < 0
   OR freight_value < 0;


SELECT
    COUNT(*) AS negative_payment_rows
FROM stg_order_payments
WHERE payment_value < 0;


-- ============================================================
-- 8. Orphan record checks
-- Identifies records that do not connect back to a valid order.
-- ============================================================

SELECT
    COUNT(*) AS order_items_without_order
FROM stg_order_items oi
LEFT JOIN stg_orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT
    COUNT(*) AS payments_without_order
FROM stg_order_payments p
LEFT JOIN stg_orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT
    COUNT(*) AS reviews_without_order
FROM stg_order_reviews r
LEFT JOIN stg_orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- ============================================================
-- 9. Orders without commercial records
-- Identifies orders that have no item or payment records.
-- ============================================================

SELECT
    COUNT(*) AS orders_without_items
FROM stg_orders o
LEFT JOIN stg_order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;


SELECT
    COUNT(*) AS orders_without_payments
FROM stg_orders o
LEFT JOIN stg_order_payments p
    ON o.order_id = p.order_id
WHERE p.order_id IS NULL;


-- ============================================================
-- 10. Review score distribution
-- Helps understand customer satisfaction profile.
-- ============================================================

SELECT
    review_score,
    COUNT(*) AS review_count
FROM stg_order_reviews
GROUP BY review_score
ORDER BY review_score;