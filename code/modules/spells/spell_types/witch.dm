/obj/effect/proc_holder/spell/aoe_turf/summon_skeleton
	name = "Summon Skeleton"
	desc = "This spell uses five power to summon skeleton servants."

	school = "necromancy"
	charge_max = 50
	clothes_req = 0
	invocation = "Ardaigh seirbhiseach marbh!"
	invocation_type = "whisper"
	range = 2
	cooldown_min = 20 //20 deciseconds reduction per rank

	action_icon_state = "skeleton"
	
	var/bones_required = 5
	
/obj/effect/proc_holder/spell/aoe_turf/summon_skeleton/cast(list/targets,mob/user = usr)
			
	if(!user || !user.mind || !user.mind.antag_datums)
		return

	var/datum/antagonist/witch_cult/witch/W

	for(var/i = 1, i <= user.mind.antag_datums.len, i++)
		if(istype(user.mind.antag_datums[i], /datum/antagonist/witch_cult/witch))
			W = user.mind.antag_datums[i]

	if(!W)
		return

	if(W.power < bones_required)
		to_chat(user, "Not enough power to summon an undead minion!")
		return
	
	notify_ghosts("A necromancer summons servants!", source = user, action=NOTIFY_ORBIT, flashwindow = FALSE)
	
	sleep(50)
	
	var/list/candidates = user.orbiters
	
	if(!candidates || !candidates.len)
		to_chat(user, "No undead to summon!")
		return


	var/mob/dead/selected_candidate = pick_n_take(candidates).orbiter
	var/key = selected_candidate.key
		
	var/datum/mind/Mind = new /datum/mind(key)
	Mind.assigned_role = ROLE_WITCH_CULT
	Mind.special_role = ROLE_WITCH_CULT
	Mind.active = 1

	var/mob/living/carbon/human/skeleton = new(user.loc)
	var/datum/preferences/A = new()
	A.real_name = "Undead Servant"
	A.underwear = "Nude"
	A.undershirt = "Nude"
	A.socks = "Nude"
	A.hair_style = "Bald"
	A.facial_hair_style = "Shaved"
	A.copy_to(skeleton)
	skeleton.set_species(/datum/species/skeleton)
	skeleton.dna.update_dna_identity()
		
		
	Mind.transfer_to(skeleton)
	var/datum/antagonist/witch_cult/skeletondatum = new
	Mind.add_antag_datum(skeletondatum)
		
	if(skeleton.mind != Mind)			//something has gone wrong!
		throw EXCEPTION("Skeleton created with incorrect mind")

	W.power -= 5

	log_game("[skeleton.key] was spawned as a skeleton by [user.key]/ ([user])")

/obj/effect/proc_holder/spell/targeted/heal
	name = "Self Heal"
	desc = "This spell uses two power to heal yourself."

	school = "necromancy"
	charge_max = 20
	clothes_req = 0
	invocation = "Athghiniúint!"
	invocation_type = "whisper"
	range = -1
	cooldown_min = 10

	action_icon_state = "blink"

/obj/effect/proc_holder/spell/targeted/heal/cast(list/targets,mob/user = usr)

	if(!user || !user.mind || !user.mind.antag_datums)
		return

	var/datum/antagonist/witch_cult/witch/W

	for(var/i = 1, i <= user.mind.antag_datums.len, i++)
		if(istype(user.mind.antag_datums[i], /datum/antagonist/witch_cult/witch))
			W = user.mind.antag_datums[i]

	if(!W)
		return

	if(W.power < 2)
		to_chat(user, "Not enough power to heal yourself!")
		return

	if(!istype(/mob/living, user))
		return

	var/mob/living/L = user

	L.adjustOxyLoss(-15)
	L.adjustBruteLoss(-15)
	L.adjustFireLoss(-15)

	W.power -= 2