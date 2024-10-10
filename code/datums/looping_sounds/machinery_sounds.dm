/datum/looping_sound/showering
	start_sound = 'sound/machines/shower/shower_start.ogg'
	start_length = 2
	mid_sounds = list('sound/machines/shower/shower_mid1.ogg' = 1,'sound/machines/shower/shower_mid2.ogg' = 1,'sound/machines/shower/shower_mid3.ogg' = 1)
	mid_length = 10
	end_sound = 'sound/machines/shower/shower_end.ogg'
	volume = 20

/datum/looping_sound/gigadrill
	start_sound = 'sound/machines/engine/engine_start.ogg'
	start_length = 3
	mid_sounds = list('sound/machines/engine/engine_mid1.ogg')
	mid_length = 3
	end_sound = 'sound/machines/engine/engine_end.ogg'
	volume = 20

/datum/looping_sound/computer
	start_sound = 'sound/machines/computer/computer_start.ogg'
	start_length = 7.2 SECONDS
	// start_volume = 10
	mid_sounds = list('sound/machines/computer/computer_mid1.ogg' = 1, 'sound/machines/computer/computer_mid2.ogg' = 1)
	mid_length = 1.8 SECONDS
	end_sound = 'sound/machines/computer/computer_end.ogg'
	// end_volume = 10
	volume = 2
	falloff_exponent = 5 //Ultra quiet very fast
	extra_range = -12
	falloff_distance = 1 //Instant falloff after initial tile
