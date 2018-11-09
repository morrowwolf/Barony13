/datum/round_event_control/barony_event/goblin_invasion
	name = "Goblin Invasion"
	typepath = /datum/round_event/goblin_invasion

	min_players = 5
	max_occurrences = 5

/datum/round_event/goblin_invasion
	fakeable = FALSE
	var/spawned = FALSE

/datum/round_event/goblin_invasion/start()
	