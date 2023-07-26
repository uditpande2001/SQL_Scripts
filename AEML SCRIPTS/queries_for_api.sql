SELECT DISTINCT division  
FROM meter_lat_long mll 

SELECT DISTINCT "zone" 
FROM meter_lat_long mll 
WHERE division = 'MALAD' -- INPUT division IN program

SELECT count(DISTINCT uuid) 
FROM dcu_lat_long dll 

-- TOTAL ONLINE DCU'S
SELECT count(DISTINCT hub_uuid)
FROM dcu_health dh 
WHERE health_time >= ' 2023-05-23 00:00:00.000' -- CURRENT TIME - THRESHOLD IN PROGRAM 

-- OFFILNE DCU'S
SELECT  count(DISTINCT uuid)
FROM dcu_lat_long dll 
WHERE uuid NOT IN (SELECT DISTINCT hub_uuid AS uuid
						FROM dcu_health dh 
						WHERE health_time >= '2023-05-23 00:00:00.000') -- CURRENT TIME - THRESHOLD IN PROGRAM

-- TOTAL NODES
SELECT count(DISTINCT node_id)
FROM meter_mapping mm WHERE node_id >= 400000

--ONLINE NODES

SELECT count (mm.node_id)
FROM meter_mapping mm 
RIGHT join
			(SELECT DISTINCT node_id
			FROM rf_diag rd
			WHERE node_id >= 400000 AND server_time >= '2023-05-23 00:00:00.000') online_nodes
ON mm.node_id = online_nodes.node_id

-- DCU INFO

select ('866340057550645') from (
select rownumber(partiton by hub_uuid order by health_time desc) as row_num,* from dcurepo join dcuhealth where zone=?1
) where row_num=1


--INPUT ZONE AND RETURN ONLINE DUC'S IN THAT ZONE
SELECT *
FROM dcu_lat_long dll 		
RIGHT JOIN 		(SELECT hub_uuid , max(health_time) AS latest_dcu_health 
				FROM dcu_health dh
				GROUP BY hub_uuid) online_dcu 
on dll.uuid = online_dcu.hub_uuid
WHERE dll."zone" = 'SHIMPOLI' -- INPUT THE DIVISION -- compare time TO required threshold AND mark TRUE OR FALSE 

--INPUT ZONE AND RETURN ONLINE NODES IN THAT ZONE

SELECT *
FROM meter_lat_long mll 

SELECT node_id, max(server_time) AS latest_node_diag
FROM rf_diag rd WHERE node_id >=400000
AND server_time >= '2023-05-23 00:00:00.000'
GROUP BY node_id 



						