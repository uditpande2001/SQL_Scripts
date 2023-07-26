WITH diag_data AS (SELECT*, ROW_NUMBER() OVER (PARTITION BY node_id ORDER BY server_time desc)AS row_number,
					count(1) OVER (PARTITION BY node_id) AS diag_count
					FROM rf_diag rd 
					WHERE server_time >= '2023-07-18 00:00:00' AND server_time <= '2023-07-18 23:59:59'
					AND node_id >= 400000
					AND end_point LIKE '%253/255'
)
SELECT *
FROM diag_data
WHERE row_number= 1;


WITH init_data AS (SELECT*, ROW_NUMBER() OVER (PARTITION BY node_id ORDER BY server_time desc)AS row_number,
					count(1) OVER (PARTITION BY node_id) AS init_count
					FROM node_init 
					WHERE server_time >= '2023-07-16 00:00:00'					
)
SELECT *
FROM init_data
WHERE row_number= 1;