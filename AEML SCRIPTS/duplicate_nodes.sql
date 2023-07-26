SELECT * from
(SELECT *, ROW_NUMBER () OVER (PARTITION  BY mm.node_id ORDER BY node_id ) AS rn
FROM meter_mapping mm )checkF
WHERE rn = 2



