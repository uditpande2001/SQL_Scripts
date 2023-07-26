

		select
		mm.meter_number ,
		mm.node_id,
		instant_data.instant_latest_time,
		instant_data.slot_count,
		instant_data."type"
		from meter_mapping mm 
		left join
		(select 
		mpd2.node_id , 
		mid_data.instant_latest_time,
		mid_data.slot_count,
		mpd2."type"  
		from meter_profile_data mpd2 
		right join
		(select node_id ,
            max(server_time) as instant_latest_time,
            count(1) as slot_count
        from meter_profile_data mpd
        where "type" = 'Instant_Profile'
            and server_time between '2023-03-25 00:00:00.000' and '2023-03-25 23:59:59.999'
        group by node_id) mid_data on mpd2.node_id = mid_data.node_id 
        where mpd2 .server_time = mid_data.instant_latest_time) instant_data on mm.node_id = instant_data.node_id 
        
        select * from node_init ni 
        select * from meter_mapping mm 
        
       	 
        select
        mm.meter_number ,
        mm.node_id ,
        latest_data.max_Server_time,
        latest_data.slot_count
        from meter_mapping mm    
        left join
        (select node_id ,
            max(server_time) as max_server_time,
            count(1) as slot_count
        from node_init ni2 
        where server_time between '2023-03-26 00:00:00.000' and '2023-03-26 23:59:59.999' 
        group by node_id) latest_data on mm.node_id = latest_data.node_id 
        order by latest_data.slot_count

        
 		select * from 
        (select
        mm.meter_number  ,
        mm.node_id  ,
        latest_data.max_Server_time  ,
        latest_data.slot_count 
        from meter_mapping mm    
        left join
        (select node_id ,
            max(server_time) as max_server_time,
            count(1) as slot_count
        from node_init ni2 
        where server_time between '2023-03-26 00:00:00.000' and '2023-03-26 23:59:59.999' 
        group by node_id) latest_data on mm.node_id = latest_data.node_id 
        order by latest_data.slot_count) main_table
        where main_table.slot_count >5
        
        