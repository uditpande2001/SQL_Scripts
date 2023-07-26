
WITH req_nodes AS 
(
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY node_id ORDER BY server_time DESC) AS entry,
        COUNT(1) OVER (PARTITION BY node_id) AS slot_count
    FROM rf_diag
    WHERE node_id =413862  
),
dcu AS 
(  SELECT hub_uuid, max(health_time) AS dcu_health
		FROM dcu_health dh 
		GROUP BY hub_uuid
)
SELECT req_nodes.node_id, req_nodes.server_time, dcu.hub_uuid,dcu.dcu_health
FROM req_nodes
left JOIN dcu ON req_nodes.gw_id = dcu.hub_uuid
WHERE entry = 1



SELECT *
FROM rf_diag rd
WHERE gw_id in

				(SELECT hub_uuid 
				FROM dcu_health dh )







