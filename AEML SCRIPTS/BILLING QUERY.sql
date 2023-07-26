			 SELECT mid_not_received.node_id,
						diag_data.gw_id
						
					FROM 
					(SELECT latest_diag.node_id,
							rd.gw_id,
							latest_diag.latest_diag_time
					FROM rf_diag rd 
						RIGHT join
							( SELECT rd.node_id ,
										max(server_time) AS latest_diag_time  
								FROM rf_diag rd 
								WHERE server_time >= '2023-04-18 09:00:00.000' AND node_id >=400000
								GROUP BY node_id) latest_diag
						ON rd.node_id = latest_diag.node_id
						WHERE rd.server_time = latest_diag.latest_diag_time) diag_data
				RIGHT JOIN 	
									(SELECT mm.meter_number ,
										mm.node_id ,
										midnight_given.date_time
								FROM meter_mapping mm
								left join
											(	SELECT DISTINCT meter_number ,
													node_id ,
													date_time
											FROM meter_profile_data mpd 
											WHERE "type" = 'Billing_Profile'
											AND date_time = '2023-04-01 00:00:00') midnight_given
								ON mm.meter_number = midnight_given.meter_number
								WHERE midnight_given.date_time IS  NULL) mid_not_received
				ON diag_data.node_id = mid_not_received.node_id
				
					