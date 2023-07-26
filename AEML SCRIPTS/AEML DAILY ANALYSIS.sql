--QUERY 1
WITH t1 AS
		(
		
			SELECT rd.node_id , rd.gw_id, req_data.latest_diag
			FROM rf_diag rd 
			LEFT join
					(	SELECT node_id , max(server_time) AS latest_diag
						FROM rf_diag rd 
						WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999'
						AND node_id >= 400000
						GROUP BY node_id ) req_data 
			ON rd.node_id = req_data.node_id
			WHERE rd.server_time = req_data.latest_diag

		),
		
	t2 AS (
			SELECT DISTINCT node_id 
			FROM meter_profile_data mpd 
			WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999'
		),
	t3 AS (
			SELECT *
			FROM node n 
			)

SELECT t1.node_id, t1.gw_id,t1.latest_diag,t3.fw_version
FROM t1
LEFT JOIN t2 ON t1.node_id = t2.node_id
LEFT JOIN t3 ON t1.node_id = t3.node_id
WHERE t2 IS NULL 
--AND t1.latest_diag >= '2023-06-29 10:00:00.000';


--QUERY 2
WITH t1 AS (
			 SELECT DISTINCT node_id 
			 FROM command_response cr 
			 WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999'
			 AND command_type IN ('ENABLE_ALL', 'DISABLE_ALL')
			),
	t2 AS  (
			SELECT *
			FROM packet_loss pl 
			WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999'
			AND command_type ='P_READ_BILLING'
			),
	T3 AS (
	    	SELECT *
	    	FROM meter_profile_data mpd 
	    	WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999'
	    	AND "type" = 'Billing_Profile'
			),
	t4 AS (
			SELECT *
			FROM node n 
			)

SELECT t1.node_id, t4.fw_version
FROM t1
LEFT JOIN t2 ON t1.node_id = t2.node_id 
LEFT JOIN t3 ON t1.node_id = t3.node_id
LEFT JOIN t4 ON t4.node_id = t1.node_id
WHERE t2 IS NULL AND t3 IS NULL;

--query 3

			
SELECT enable_count.node_id,enable_count.Enable_all_count, enable_count.latest_time AS enable_latest_time,
		enable_data.command_id AS enable_command_id
FROM 
(SELECT node_id , count(1) AS Enable_all_count ,max(server_time) AS latest_time  
FROM command_response cr 
WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999'
AND command_type = 'ENABLE_ALL' AND status ='ACCEPTED'
GROUP BY node_id) enable_count
LEFT JOIN 
		(SELECT *
			FROM command_response cr 
			WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999') enable_data
ON enable_count.node_id = enable_data.node_id
WHERE enable_count.latest_time = enable_data.server_time
ORDER BY node_id ;

--query 4

SELECT disable_count.node_id,disable_count.disable_all_count, disable_count.latest_time AS disable_latest_time,
		disable_data.command_id AS disable_command_id
FROM 
(SELECT node_id , count(1) AS disable_all_count ,max(server_time) AS latest_time  
FROM command_response cr 
WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999'
AND command_type = 'DISABLE_ALL' AND status ='ACCEPTED'
GROUP BY node_id) disable_count
LEFT JOIN 
		(SELECT *
			FROM command_response cr 
			WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999') disable_data
ON disable_count.node_id = disable_data.node_id
WHERE disable_count.latest_time = disable_data.server_time
ORDER BY node_id ;

--query 5

WITH profile_data AS (            
                      SELECT *, ROW_NUMBER() OVER (PARTITION BY node_id ORDER BY server_time desc) AS rn
                      FROM meter_profile_data mpd 
                      WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999'
                            )

SELECT node_id, server_time,"type"
FROM profile_data mpd WHERE rn = 1

---query 6

WITH init_data AS (            
                      SELECT *, ROW_NUMBER() OVER (PARTITION BY node_id ORDER BY server_time desc) AS rn,
                      			count(1) OVER (PARTITION BY node_id) 
                      FROM node_init ni 
                      WHERE server_time BETWEEN '2023-07-10 00:00:00.000' AND '2023-07-10 23:59:59.999'
                            )

SELECT node_id, server_time, count AS init_count
FROM init_data mpd WHERE rn = 1

			







			
 
								
		
		
		
