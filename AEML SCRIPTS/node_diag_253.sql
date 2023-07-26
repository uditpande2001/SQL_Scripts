			 SELECT rd2.node_id,
                    node_diag_data.n_diag_latest_time,
                    node_diag_data.n_diag_count,
                    rd2.hop_count
                FROM rf_diag rd2
                    RIGHT JOIN (
                        SELECT node_id,
                            MAX(server_time) AS n_diag_latest_time,
                            COUNT(1) AS n_diag_count
                        FROM rf_diag rd
                        WHERE node_id >= 400000
                            AND server_time BETWEEN '2023-04-27 00:00:00.000' AND '2023-04-27 23:59:59.999'
                            AND end_point LIKE '%253%'
                        GROUP BY node_id
                    ) node_diag_data
                     ON rd2.node_id = node_diag_data.node_id
                where rd2.server_time = node_diag_data.n_diag_latest_time