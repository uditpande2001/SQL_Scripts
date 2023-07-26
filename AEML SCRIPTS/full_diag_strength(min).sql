select mm.meter_number,
    COALESCE(mm.node_id, diagnostic_data.node_id) AS node_id,
    diagnostic_data.gw_id,
    diagnostic_data.n_diag_latest_time,
    instant_data.instant_earliest_time,
    midnight_data.midnight_earliest_time
from meter_mapping mm
    left join (
        select meter_number,
            min(server_time) as instant_earliest_time,
            count(1) as instant_slot_count
        from meter_profile_data mpd
        where "type" = 'Instant_Profile'
            and server_time between '2023-05-15 00:00:00.000' and '2023-05-15 23:59:59.999'
        group by meter_number
    ) instant_data on mm.meter_number = instant_data.meter_number
    
     left join (
        select meter_number,
            min(server_time) as midnight_earliest_time,
            count(1) as midnight_slot_count
        from meter_profile_data mpd
        where "type" = 'Midnight_Profile'
             AND date_time = '2023-05-15 00:00:00.000'
        group by meter_number
    ) midnight_data on mm.meter_number = midnight_data.meter_number
        
    full outer join (
    	(
    	SELECT * 
    	FROM (
		        (SELECT COALESCE(nd.node_id, bd.node_id) AS node_id,
		            nd.n_diag_latest_time,
		            nd.n_diag_count,
		            nd.gw_id,
		            nd.sink_id,
		            nd.hop_count AS n_hop_count,
		            bd.b_diag_latest_time,
		            bd.b_diag_count,
		            bd.hop_count AS b_hop_count
		        FROM (
		                SELECT rd2.node_id,rd2.gw_id,rd2.sink_id,
		                    node_diag_data.n_diag_latest_time,
		                    node_diag_data.n_diag_count,
		                    rd2.hop_count
		                FROM rf_diag rd2
		                    RIGHT JOIN (
		                        SELECT node_id,
		                            max(server_time) AS n_diag_latest_time,
		                            COUNT(1) AS n_diag_count
		                        FROM rf_diag rd
		                        WHERE node_id >= 400000
		                            AND end_point LIKE '%253/255'
		                        GROUP BY node_id
		                    ) node_diag_data
		                     ON rd2.node_id = node_diag_data.node_id
		                where rd2.server_time = node_diag_data.n_diag_latest_time
		           
		            ) AS nd
		            FULL OUTER JOIN (
		                SELECT rd3.node_id,
		                    boot_diag_data.b_diag_latest_time,
		                    boot_diag_data.b_diag_count,
		                    rd3.hop_count
		                FROM rf_diag rd3
		                    RIGHT JOIN (
		                        SELECT node_id,
		                           max(server_time) AS b_diag_latest_time,
		                            COUNT(1) AS b_diag_count
		                        FROM rf_diag rd
		                        WHERE node_id >= 400000
		                            AND end_point LIKE '%254/255'
		                        GROUP BY node_id
		                    ) boot_diag_data ON rd3.node_id = boot_diag_data.node_id
		                where rd3.server_time = boot_diag_data.b_diag_latest_time
		            ) AS bd
		            ON nd.node_id = bd.node_id
		            ) diag_d
		            LEFT JOIN 
					(        
		            		SELECT dcu_health_data.hub_uuid,
							dcu_health_data.latest_dcu_health,
							dcu_health_data.dcu_health_count,
							dcu_signal.signal_strength
					FROM  
						(
						SELECT hub_uuid , max(health_time) AS latest_dcu_health,
								count(hub_uuid) AS dcu_health_count
						FROM  dcu_health dh
						WHERE health_time BETWEEN '2023-05-15 00:00:00.000' and '2023-05-15 23:59:59.999'
						GROUP BY hub_uuid
						) dcu_health_data
						
						LEFT join
								(
								SELECT hub_uuid ,signal_strength,health_time
								FROM dcu_health dh 
								WHERE health_time BETWEEN  '2023-05-15 00:00:00.000' and '2023-05-15 23:59:59.999'
								) dcu_signal 
						ON dcu_health_data.hub_uuid = dcu_signal.hub_uuid
						WHERE dcu_health_data.latest_dcu_health = dcu_signal.health_time  
		            ) health_d
		           ON diag_d.gw_id = health_d.hub_uuid
   				 )
    ))diagnostic_data on mm.node_id = diagnostic_data.node_id;