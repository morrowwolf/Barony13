//Gonna be honest that a lot of this stuff is ripped from Rev and Wizard

/datum/game_mode
	var/list/datum/mind/witches = list()
	var/list/datum/mind/witchcultists = list()
	
/datum/game_mode/witch
	name = "witch"
	config_tag = "witch"
	antag_flag = ROLE_WITCH
	restricted_jobs = list("Baron", "Knight", "Priest")
	required_players = 2
	required_enemies = 1
	enemy_minimum_age = 0
	round_ends_with_antag_death = 1
	announce_span = "danger"
	announce_text = "There is a necromancer in the village!\n\
	<span class='danger'>Necromancer</span>: Kill everyone!.\n\
	<span class='notice'>Villagers</span>: Eliminate the necromancer before they can succeed!"
	
	var/finished = 0
	var/check_counter = 0
	
/datum/game_mode/witch/pre_setup()
	var/datum/mind/witch = antag_pick(antag_candidates)
	witch.special_role = "witch"						//required so witches don't get rejected back to mainscreen in job selection
	witch.restricted_roles = restricted_jobs			
	witches += witch
	
	return 1
	
/datum/game_mode/witch/post_setup()
	for(var/datum/mind/witchbrain in witches)
		witchbrain.add_antag_datum(/datum/antagonist/witch_cult/witch)			//actually sets the antag stuff
	return ..()
	
/datum/game_mode/witch/are_special_antags_dead()
	for(var/datum/mind/witch in witches)
		if(isliving(witch.current) && witch.current.stat!=DEAD)				//45634
			return FALSE

	return TRUE

/datum/game_mode/witch/process()
	check_counter++
	if(check_counter >= 5)
		if(!finished)
			SSticker.mode.check_win()					//constant check stolen from revs, not 100% sure this is the most effective way to do this
		check_counter = 0
	return FALSE
	
/datum/game_mode/witch/check_win()
	if(check_witch_victory())
		finished = 1
	else if(check_villager_victory())
		finished = 2
	return
	
/datum/game_mode/witch/check_finished()
	if(finished != 0)
		return TRUE
	else
		return ..()
		
/datum/game_mode/witch/proc/check_witch_victory()
	for(var/datum/mind/witch in witches)
		for(var/datum/objective/objective in witch.objectives)
			if(!(objective.check_completion()))
				return FALSE
	return TRUE

/datum/game_mode/witch/proc/check_villager_victory()
	for(var/datum/mind/witch in witches)
		if(considered_alive(witch))								//like this is from rev and uses considered_alive() while from wiz game_mode (ref#45634) uses a different method, which is better?  Are they inherently different in a meaningful way?, I'm not even going down that rabbit hole but future me: look into that
			return FALSE
	return TRUE
	
/datum/game_mode/revolution/set_round_result()
	..()
	if(finished == 1)
		SSticker.mode_result = "win - village killed"
		SSticker.news_report = WITCH_WIN
	else if(finished == 2)
		SSticker.mode_result = "loss - witch killed"
		SSticker.news_report = WITCH_LOSE

/datum/game_mode/revolution/special_report()
	if(finished == 1)
		return "<span class='redtext big'>The village was destroyed!  The witch wins!</span>"
	else if(finished == 2)
		return "<span class='redtext big'>The village managed to stop the witch!</span>"