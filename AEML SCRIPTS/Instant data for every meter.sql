SELECT 	mm.meter_number ,
		mm.node_id,
		instant_data.slot_count,
		instant_data.last_time
FROM meter_mapping mm 
LEFT join
(SELECT meter_slot.meter_number,
		mpd.node_id,
		meter_slot.slot_count,
		meter_slot.last_time
FROM meter_profile_data mpd 
left join
			(SELECT meter_number ,
					count(meter_number) AS slot_count,
					max(server_time) AS last_time
			FROM meter_profile_data mpd 
			WHERE "type" = 'Instant_Profile'
			AND server_time between '2023-04-12 00:00:00' and '2023-04-12 23:59:59'
			GROUP BY meter_number) meter_slot 
			ON mpd .meter_number = meter_slot.meter_number
			WHERE mpd.server_time = meter_slot.last_time) instant_data
ON mm.meter_number = instant_data.meter_number
WHERE mm.node_id = instant_data.node_id
ORDER BY slot_count  ;