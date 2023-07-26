				
				 
	WITH temp1 AS (	SELECT 	rd2.node_id,rd2.gw_id,rd2.hop_count
		                
                FROM rf_diag rd2
                left JOIN (
	                        SELECT node_id,max(server_time) AS n_diag_latest_time
	                        FROM rf_diag rd
	                        WHERE node_id >= 400000	
	                        AND server_time  >= '2023-07-18 00:00:00' AND server_time <= '2023-07-18 23:59:59'	     
			                GROUP BY node_id
			                ) node_diag_data
			                     ON rd2.node_id = node_diag_data.node_id where rd2.server_time = node_diag_data.n_diag_latest_time
			         ),
                  
 			
		temp2 AS 	(
							SELECT dcu_health_data.hub_uuid,
	 						dcu_signal.signal_strength,dcu_signal."version"
							FROM  
							(
							SELECT hub_uuid , max(health_time) AS latest_dcu_health, count(hub_uuid) AS dcu_health_count
							FROM  dcu_health dh
							WHERE health_time BETWEEN '2023-07-18 00:00:00.000' and '2023-07-18 23:59:59.999'
							GROUP BY hub_uuid
							) dcu_health_data
							
							LEFT join
									(
									SELECT hub_uuid ,signal_strength,health_time,"version"
									FROM dcu_health dh 
									WHERE health_time BETWEEN  '2023-07-18 00:00:00.000' and '2023-07-18 23:59:59.999'
									) dcu_signal 
							ON dcu_health_data.hub_uuid = dcu_signal.hub_uuid
							WHERE dcu_health_data.latest_dcu_health = dcu_signal.health_time),
		temp3 AS ( SELECT * FROM meter_mapping mm  )					
														
SELECT temp1.node_id,temp3.meter_number, temp1.gw_id, temp2.signal_strength, temp2."version" AS dcu_fw_version_
FROM temp1
LEFT JOIN temp2 ON temp1.gw_id = temp2.hub_uuid 
LEFT JOIN temp3 ON temp1.node_id = temp3.node_id
	            		
	            		 
               		