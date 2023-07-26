
                            
                            
                            
                SELECT billing_not_received.node_id,
                diag_data.gw_id
                      FROM
                            (SELECT latest_diag.node_id,
                            rd.gw_id,
                            latest_diag.latest_diag_time
                            FROM rf_diag rd
                            RIGHT join
			                            ( 
			                            SELECT rd.node_id ,
			                            		max(server_time) AS latest_diag_time
			                            FROM rf_diag rd
			                            WHERE server_time >= '2023-04-25 08:00:00.000' AND node_id >=400000
			                            GROUP BY node_id) latest_diag
			                            ON rd.node_id = latest_diag.node_id
			                            WHERE rd.server_time = latest_diag.latest_diag_time) diag_data
                            RIGHT JOIN
			                            (SELECT mm.meter_number ,
					                            mm.node_id ,
					                            billing_given.date_time
			                            FROM meter_mapping mm
			                            left join
					                            (
					                            SELECT DISTINCT meter_number ,
					                            node_id ,
					                            date_time
					                            FROM meter_profile_data mpd
					                            WHERE "type" = 'Billing_Profile'
					                            AND date_time = '2023-04-01 00:00:00.000') billing_given
					                            ON mm.meter_number = billing_given.meter_number					                            
					                            ) billing_not_received
			                            ON diag_data.node_id = billing_not_received.node_id
			                            WHERE billing_not_received.date_time IS NULL 