-- remove last time = null and right join (top) to get gw for only those nodes which have given midnight 
SELECT mid_meter.meter_number,
		mid_meter.node_id,
		mid_meter.last_time AS latest_midnight_time,
		node_gw.gw_id,
		node_gw.last_time AS latest_diag_time

FROM 
(
SELECT mm.meter_number , mm.node_id , meter_time.last_time 
FROM meter_mapping mm 
RIGHT join 
		(	SELECT meter_number, max(server_time) AS last_time
				FROM meter_profile_data mpd 
				WHERE "type" = 'Midnight_Profile'
				AND date_time = '2023-05-18 00:00:00.000'
				GROUP BY meter_number 
		) meter_time
ON mm.meter_number  = meter_time.meter_number 
) mid_meter
LEFT JOIN 
		(
		SELECT node_time.node_id, rd2.gw_id , node_time.last_time 
		FROM rf_diag rd2 
		RIGHT JOIN 
			(
				SELECT node_id , max(server_time) AS last_time  FROM rf_diag rd 
				WHERE node_id >= 400000
				GROUP BY node_id 
			) node_time
ON rd2.node_id = node_time.node_id
WHERE rd2.server_time = node_time.last_time
) node_gw
ON mid_meter.node_id = node_gw.node_id;


------------------------------------------------------------------------------------------------------------------------------------

SELECT mid_meter.meter_number,
		mid_meter.node_id,
		mid_meter.last_time AS latest_midnight_time,
		node_gw.gw_id,
		node_gw.last_time AS latest_diag_time

FROM 
(
SELECT mm.meter_number , mm.node_id , meter_time.last_time 
FROM meter_mapping mm 
left join 
		(	SELECT meter_number, max(server_time) AS last_time
				FROM meter_profile_data mpd 
				WHERE "type" = 'Midnight_Profile'
				AND date_time = '2023-05-18 00:00:00.000'
				GROUP BY meter_number 
		) meter_time
ON mm.meter_number  = meter_time.meter_number
WHERE meter_time.last_time IS null
) mid_meter
LEFT JOIN 
		(
		SELECT node_time.node_id, rd2.gw_id , node_time.last_time 
		FROM rf_diag rd2 
		RIGHT JOIN 
			(
				SELECT node_id , max(server_time) AS last_time  
				FROM rf_diag rd 
				WHERE node_id >= 400000
				GROUP BY node_id 
			) node_time
ON rd2.node_id = node_time.node_id
WHERE rd2.server_time = node_time.last_time
) node_gw
ON mid_meter.node_id = node_gw.node_id;


