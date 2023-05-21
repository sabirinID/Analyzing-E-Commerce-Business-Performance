-- Query_Task_2

-- 1) Menampilkan rata-rata jumlah customer aktif bulanan (monthly active user) untuk setiap tahun
SELECT year,
       FLOOR(AVG(customer_total)) AS avg_mau
  FROM
  (
	   SELECT date_part('year', o.order_purchase_timestamp) AS year,
	          date_part('month', o.order_purchase_timestamp) AS month,
	          COUNT(DISTINCT c.customer_unique_id) AS customer_total
	     FROM orders AS o
         JOIN customers AS c
  	       ON o.customer_id = c.customer_id
        GROUP BY 1, 2
  ) AS sub
 GROUP BY 1
 ORDER BY 1;

-- 2) Menampilkan jumlah customer baru pada masing-masing tahun
SELECT year,
       COUNT(customer_unique_id) AS total_new_customer
  FROM
  (
       SELECT Min(date_part('year', o.order_purchase_timestamp)) AS year,
	          c.customer_unique_id
         FROM orders AS o
         JOIN customers AS c
           ON o.customer_id = c.customer_id
        GROUP BY 2
  ) AS sub
 GROUP BY 1
 ORDER BY 1;

-- 3) Menampilkan jumlah customer yang melakukan pembelian lebih dari satu kali (repeat order) pada masing-masing tahun
SELECT year,
       count(customer_unique_id) AS total_customer_repeat
  FROM
  (
       SELECT date_part('year', o.order_purchase_timestamp) AS year,
              c.customer_unique_id,
  	          COUNT(o.order_id) AS total_order
         FROM orders AS o
         JOIN customers AS c
           ON o.customer_id = c.customer_id
        GROUP BY 1, 2
       HAVING count(2) > 1
  ) AS sub
 GROUP BY 1
 ORDER BY 1;

-- 4) Menampilkan rata-rata jumlah order yang dilakukan customer untuk masing-masing tahun
SELECT year,
       ROUND(AVG(freq), 3) AS avg_frequency
  FROM
  (
       SELECT date_part('year', o.order_purchase_timestamp) AS year,
              c.customer_unique_id,
              COUNT(order_id) AS freq
         FROM orders AS o
         JOIN customers AS c
           ON o.customer_id = c.customer_id
        GROUP BY 1, 2
  ) AS sub
 GROUP BY 1
 ORDER BY 1;

-- 5) Menggabungkan ketiga metrik yang telah berhasil ditampilkan menjadi satu tampilan tabel
WITH cte_mau AS
(
SELECT year,
       FLOOR(AVG(customer_total)) AS avg_mau
  FROM
  (
	   SELECT date_part('year', o.order_purchase_timestamp) AS year,
	          date_part('month', o.order_purchase_timestamp) AS month,
	          COUNT(DISTINCT c.customer_unique_id) AS customer_total
	     FROM orders AS o
         JOIN customers AS c
  	       ON o.customer_id = c.customer_id
        GROUP BY 1, 2
  ) AS sub
 GROUP BY 1
),

cte_new_customer AS
(
SELECT year,
       COUNT(customer_unique_id) AS total_new_customer
  FROM
  (
       SELECT Min(date_part('year', o.order_purchase_timestamp)) AS year,
	          c.customer_unique_id
         FROM orders AS o
         JOIN customers AS c
           ON o.customer_id = c.customer_id
        GROUP BY 2
  ) AS sub
 GROUP BY 1
),

cte_repeat_order AS
(
SELECT year,
       count(customer_unique_id) AS total_customer_repeat
  FROM
  (
       SELECT date_part('year', o.order_purchase_timestamp) AS year,
              c.customer_unique_id,
  	          COUNT(o.order_id) AS total_order
         FROM orders AS o
         JOIN customers AS c
           ON o.customer_id = c.customer_id
        GROUP BY 1, 2
       HAVING count(2) > 1
  ) AS sub
 GROUP BY 1
),

cte_frequency AS
(
SELECT year,
       ROUND(AVG(freq), 3) AS avg_frequency
  FROM
  (
       SELECT date_part('year', o.order_purchase_timestamp) AS year,
              c.customer_unique_id,
              COUNT(order_id) AS freq
         FROM orders AS o
         JOIN customers AS c
           ON o.customer_id = c.customer_id
        GROUP BY 1, 2
  ) AS sub
 GROUP BY 1
)

SELECT mau.year AS year,
       avg_mau,
       total_new_customer,
       total_customer_repeat,
       avg_frequency
  FROM cte_mau AS mau
  JOIN cte_new_customer AS nc
  	ON mau.year = nc.year
  JOIN cte_repeat_order AS ro
  	ON nc.year = ro.year
  JOIN cte_frequency AS f
  	ON ro.year = f.year
 GROUP BY 1, 2, 3, 4, 5
 ORDER BY 1;