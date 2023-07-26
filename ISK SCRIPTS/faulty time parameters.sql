WITH TEMP AS (SELECT *, ROW_NUMBER() OVER(PARTITION BY node_id ORDER BY server_time desc) AS rn
				FROM meter_profile_data mpd 
				)
SELECT meter_number, date_time , server_time ,  sensor_time , tor , "type" 
FROM TEMP 
WHERE rn = 1 
AND EXTRACT (YEAR FROM date_time) <> 2023
ORDER BY meter_number 
