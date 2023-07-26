
		select 			mm.meter_number ,
						latest_diag_data.node_id,
						latest_diag_data.b_diag_latest_time,
						latest_diag_data.b_diag_count,
						latest_diag_data.b_hop_count,
						latest_diag_data.n_diag_latest_time,
						latest_diag_data.n_diag_count,
						latest_diag_data.n_hop_count
		
		from meter_mapping mm
		right join
		(select coalesce (boot_diag.node_id , node_diag.node_id)  as node_id,
						boot_diag.b_diag_latest_time,
						boot_diag.b_diag_count,
						boot_diag.b_hop_count,
						node_diag.n_diag_latest_time,
						node_diag.n_diag_count,
						node_diag.n_hop_count	
		from
				(select  bd_data.node_id,
						bd_data.b_diag_latest_time,
						bd_data.b_diag_count,
						rd.hop_count as b_hop_count
				from rf_diag rd 
				right join
						(select node_id , max(server_time) as b_diag_latest_time, count(1) as b_diag_count
						from rf_diag rd 
						where node_id >= 400000 and end_point like '%254%'
						and server_time BETWEEN '2023-03-27 00:00:00.000' AND '2023-03-27 23:59:59.999'
						group by node_id) bd_data
				on rd.node_id = bd_data.node_id
				where rd.server_time = bd_data.b_diag_latest_time) boot_diag	
		full outer join	 
				(select  nd_data.node_id,
						nd_data.n_diag_latest_time,
						nd_data.n_diag_count,
						rd.hop_count as n_hop_count
				from rf_diag rd 
				right join
						(select node_id , max(server_time) as n_diag_latest_time, count(1) as n_diag_count
						from rf_diag rd 
						where node_id >= 400000 and end_point like '%253%'
						and	server_time BETWEEN '2023-03-27 00:00:00.000' AND '2023-03-27 23:59:59.999'
						group by node_id) nd_data
				on rd.node_id = nd_data.node_id
				where rd.server_time = nd_data.n_diag_latest_time) node_diag
				on boot_diag.node_id = node_diag.node_id) latest_diag_data
				on mm.node_id = latest_diag_data.node_id

				--as Sir for left join
				
				
				