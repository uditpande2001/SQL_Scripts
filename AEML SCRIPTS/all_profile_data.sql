SELECT DISTINCT node_id 
FROM meter_profile_data mpd 
WHERE server_time >='2023-06-20 00:00:00.000'
AND "type" = 'Midnight_Profile'
and node_id IN (SELECT DISTINCT node_id 
				FROM meter_profile_data mpd 
				WHERE server_time >='2023-06-20 00:00:00.000'
				AND "type" = 'Instant_Profile'
				AND node_id IN (SELECT DISTINCT node_id 
								FROM meter_profile_data mpd 
								WHERE server_time >='2023-06-20 00:00:00.000'
								AND "type" = 'Load_Profile'
								AND node_id IN (SELECT DISTINCT node_id 
												FROM meter_profile_data mpd 
												WHERE server_time >='2023-06-20 00:00:00.000'
												AND "type" = 'Event_Profile'
												AND node_id IN (
												SELECT DISTINCT node_id 
												FROM meter_profile_data mpd 
												WHERE server_time >='2023-06-20 00:00:00.000'
												AND "type" = 'Billing_Profile'))))
												
												
												
-- Query for Midnight_Profile
SELECT  node_id
FROM meter_profile_data
WHERE server_time >= '2023-06-20 00:00:00.000' AND type = 'Midnight_Profile'
INTERSECT
-- Query for Instant_Profile
SELECT  node_id
FROM meter_profile_data
WHERE server_time >= '2023-06-20 00:00:00.000' AND type = 'Instant_Profile'
INTERSECT
-- Query for Load_Profile
SELECT  node_id
FROM meter_profile_data
WHERE server_time >= '2023-06-20 00:00:00.000' AND type = 'Load_Profile'
INTERSECT
-- Query for Event_Profile
SELECT  node_id
FROM meter_profile_data
WHERE server_time >= '2023-06-20 00:00:00.000' AND type = 'Event_Profile'
INTERSECT
-- Query for Billing_Profile
SELECT  node_id
FROM meter_profile_data
WHERE server_time >= '2023-06-20 00:00:00.000' AND type = 'Billing_Profile';




