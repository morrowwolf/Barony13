/datum/component/parry

/datum/component/parry/Initialize()
	if(!istype(parent, /obj/item/))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, list(COMSIG_ITEM_ATTACK_SELF), .proc/attack_self)
	RegisterSignal(parent, list(COMSIG_ITEM_HIT_REACT), .proc/hit_react)
	
/datum/component/parry/proc/attack_self(mob/living/carbon/user)

	if(!user.parry_cooldown || (user.parry_cooldown && user.parry_cooldown < world.time))
		user.parry_cooldown = world.time + 50
	else
		return

	user.parrying = TRUE
	user.add_overlay(icon('icons/effects/medieval.dmi', "parry1"))
	playsound(get_turf(user), 'sound/effects/parry.ogg', 50, 1)
	addtimer(CALLBACK(src, .proc/parry_end, user), 10)
	
/datum/component/parry/proc/parry_end(mob/living/carbon/user)
	if(user.parrying)
		user.cut_overlay(icon('icons/effects/medieval.dmi', "parry1"))

		user.parrying = FALSE
	
/datum/component/parry/proc/hit_react(list/args)
	var/mob/living/carbon/human/owner = args[1]
	var/atom/movable/hitby = args[2]
	var/attack_type = args[6]
	
	if(!owner.parrying)
		return FALSE
		
	if(attack_type != MELEE_ATTACK && attack_type != UNARMED_ATTACK)
		return FALSE
		
	var/mob/living/mobhitby
	
	if(!istype(hitby, /mob/living/))
		mobhitby = hitby.loc
	else
		mobhitby = hitby
		
	var/obj/item/hitby_held_item = mobhitby.get_active_held_item()
	var/obj/item/held_item = owner.get_active_held_item()
	
	playsound(get_turf(owner), 'sound/effects/parry.ogg', 100, 1)
	if(hitby_held_item)
		owner.visible_message("<span class='danger'>[owner] has parried [mobhitby]'s [hitby_held_item.name] with [held_item].</span>",\
			"<span class='userdanger'>[owner] has parried [mobhitby]'s [hitby_held_item.name] with [held_item].</span>", null, COMBAT_MESSAGE_RANGE)
	else
		owner.visible_message("<span class='danger'>[owner] has parried [mobhitby]'s attack with [held_item].</span>",\
			"<span class='userdanger'>[owner] has parried [mobhitby]'s attack with [held_item].</span>", null, COMBAT_MESSAGE_RANGE)
		
	mobhitby.changeNext_move(CLICK_CD_PARRYED)
	log_combat(owner, mobhitby, "parried")
	
	parry_end(owner)
	
	return TRUE
