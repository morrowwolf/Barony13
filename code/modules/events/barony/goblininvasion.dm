/datum/round_event_control/barony_event/goblin_invasion
	name = "Goblin Invasion"
	typepath = /datum/round_event/goblin_invasion

	min_players = 1
	max_occurrences = 5

/datum/round_event/goblin_invasion
	fakeable = FALSE
	var/spawned = FALSE

/datum/round_event/goblin_invasion/start()
	var/spawns = getSpawnAmount()
	var/type = /mob/living/simple_animal/hostile/goblin

/datum/round_event/goblin_invasion/proc/getSpawnAmount()
	var/players = GLOB.player_list.len
	return round((players * 2 / 3) + 3, 1)