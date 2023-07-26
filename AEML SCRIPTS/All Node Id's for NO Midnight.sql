	
SELECT node_gw.gw_id, required_meters.node_id FROM 
(
	SELECT rd2.gw_id, diag_data.node_id 
	FROM rf_diag rd2 
	RIGHT JOIN 
		(
			SELECT node_id , max(server_time) latest_diag_time
			FROM rf_diag rd 
			WHERE server_time >= '2023-04-10 14:00:00' AND node_id >= 400000
			GROUP BY node_id
		) diag_data
	ON rd2.node_id = diag_data.node_id
	WHERE rd2.server_time = diag_data.latest_diag_time
) node_gw
RIGHT JOIN  
	(
		SELECT mm.meter_number, mm.node_id ,
				mid_night.date_time,
				mid_night.latest_server_time
		FROM meter_mapping mm 
		LEFT join		
					(SELECT meter_list.meter_number,mid_data.node_id,
							mid_data.date_time, meter_list.latest_server_time
					FROM 
					(		
						SELECT	meter_number,
								node_id ,
								server_time,
								date_time
						FROM meter_profile_data mpd
						WHERE "type" = 'Midnight_Profile' AND date_time = '2023-04-10 00:00:00.000'
					) mid_data	
					RIGHT JOIN 	
							(
								select meter_number , max(server_time) as latest_server_time
								from meter_profile_data mpd 
								where "type" ='Midnight_Profile'
								and date_time = '2023-04-10 00:00:00.000' 
								and meter_number not like '%:%'
								GROUP BY meter_number
							) meter_list
					ON mid_data.meter_number = meter_list.meter_number
					WHERE mid_data.server_time = meter_list.latest_server_time) mid_night
			ON 	mm.meter_number = mid_night.meter_number
		    WHERE mid_night.date_time IS NULL
    ) required_meters
ON node_gw.node_id = required_meters.node_id
				
			
			 
							
							
							
							
							
							
							