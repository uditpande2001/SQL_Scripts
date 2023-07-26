SELECT rd.node_id,rd .gw_id,rd.sink_id,req_gw.boot_count,req_gw.latest_server_time
FROM rf_diag rd 
RIGHT join(
			SELECT node_id, max(server_time) latest_server_Time, count(1)AS boot_count 
			FROM rf_diag rd 
			WHERE server_time >='2023-05-24 00:00:00.000' AND end_point LIKE '%254%'
			AND node_id <= 400000
			AND gw_id IN ('866340057543251','866340057556022','861261056658087','861261056663251','861261056663970','861261056663327')
			GROUP BY node_id) req_gw
ON rd.node_id = req_gw.node_id
WHERE rd.server_time = req_gw.latest_server_time
