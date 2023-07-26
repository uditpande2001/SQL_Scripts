(SELECT  diag_mid.node_id ,
		instant .earliest_instant,
		diag_mid.earliest_midnight,
		diag_mid.diag_time_latest,
		diag_mid.gw_for_midnight_given
FROM 
(SELECT node_id ,min(server_time) earliest_instant
FROM meter_profile_data mpd 
WHERE "type" = 'Instant_Profile'
AND server_time >= '2023-04-21 00:00:00'
GROUP BY node_id) instant 
RIGHT join
		(SELECT mid_given.node_id,
				mid_given.earliest_midnight,
				diag_midnight.latest_diag_time AS diag_time_latest,
				diag_midnight.gw_id AS gw_for_midnight_given 
				FROM
		(SELECT  latest_diag.node_id, rd.gw_id ,latest_diag.latest_diag_time
		FROM rf_diag rd 
		RIGHT join
		(SELECT node_id ,max(server_time) latest_diag_time
		FROM rf_diag rd 
		GROUP BY node_id) latest_diag
		ON rd.node_id = latest_diag.node_id
		WHERE rd.server_time = latest_diag.latest_diag_time) diag_midnight
		RIGHT join
		(SELECT node_id  , min(server_time) AS earliest_midnight
		FROM meter_profile_data mpd 
		WHERE "type" = 'Midnight_Profile'
		AND server_time >= '2023-04-20 22:00:00'
		and date_time = '2023-04-21 00:00:00'
		GROUP BY node_id) mid_given 
		ON mid_given.node_id = diag_midnight.node_id)diag_mid
ON instant.node_id = diag_mid.node_id) midnight_given_final



(SELECT mid_not_given.node_id ,mid_not_given.diag_latest_NO_midnight,gw_id  AS gw_for_NO_midnight
FROM rf_diag rd 
RIGHT join
(SELECT node_id  , max(server_time) AS diag_latest_NO_midnight
FROM rf_diag rd
WHERE node_id >=400000
and node_id NOT IN (	SELECT node_id
						FROM meter_profile_data mpd 
						WHERE "type" = 'Midnight_Profile'
						AND server_time >= '2023-04-20 22:00:00'
						and date_time = '2023-04-21 00:00:00'
						GROUP BY node_id)
GROUP BY node_id) mid_not_given
ON rd.node_id = mid_not_given.node_id
WHERE rd.server_time = mid_not_given.diag_latest_NO_midnight)

										








