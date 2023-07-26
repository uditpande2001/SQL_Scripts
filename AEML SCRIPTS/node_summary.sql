select mm.meter_number , COALESCE(mm.node_id, diagnostic_data.node_id) AS node_id, n.fw_version ,
diagnostic_data.n_diag_latest_time, diagnostic_data.n_diag_count, diagnostic_data.n_hop_count, 
diagnostic_data.b_diag_latest_time, diagnostic_data.b_diag_count, diagnostic_data.b_hop_count, 
instant_data.instant_latest_time, instant_data.slot_count,
init_data.init_latest_time, init_data.init_count 
from meter_mapping mm 

left join (
    select meter_number ,max(server_time) as instant_latest_time  , count(1) as slot_count from meter_profile_data mpd
    where "type" = 'Instant_Profile' and server_time between '2023-04-18 00:00:00.000' and '2023-04-18 23:59:59.999' 
    group by meter_number) instant_data on mm.meter_number = instant_data.meter_number

left join (
    select meter_number , max(server_time) as init_latest_time , count(1) as init_count  from node_init ni
    where server_time between '2023-04-18 00:00:00.000' and '2023-04-18 23:59:59.999'
    group by meter_number) init_data on mm.meter_number = init_data.meter_number

full outer join (
    SELECT 
        COALESCE(nd.node_id, bd.node_id) AS node_id, 
        nd.n_diag_latest_time, 
        nd.n_diag_count, 
        nd.hop_count AS n_hop_count, 
        bd.b_diag_latest_time, 
        bd.b_diag_count, 
        bd.hop_count AS b_hop_count
    FROM (
        SELECT 
            rd2.node_id, 
            node_diag_data.n_diag_latest_time, 
            node_diag_data.n_diag_count, 
            rd2.hop_count 
        FROM rf_diag rd2
        RIGHT JOIN (
            SELECT 
                node_id, 
                MAX(server_time) AS n_diag_latest_time, 
                COUNT(1) AS n_diag_count 
            FROM rf_diag rd 
            WHERE 
                node_id >= 400000 
                AND server_time BETWEEN '2023-04-18 00:00:00.000' AND '2023-04-18 23:59:59.999' 
                AND end_point LIKE '%253%' 
            GROUP BY node_id
        ) node_diag_data 
        ON rd2.node_id = node_diag_data.node_id 
        where rd2.server_time = node_diag_data.n_diag_latest_time
    ) AS nd
    FULL OUTER JOIN (
        SELECT 
            rd3.node_id, 
            boot_diag_data.b_diag_latest_time, 
            boot_diag_data.b_diag_count, 
            rd3.hop_count 
        FROM rf_diag rd3 
        RIGHT JOIN (
            SELECT 
                node_id, 
                MAX(server_time) AS b_diag_latest_time, 
                COUNT(1) AS b_diag_count 
            FROM rf_diag rd 
            WHERE 
                node_id >= 400000
                AND server_time BETWEEN '2023-04-18 00:00:00.000' AND '2023-04-18 23:59:59.999' 
                AND end_point LIKE '%254%' 
            GROUP BY node_id
        ) boot_diag_data 
        ON rd3.node_id = boot_diag_data.node_id 
        where rd3.server_time = boot_diag_data.b_diag_latest_time
    ) AS bd
    ON nd.node_id = bd.node_id) diagnostic_data
    on mm.node_id = diagnostic_data.node_id

left join node n 
on mm.node_id = n.node_id ;