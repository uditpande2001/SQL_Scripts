
select
latest_data.node_id,
latest_data.latest_time,
rd2.gw_id,
latest_data.slot_count
from rf_diag rd2 
right join
			(
				select node_id ,max(server_time) as latest_time,count(node_id) AS slot_count 
				from rf_diag rd 
				where server_time between '2023-04-10 00:00:00.000' and '2023-04-10 23:59:59.999' and node_id > 400000
				group by node_id 
				) latest_data 
on rd2 .node_id = latest_data.node_id
where rd2 .server_time = latest_data.latest_time