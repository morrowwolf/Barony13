/obj/item/bow
	name = "bow"
	desc = "It's a bow.  Effective in the right hands."
	lefthand_file = 'yogstation/icons/mob/inhands/medieval_lefthand.dmi'
	righthand_file = 'yogstation/icons/mob/inhands/medieval_righthand.dmi'
	icon = 'yogstation/icons/obj/medieval.dmi'
	icon_state = "bow"
	item_state = "bow"
	slot_flags = ITEM_SLOT_BACK
	materials = list()
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	force = 5
	attack_verb = list("struck", "hit", "bashed")
	var/obj/item/ammo_casing/chambered = null
	var/semicd
	var/fire_sound = "sound/weapons/bow_2.ogg"
	
	
/obj/item/bow/afterattack(atom/target, mob/living/user, flag, params)
	. = ..()
	if(!target)
		return
	if(flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target) || user.a_intent == INTENT_HARM) //melee attack
			return
		if(target == user) //so we can't shoot ourselves
			return

	if(istype(user))//Check if the user can use the gun, if the user isn't alive(turrets) assume it can.
		var/mob/living/L = user
		if(!can_trigger_gun(L))
			return

	process_fire(target, user, TRUE, params)
	
/obj/item/bow/proc/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "")
	add_fingerprint(user)

	if(semicd)
		return
	
	for(var/i = 1 to user.held_items.len)
		if(istype(user.held_items[i], /obj/item/ammo_casing/arrow))
			chambered = user.held_items[i]
			chambered.fire_casing(target, user, params, , FALSE, zone_override, 0)
			if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
				shoot_live_shot(user, 1, target, message)
			else
				shoot_live_shot(user, 0, target, message)
			qdel(chambered)
			chambered = null
			
			semicd = TRUE
			addtimer(CALLBACK(src, .proc/reset_semicd), 1)

			if(user)
				user.update_inv_hands()
			return TRUE
			
	to_chat(user, "You must be holding an arrow to fire a bow!")
	return
	
	
/obj/item/bow/proc/reset_semicd()
	semicd = FALSE
	
/obj/item/bow/proc/shoot_live_shot(mob/living/user as mob|obj, pointblank = 0, mob/pbtarget = null, message = 1)
	playsound(user, fire_sound, 50, 1)
	if(message)
		if(pointblank)
			user.visible_message("<span class='danger'>[user] fires [src] point blank at [pbtarget]!</span>", null, null, COMBAT_MESSAGE_RANGE)
		else
			user.visible_message("<span class='danger'>[user] fires [src]!</span>", null, null, COMBAT_MESSAGE_RANGE)