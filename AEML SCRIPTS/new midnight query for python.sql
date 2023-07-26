SELECT node_id , gw_id 
			FROM rf_diag rd 
			WHERE server_time >= ' 2023-04-19 12:00:000'
			AND node_id >=400000
			AND node_id NOT IN



				SELECT node_id  ,max(server_time) 
				FROM rf_diag rd 
				WHERE server_time >= ' 2023-04-19 12:00:000'
				AND node_id >=400000
				AND node_id NOT IN	(
										SELECT DISTINCT node_id 
										FROM meter_profile_data mpd 
										WHERE "type" = 'Midnight_Profile'
										AND server_time >= '2023-04-18 22:00:00')
										GROUP BY node_id LIMIT 5000;
									
									
									SELECT *
									FROM meter_profile_data mpd 
									WHERE "type" = 'Midnight_Profile'
									AND node_id = 438213






			