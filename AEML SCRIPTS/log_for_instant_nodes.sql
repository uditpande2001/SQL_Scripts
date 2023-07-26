SELECT rl.node_id ,rl.hex,rl.server_time AS log_time ,req_nodes.instant_slots	
FROM rf_log rl 
RIGHT JOIN	(
			SELECT node_id , max(server_time)as latest_time , count(node_id) AS instant_slots 
			FROM meter_profile_data mpd 
			WHERE server_time BETWEEN '2023-05-10 00:00:00.000' AND '2023-05-10 23:59:59.999'
			AND "type" = 'Instant_Profile' AND node_id >= 400000
			GROUP BY node_id ) req_nodes
ON rl.node_id = req_nodes.node_id
WHERE req_nodes.instant_slots <5
AND rl.server_time BETWEEN '2023-05-10 00:00:00.000' AND '2023-05-10 23:59:59.999'










