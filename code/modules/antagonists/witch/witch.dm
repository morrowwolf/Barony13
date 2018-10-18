/datum/antagonist/witch
	name = "Witch"
	roundend_category = "Witch"
	antagpanel_category = "Witch"
	job_rank = ROLE_WITCH
	var/hud_type = "witch"
	var/datum/team/witch/witch_team

/datum/antagonist/witch/witch_skeleton
	name = "Witch Skeleton"
	job_rank = ROLE_WITCH_SKELETON
	hud_type = "witch skeleton"
	var/datum/mind/master
	
/datum/antagonist/witch/witch_cult
	name = "Witch Cultist"
	job_rank = ROLE_WITCH_CULT
	hud_type = "witch cultist"
	var/datum/mind/master
	
/datum/antagonist/witch/proc/equip_witch()
	owner.current.AddSpell(new /obj/effect/proc_holder/spell/aimed/fireball(null))
	owner.current.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/summon_skeleton(null))
	owner.current.AddSpell(new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt(null))
	
/datum/antagonist/witch/witch_skeleton/equip_witch()
	return

/datum/antagonist/witch/witch_cult/equip_witch()
	return
	
/datum/antagonist/witch/on_gain()
	. = ..()
	equip_witch()
	
/datum/antagonist/witch/greet()
	to_chat(owner, "<span class='userdanger'>You are a necromancer!  Use discretion and destroy all the villagers!</span>")
	
/datum/antagonist/witch/witch_skeleton/greet()
	to_chat(owner, "<span class='userdanger'>You are an undead minion!  Obey your summoner, use discretion, and destroy all the villagers!</span>")

/datum/antagonist/witch/witch_cult/greet()
	to_chat(owner, "<span class='userdanger'>You are a minion!  Obey your leader, use discretion, and destroy all the villagers!</span>")