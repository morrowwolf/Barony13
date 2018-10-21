/obj/effect/proc_holder/spell/aoe_turf/summon_skeleton
	name = "Summon Skeleton"
	desc = "This spell uses the bones nearby to summon servants from the afterlife."

	school = "necromancy"
	charge_max = 100
	clothes_req = 0
	invocation = "Ardaigh seirbhiseach marbh!"
	invocation_type = "whisper"
	range = 2
	cooldown_min = 20 //20 deciseconds reduction per rank

	action_icon_state = "skeleton"
	
/obj/effect/proc_holder/spell/aoe_turf/summon_skeleton/cast(list/targets,mob/user = usr)

	var/list/bones = list()
	
	for(var/turf/T in targets)
		for(var/obj/item/stack/sheet/bone/b in T.contents)
			bones += b
			
	if(bones.len < 5)
		to_chat(user, "Not enough bones to summon an undead minion!")
		return
	
	notify_ghosts("A necromancer summons servants!", source = user, action=NOTIFY_ORBIT, flashwindow = FALSE)
	
	sleep(50)
	
	var/list/candidates = user.orbiters
	
	if(!candidates || !candidates.len)
		to_chat(user, "No undead to summon!")
		return
		
	while(bones.len >= 5 && candidates.len)
		var/mob/dead/selected_candidate = pick_n_take(candidates).orbiter
		var/key = selected_candidate.key

		
		var/datum/mind/Mind = new /datum/mind(key)
		Mind.assigned_role = ROLE_WITCH_SKELETON
		Mind.special_role = ROLE_WITCH_SKELETON
		Mind.active = 1

		var/mob/living/carbon/human/skeleton = new(user.loc)
		var/datum/preferences/A = new()
		A.real_name = "Servant of [user]"
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
	
		qdel(bones[bones.len])
		qdel(bones[bones.len])
		qdel(bones[bones.len])
		qdel(bones[bones.len])
		qdel(bones[bones.len])
			
		log_game("[skeleton.key] was spawned as a skeleton by [user.key]/ ([user])")