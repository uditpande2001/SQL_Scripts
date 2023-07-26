SELECT mm.node_id , mm.meter_number ,
        node_diag.gw_id,node_diag.latest_diag_time,node_diag.diag_slots,
        node_instant.latest_instant_time,node_instant.instant_slots
        
FROM meter_mapping mm 
LEFT join    
            (SELECT    rd.node_id , gw_id, req_diag.latest_diag_time, req_diag.diag_slots 
            FROM rf_diag rd 
            RIGHT JOIN    
                        (SELECT node_id , max(server_time) AS latest_diag_time, count(1) AS diag_slots 
                        FROM rf_diag rd WHERE server_time BETWEEN '2023-05-25 00:00:00.000' AND '2023-05-25 23:59:59.999'
                        AND node_id >=400000 
                        AND end_point LIKE '%253%'
                        GROUP BY node_id) req_diag
            ON rd.node_id = req_diag.node_id
            WHERE rd.server_time = req_diag.latest_diag_time) node_diag
ON mm.node_id = node_diag.node_id        
LEFT JOIN 
            (SELECT node_id , max(server_time) AS latest_instant_time , count(1) AS instant_slots
            FROM meter_profile_data mpd 
            WHERE server_time BETWEEN '2023-05-25 00:00:00.000' AND '2023-05-25 23:59:59.999'
            AND "type" = 'Instant_Profile'
            GROUP BY node_id) node_instant
ON mm.node_id = node_instant.node_id
