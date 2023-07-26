--nodes permanently attached to this dcu

select DISTINCT node_id
from rf_diag rd 
where gw_id = '867881049853588'
and rd.server_time between '2023-04-26 08:00:00' and  '2023-04-26 11:00:00'
and not exists (select 1
				from rf_diag rd2
				where rd2.node_id = rd.node_id
				and rd2.gw_id <> '867881049853588' 
				and rd2.server_time between '2023-04-26 08:00:00' and  '2023-04-26 11:00:00');



--freq changing nodes
with temp as 
(select rd.node_id ,concat(gw_id,sink_id) as cur,lead(concat(gw_id,sink_id)) over (PARTITION BY rd.node_id ORDER BY server_time DESC) as nextcur
from rf_diag rd 
join test t on rd.node_id = t.node_id 
where rd.server_time between '2023-06-19 00:00:00.000' AND '2023-06-19 23:59:59.999'
) select count(1),node_id from temp where cur <> nextcur and nextcur is not null 
group by node_id having count(1) > 3;







-- changing sink and gw
SELECT DISTINCT node_id , sink_id ,gw_id 
FROM rf_diag rd 
WHERE server_time BETWEEN '2023-05-18 00:00:00.000' AND '2023-05-18 23:59:59.999' 
AND node_id >= 400000
ORDER BY node_id ;