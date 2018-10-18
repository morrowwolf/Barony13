/obj/item/shields/medieval
	name = "shield"
	desc = "You probably shouldn't be able to see this"
	armor = list("melee" = 50, "bullet" = 50, "laser" = 50, "energy" = 0, "bomb" = 30, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 70)
	
	slot_flags = ITEM_SLOT_BACK
	
	force = 10
	throwforce = 15
	
	icon = 'yogstation/icons/obj/medieval.dmi'
	lefthand_file = 'yogstation/icons/mob/inhands/medieval_lefthand.dmi'
	righthand_file = 'yogstation/icons/mob/inhands/medieval_righthand.dmi'
	icon_state = "knight shield"		//when creating a new shield end the "up" icon with "-up" and then "down" icon with "-down"
	var/icon_state_up
	var/icon_state_down
	
/obj/item/shields/medieval/Initialize()
	..()
	icon_state_up = "[icon_state]-up"
	icon_state_down = "[icon_state]-down"
	icon_state = icon_state_down
	
/obj/item/shields/medieval/attack_self(mob/living/carbon/user)
	if(user.blocking)
		user.blocking = FALSE
		icon_state = icon_state_down
		user.block_dir = null
		user.update_icons()
	else
		user.blocking = TRUE
		icon_state = icon_state_up
		user.block_dir = user.dir
		user.update_icons()
	
/obj/item/shields/medieval/dropped(mob/user)
	if(user.blocking)
		user.blocking = FALSE
		icon_state = icon_state_down
		user.block_dir = null
		user.update_icons()
	return ..(user)
	
/obj/item/shields/medieval/doMove(atom/destination)
	if(istype(loc, /mob/))
		var/mob/user = loc
		if(user.blocking)
			user.blocking = FALSE
			icon_state = icon_state_down
			user.block_dir = null
			user.update_icons()
	return ..(destination)
	
/obj/item/shields/medieval/on_swap_hand(mob/living/carbon/user)
	if(user.blocking)
		to_chat(user, "You cannot swap hands while blocking!")
		return TRUE
	
	return FALSE

/obj/item/shields/medieval/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!owner.blocking)
		return FALSE
		
	if(attack_type == MELEE_ATTACK || attack_type == UNARMED_ATTACK)
	
		var/mob/living/mobhitby = null
	
		if(!istype(hitby, /mob/living/))
			mobhitby = hitby.loc
		else
			mobhitby = hitby
		
		var/blocked = FALSE
		
		if(owner.block_dir == 1)			//checks if mobhitby above src
			if(mobhitby.y - 1 == owner.y)
				blocked = TRUE
		else if(owner.block_dir == 2)		//checks if mobhitby below src
			if(mobhitby.y + 1 == owner.y)
				blocked = TRUE
		else if(owner.block_dir == 4)		//checks if mobhitby right of src
			if(mobhitby.x - 1 == owner.x)
				blocked = TRUE
		else if(owner.block_dir == 8)		//checks if mobhitby left of src
			if(mobhitby.x + 1 == owner.x)
				blocked = TRUE
	
		if(!blocked)
			return
			
		var/obj/item/hitby_held_item = mobhitby.get_active_held_item()
	
		if(hitby_held_item)
			owner.visible_message("<span class='danger'>[owner] has blocked [mobhitby]'s [hitby_held_item.name] with [src].</span>",\
				"<span class='userdanger'>[owner] has blocked [mobhitby]'s [hitby_held_item.name] with [src].</span>", null, COMBAT_MESSAGE_RANGE)
		else
			owner.visible_message("<span class='danger'>[owner] has blocked [mobhitby]'s attack with [src].</span>",\
				"<span class='userdanger'>[owner] has blocked [mobhitby]'s attack with [src].</span>", null, COMBAT_MESSAGE_RANGE)
	
		playsound(get_turf(owner), 'sound/weapons/effects/shield_block_2.ogg', 150, 1, -1)
		mobhitby.changeNext_move(CLICK_CD_BLOCKED)
		log_combat(owner, mobhitby, "blocked")
	
		return TRUE
		
	else if(attack_type == PROJECTILE_ATTACK)
		
		if(!istype(hitby, /obj/item/projectile/bullet/))
			return FALSE
			
		var/obj/item/projectile/bullet/projhitby = hitby
	
		var/blocked = FALSE
		
		if(!owner.blocking)
			return FALSE
			
		var/hitFrom = get_dir(projhitby.starting, owner)
		if(owner.block_dir == 2)
			if(hitFrom == NORTH || hitFrom == NORTHEAST || hitFrom == NORTHWEST)
				blocked = TRUE
		else if(owner.block_dir == 1)
			if(hitFrom == SOUTH || hitFrom == SOUTHEAST || hitFrom == SOUTHWEST)
				blocked = TRUE
		else if(owner.block_dir == 8)
			if(hitFrom == EAST || hitFrom == NORTHEAST || hitFrom == SOUTHEAST)
				blocked = TRUE
		else if(owner.block_dir == 4)
			if(hitFrom == WEST || hitFrom == NORTHWEST || hitFrom == SOUTHWEST)
				blocked = TRUE
					
		if(!blocked)
			return FALSE
				
		playsound(get_turf(owner), 'sound/weapons/effects/shield_block_2.ogg', 150, 1, -1)
		owner.visible_message("<span class='danger'>[owner] has blocked [projhitby]!</span>", \
			"<span class='userdanger'>[owner] has blocked [projhitby]!</span>", null, COMBAT_MESSAGE_RANGE)
		log_combat(owner, projhitby, "blocked")
		return TRUE

		
		
		