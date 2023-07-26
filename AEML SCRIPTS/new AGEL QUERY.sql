WITH load_data AS (SELECT meter_number , count(DISTINCT date_time) AS load_count
					FROM meter_profile_data mpd 
					WHERE date_time >= '2023-07-13 00:00:00' AND date_time <= '2023-07-13 23:59:59' AND "type" = 'Load_Profile' 
					GROUP BY  meter_number),
	 instant_data AS (SELECT meter_number , count(DISTINCT date_time) AS instant_count
					FROM meter_profile_data mpd 
					WHERE date_time >= '2023-07-13 00:00:00' AND date_time <= '2023-07-13 23:59:59' AND "type" = 'Instant_Profile' 
					GROUP BY  meter_number),
	midnight_data AS (SELECT meter_number , count(DISTINCT date_time) AS midnight_count
					FROM meter_profile_data mpd 
					WHERE date_time >= '2023-07-13 00:00:00' AND date_time <= '2023-07-13 23:59:59' AND "type" = 'Midnight_Profile' 
					GROUP BY  meter_number),
	init_data AS    (SELECT node_id , count(1) AS init_count
					FROM node_init ni 
					WHERE server_time >= '2023-07-13 00:00:00' AND server_time <= '2023-07-13 23:59:59'
					GROUP BY node_id)

	SELECT mm.meter_number , mm.node_id , load_data.load_count, instant_data.instant_count,midnight_data.midnight_count,init_data.init_count
	FROM meter_mapping mm 
	LEFT JOIN load_data ON mm.meter_number = load_data.meter_number
	LEFT JOIN instant_data ON mm.meter_number = instant_data.meter_number
	LEFT JOIN midnight_data ON mm.meter_number = midnight_data.meter_number
	LEFT JOIN init_data ON mm.node_id = init_data.node_id
	
	

					