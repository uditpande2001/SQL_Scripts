


SELECT required_dcu.hub_uuid,
required_dcu.max_health_time,
required_dcu.slot_count,
signal_strength ,sim_ip , sim_operator , "version" 
FROM dcu_health dh 
RIGHT join
			(SELECT hub_uuid , max(health_time) AS max_health_time, count(hub_uuid) slot_count
			FROM dcu_health dh 
			WHERE sim_ip IS NOT NULL AND sim_operator  IS NOT NULL 
			AND sim_operator <> '' AND sim_ip <> ''
			GROUP BY hub_uuid ) required_dcu
ON dh.hub_uuid = required_dcu.hub_uuid
WHERE dh.health_time = required_dcu.max_health_time;


select dh2.hub_uuid , dh2.health_time , dh2.signal_strength , dh2.sim_ip , dh2.sim_operator , dh2."version" ,
dh2.selected_sim, dh2.sim_serial_no 
from dcu_health dh2 
right join 
(
    select hub_uuid , max(health_time) as last_ht  from dcu_health dh 
    where sim_ip is not null and sim_ip <> '' and sim_operator is not null  and sim_operator <> ''
    group by hub_uuid 
) dcu_lt
on dh2.hub_uuid = dcu_lt.hub_uuid
where dh2.health_time = dcu_lt.last_ht;







