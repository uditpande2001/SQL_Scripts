WITH load_data AS (SELECT meter_number , count(DISTINCT date_time) AS load_count
					FROM meter_profile_data mpd 
					WHERE date_time >= '2023-07-18 00:00:00' AND date_time <= '2023-07-18 23:59:59' AND "type" = 'Load_Profile' 
					GROUP BY  meter_number),
	 instant_data AS (SELECT meter_number , count(DISTINCT date_time) AS instant_count
					FROM meter_profile_data mpd 
					WHERE date_time >= '2023-07-18 00:00:00' AND date_time <= '2023-07-18 23:59:59' AND "type" = 'Instant_Profile' 
					GROUP BY  meter_number),
	midnight_data AS (SELECT meter_number , count(DISTINCT date_time) AS midnight_count
					FROM meter_profile_data mpd 
					WHERE date_time >= '2023-07-18 00:00:00' AND date_time <= '2023-07-18 23:59:59' AND "type" = 'Midnight_Profile' 
					GROUP BY  meter_number),
					
	 diag_data AS  (SELECT rd2.node_id,rd2.gw_id,rd2.sink_id,
                    node_diag_data.n_diag_latest_time,
                    node_diag_data.n_diag_count,
                    rd2.hop_count
	                FROM rf_diag rd2
                    RIGHT JOIN (
		                        SELECT node_id,max(server_time) AS n_diag_latest_time,COUNT(1) AS n_diag_count
		                        FROM rf_diag rd
		                        WHERE node_id >= 400000	
		                        AND server_time  >= '2023-07-18 00:00:00' AND server_time <= '2023-07-18 23:59:59'	     
		                        GROUP BY node_id
		                    ) node_diag_data
		                     ON rd2.node_id = node_diag_data.node_id where rd2.server_time = node_diag_data.n_diag_latest_time
							
							
		)

	SELECT mm.meter_number , mm.node_id , load_data.load_count, instant_data.instant_count,midnight_data.midnight_count,
			diag_data.gw_id, diag_data.hop_count
	FROM meter_mapping mm 
	LEFT JOIN load_data ON mm.meter_number = load_data.meter_number
	LEFT JOIN instant_data ON mm.meter_number = instant_data.meter_number
	LEFT JOIN midnight_data ON mm.meter_number = midnight_data.meter_number
	LEFT JOIN diag_data ON mm.node_id  = diag_data.node_id
	 
	
	