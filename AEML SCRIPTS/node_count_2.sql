
select coalesce(node_count_final.gw_id, sink_count_final.gw_id) as gw_id ,
				node_count_final.node_count,
				sink_count_final.sink_count
from
(select gw_id, count(node_id) as sink_count from 
		(select rd2.gw_id ,
			   node_last_time.node_id 
			   from rf_diag rd2 
		right join (
					select
					node_id ,
					max(server_time) as latest_time
					from rf_diag rd 
					group by node_id
					) node_last_time
		on rd2.node_id = node_last_time.node_id
		where rd2.server_time = node_last_time.latest_time
		and rd2.node_id < 400000
		) gw_node
	group by gw_node.gw_id) sink_count_final
full outer join		
(select gw_id, count(node_id) as node_count  from 
		(select rd2.gw_id ,
			   node_last_time.node_id 
			   from rf_diag rd2 
		right join (
					select
					node_id ,
					max(server_time) as latest_time
					from rf_diag rd 
					group by node_id
					) node_last_time
		on rd2.node_id = node_last_time.node_id
		where rd2.server_time = node_last_time.latest_time
		and rd2.node_id >= 400000
		) gw_node
	group by gw_node.gw_id ) node_count_final 
on node_count_final.gw_id = sink_count_final.gw_id