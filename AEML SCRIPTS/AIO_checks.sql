SELECT *
FROM meter_mapping mm 
WHERE meter_number = 'SM30050124';

SELECT *
FROM rf_diag  
WHERE node_id =400381 
AND server_time BETWEEN '2023-04-010 00:00:00.000' AND '2023-04-010 23:59:59';

SELECT *
FROM dcu_health dh 
WHERE hub_uuid = '861261056662386'
AND health_time BETWEEN '2023-04-010 00:00:00.000' AND '2023-04-010 23:59:59';

SELECT *
FROM meter_profile_data mpd 
WHERE node_id = 501538
AND "type" = 'Billing_Profile'
AND date_time BETWEEN '2023-04-010 00:00:00.000' AND '2023-04-010 23:59:59'
AND server_time BETWEEN '2023-04-010 00:00:00.000' AND '2023-04-010 23:59:59';

SELECT *
FROM node_init ni 
WHERE node_id = 447158
AND server_time BETWEEN '2023-04-010 00:00:00.000' AND '2023-04-010 23:59:59';

SELECT *
FROM meter_profile_data mpd 
WHERE meter_number  = 'SM10285687'
AND "type" = 'Instant_Profile'
AND server_time BETWEEN '2023-04-010 00:00:00.000' AND '2023-04-010 23:59:59';


SELECT *
FROM meter_profile_data mpd 
WHERE meter_number  = 'SM10285687'
AND "type" = 'Midnight_Profile'
AND server_time BETWEEN '2023-04-09 22:00:00.000' AND '2023-04-010 23:59:59'
ORDER BY server_time DESC ;

SELECT *
FROM meter_profile_data mpd 
WHERE node_id = 400381
AND "type" = 'Load_Profile'
AND server_time BETWEEN '2023-04-010 00:00:00.000' AND '2023-04-010 23:59:59';


