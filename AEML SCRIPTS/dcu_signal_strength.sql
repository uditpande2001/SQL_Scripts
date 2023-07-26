SELECT dcu_health_data.hub_uuid,
		dcu_health_data.latest_dcu_health,
		dcu_health_data.dcu_health_count,
		dcu_signal.signal_strength
FROM  
	(
	SELECT hub_uuid , max(health_time) AS latest_dcu_health,
			count(hub_uuid) AS dcu_health_count
	FROM  dcu_health dh
	WHERE health_time BETWEEN '2023-04-10 00:00:00.000' and '2023-04-10 23:59:59.999'
	GROUP BY hub_uuid
	) dcu_health_data
	
	LEFT join
			(
			SELECT hub_uuid ,signal_strength,health_time
			FROM dcu_health dh 
			WHERE health_time BETWEEN  '2023-04-10 00:00:00.000' and '2023-04-10 23:59:59.999'
			) dcu_signal 
	ON dcu_health_data.hub_uuid = dcu_signal.hub_uuid
	WHERE dcu_health_data.latest_dcu_health = dcu_signal.health_time