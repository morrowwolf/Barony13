/datum/round_event_control/barony_event/goblin_invasion
	name = "Goblin Invasion"
	typepath = /datum/round_event/goblin_invasion

	min_players = 1
	max_occurrences = 5

/datum/round_event/goblin_invasion
	fakeable = FALSE
	var/spawned = FALSE
	var/spawnpoint

/datum/round_event/goblin_invasion/announce(fake)
	if(!spawned)
		return



	for(var/mob/player in GLOB.player_list)
		var/heard_dir = get_dir(player, spawnpoint)
		var/text_dir

		switch(heard_dir)
			if(NORTH)
				text_dir = "North"
			if(NORTHEAST)
				text_dir = "Northeast"
			if(EAST)
				text_dir = "East"
			if(SOUTHEAST)
				text_dir = "Southeast"
			if(SOUTH)
				text_dir = "South"
			if(SOUTHWEST)
				text_dir = "Southwest"
			if(WEST)
				text_dir = "West"
			if(NORTHWEST)
				text_dir = "Northwest"

		to_chat(player, "<span class='big'><span class='boldannounce'><span class='red'>You hear shrieks and warhorns to the [text_dir]!</span></span></span>")
		SEND_SOUND(player, 'sound/effects/goblin_horde.ogg')
	

/datum/round_event/goblin_invasion/start()
	var/spawns = getSpawnAmount()
	var/type = /mob/living/simple_animal/hostile/goblin

	var/turf/T
	var/safety = 0
	while(safety < 40)
		T = safepick(get_area_turfs(/area/barony/outside))
		if(T && checkSpawn(T))
			safety += 1
			continue
		else
			spawnpoint = T
			break

	if(!spawnpoint)
		return

	for(var/i = 0, i < spawns, i++)
		sleep(10)
		new type(spawnpoint)
		playsound(spawnpoint, 'sound/effects/goblin_spawn.ogg', 60)

	spawned = TRUE

/datum/round_event/goblin_invasion/proc/getSpawnAmount()
	var/players = GLOB.player_list.len
	return round((players * 1 / 3) + 3, 1)

/datum/round_event/goblin_invasion/proc/checkSpawn(turf/T)
	if(istype(T, /turf/closed))
		return TRUE

	for(var/atom/A in T.contents)
		if(A.density)
			return TRUE

	return FALSE