-- MIN MIDNIGHT AND INSTANT--

select mm.meter_number , mm.node_id,
	   mtr_slot_time.server_time,
	   mtr_slot_time.slot_count,
	   mtr_slot_time.date_time
from meter_mapping mm 
left join (
		select midnight_data.meter_number, 
			   midnight_data.node_id, 
			   midnight_data.server_time, 
			   midnight_data.date_time,
			   required_mtr_slot.slot_count	    
		from
			(
				select meter_number , node_id , server_time , date_time from meter_profile_data mpd where 
				server_time >= '2023-05-10 22:00:00' and server_time <= '2023-05-11 23:59:59'
				and date_time = '2023-05-11 00:00:00' 
				and "type" = 'Midnight_Profile'
			) midnight_data
		right join 
			(	select meter_slot.meter_number, meter_slot.slot_count, meter_slot.last_time from 
					(	
						select meter_number ,
							   count(meter_number) as slot_count ,
							   min(server_time) as last_time 
						from meter_profile_data mpd
						where "type" = 'Midnight_Profile' and 
						server_time >= '2023-05-10 22:00:00' and server_time <= '2023-05-11 23:59:59'
						and date_time = '2023-05-11 00:00:00' 
						group by meter_number
					) meter_slot
			) required_mtr_slot
		on midnight_data.meter_number = required_mtr_slot.meter_number
		where midnight_data.server_time = required_mtr_slot.last_time 
	) mtr_slot_time
on mm.meter_number = mtr_slot_time.meter_number
where mtr_slot_time.slot_count is not null;										
-------------------------------------------------------------------------------------------------------------------------------------

select mm.meter_number , mm.node_id,
	   mtr_slot_time.server_time,
	   mtr_slot_time.slot_count
from meter_mapping mm 
left join (
		select instant_data.meter_number, 
			   instant_data.node_id, 
			   instant_data.server_time, 
			   required_mtr_slot.slot_count	    
		from
			(
				select meter_number , node_id , server_time from meter_profile_data mpd where 
				server_time >= '2023-05-11 00:00:00' and server_time <= '2023-05-11 23:59:59' 
				and "type" = 'Instant_Profile'
			) instant_data
		right join 
			(	select meter_slot.meter_number, meter_slot.slot_count, meter_slot.last_time from 
					(	
						select meter_number ,
							   count(meter_number) as slot_count ,
							   min(server_time) as last_time 
						from meter_profile_data mpd
						where "type" = 'Instant_Profile' and 
						server_time between '2023-05-11 00:00:00' and '2023-05-11 23:59:59'
						group by meter_number
					) meter_slot
			) required_mtr_slot
		on instant_data.meter_number = required_mtr_slot.meter_number
		where instant_data.server_time = required_mtr_slot.last_time 
	) mtr_slot_time
on mm.meter_number = mtr_slot_time.meter_number
where mtr_slot_time.server_time is not null