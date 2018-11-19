/datum/antagonist/witch_cult
	name = "Witch Cultist"
	roundend_category = "Witch Cult"
	antagpanel_category = "Witch Cult"
	job_rank = ROLE_WITCH_CULT
	var/hud_type = "witch cult"
	
/datum/antagonist/witch_cult/witch
	name = "Witch"
	job_rank = ROLE_WITCH
	hud_type = "witch"
	
/datum/antagonist/witch_cult/proc/equip_antag()
	var/datum/objective/protect/protect_witch = new /datum/objective/protect("Protect the witch and serve them no matter the cost.")
	for(var/mob/living/carbon/human/mob in GLOB.player_list)
		if(cmptext(mob.mind.special_role, "witch"))
			protect_witch.target = mob.mind
	if(protect_witch.target)
		objectives += protect_witch
		owner.objectives += protect_witch

	
/datum/antagonist/witch_cult/witch/equip_antag()
	owner.current.AddSpell(new /obj/effect/proc_holder/spell/targeted/projectile/magic_missile(null))
	owner.current.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/summon_skeleton(null))
	owner.current.AddSpell(new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt(null))
	objectives += new /datum/objective/kill_everyone(null)
	owner.objectives += new /datum/objective/kill_everyone(null)

/datum/antagonist/witch_cult/witch/on_gain()
	. = ..()
	
/datum/antagonist/witch_cult/on_gain()
	. = ..()
	equip_antag()
	var/datum/atom_hud/antag/witchhud = GLOB.huds[ANTAG_HUD_WITCH_CULT]
	witchhud.join_hud(owner.current)
	set_antag_hud(owner.current, hud_type)
	
/datum/antagonist/witch_cult/witch/greet()
	to_chat(owner, "<span class='userdanger'>You are a necromancer!  Use discretion and destroy all the villagers!</span>")

/datum/antagonist/witch_cult/greet()
	to_chat(owner, "<span class='userdanger'>You are a minion!  Obey your leader, use discretion, and destroy all the villagers!</span>")
	
/datum/antagonist/witch_cult/witch/antag_listing_name()
	return ..() + "(Witch)"

/datum/antagonist/witch_cult/on_removal()
	var/datum/atom_hud/antag/witchhud = GLOB.huds[ANTAG_HUD_WITCH_CULT]
	witchhud.leave_hud(owner.current)
	set_antag_hud(owner.current, null)
	. = ..()