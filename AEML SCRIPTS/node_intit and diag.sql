

SELECT diag_init.node_id, diag_init.init_count, diag_init.diag_count, diag_init.latest_diag_time,
		instant_data.instant_count
from
(SELECT init_data.node_id, init_data.node_count AS init_count, diag_data.diag_count, diag_data.latest_diag_time
FROM 
	(
		SELECT node_id, count(node_id) AS diag_count , max(server_time) as latest_diag_time 
		FROM rf_diag rd
		where  server_time BETWEEN '2023-04-26 00:00:00' AND '2023-04-26 23:59:59.999' AND 
		end_point LIKE '%253%'
		AND node_id >= 400000
		group BY node_id
	) diag_data
RIGHT JOIN 
		(	
			SELECT node_id , count(node_id) AS node_count 
			FROM node_init ni 
			WHERE server_time BETWEEN  '2023-04-26 00:00:00' AND '2023-04-26 23:59:59.999'
			AND node_id >= 400000
			GROUP BY node_id
		) init_data
ON diag_data.node_id = init_data.node_id) diag_init
left JOIN 
		(		SELECT  node_id , count(1) AS instant_count 
						FROM meter_profile_data mpd 
						WHERE server_time BETWEEN '2023-04-26 00:00:00' AND '2023-04-26 23:59:59.999' 
						AND "type" = 'Instant_Profile'
						GROUP BY node_id 
						
		) instant_data
ON diag_init.node_id = instant_data.node_id
WHERE instant_data.instant_count IS null
ORDER BY diag_init.init_count desc;