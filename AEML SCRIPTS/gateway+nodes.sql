SELECT rd2.node_id ,
rd2.sink_id ,
node_max_time.last_time,
node_max_time.diag_count,
rd2.gw_id
FROM rf_diag rd2 
RIGHT JOIN (
	SELECT node_id , max(server_time) AS last_time , count(node_id) AS diag_count  
	FROM rf_diag rd 
	WHERE server_time BETWEEN '2023-04-19 10:00:00.000' AND '2023-04-19 23:59:59.000' 
	AND gw_id = '861261056658087'
	GROUP BY node_id
) node_max_time
ON rd2.node_id = node_max_time.node_id 
WHERE rd2.server_time = node_max_time.last_time
ORDER BY node_id ;


