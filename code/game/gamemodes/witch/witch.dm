/datum/game_mode
	var/list/datum/mind/witchs = list()
	var/list/datum/mind/witchcultists = list()
	
/datum/game_mode/witch
	name = "witch"
	config_tag = "witch"
	antag_flag = ROLE_WITCH
	restricted_jobs = list("Baron", "Knight", "Priest")
	required_players = 1
	required_enemies = 1
	enemy_minimum_age = 0
	round_ends_with_antag_death = 1
	announce_span = "danger"
	announce_text = "There is a necromancer in the village!\n\
	<span class='danger'>Necromancer</span>: Kill everyone!.\n\
	<span class='notice'>Villagers</span>: Eliminate the necromancer before they can succeed!"
	
/datum/game_mode/witch/pre_setup()
	var/datum/mind/witch = antag_pick(antag_candidates)
	witchs += witch
	witch.restricted_roles = restricted_jobs
	return 1
	
/datum/game_mode/witch/post_setup()
	for(var/datum/mind/witch in witchs)
		witch.add_antag_datum(/datum/antagonist/witch)
	return ..()
	
/datum/game_mode/witch/are_special_antags_dead()
	for(var/datum/mind/witch in witchs)
		if(isliving(witch.current) && witch.current.stat!=DEAD)
			return FALSE

	return TRUE