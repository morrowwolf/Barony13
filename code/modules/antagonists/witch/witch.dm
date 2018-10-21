/datum/antagonist/witch_cult
	name = "Witch Cultist"
	roundend_category = "Witch Cult"
	antagpanel_category = "Witch Cult"
	job_rank = ROLE_WITCH_CULT
	var/hud_type = "witch cult"
	var/datum/mind/master
	var/datum/team/witch/witch_team
	
/datum/antagonist/witch_cult/witch
	name = "Witch"
	job_rank = ROLE_WITCH
	hud_type = "witch"
	
/datum/antagonist/witch_cult/proc/equip_antag()
	return
	
/datum/antagonist/witch_cult/witch/equip_antag()
	owner.current.AddSpell(new /obj/effect/proc_holder/spell/aimed/fireball(null))
	owner.current.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/summon_skeleton(null))
	owner.current.AddSpell(new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt(null))
	objectives += /datum/objective/kill_everyone
	
/datum/antagonist/witch_cult/equip()
	. = ..()
	equip_antag()
	
/datum/antagonist/witch_cult/witch/greet()
	to_chat(owner, "<span class='userdanger'>You are a necromancer!  Use discretion and destroy all the villagers!</span>")

/datum/antagonist/witch_cult/greet()
	to_chat(owner, "<span class='userdanger'>You are a minion!  Obey your leader, use discretion, and destroy all the villagers!</span>")
	
/datum/antagonist/witch_cult/witch/antag_listing_name()
	return ..() + "(Witch)"