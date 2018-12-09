/obj/item/clothing/neck/cloak/medieval
	name = "cloak"
	desc = "A basic cloak with a hood."
	icon_state = "medievalcloak-nohood"
	item_state = "medievalcloak-nohood"
	actions_types = list(/datum/action/item_action/toggle_helmet)
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = 260
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/neck/cloak/medieval/Initialize()
	..()
	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/neck/cloak/medieval/item_action_slot_check(slot)
	if(slot == SLOT_NECK)
		return 1
		
/obj/item/clothing/neck/cloak/medieval/ui_action_click()
	..()
	ToggleHood()
	
/obj/item/clothing/neck/cloak/medieval/proc/ToggleHood()
	if(cmptext(icon_state, "medievalcloak"))
		icon_state = "medievalcloak-hood"
		item_state = "medievalcloak-hood"
		cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS | HEAD
		flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
		body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	else
		icon_state = "medievalcloak-nohood"
		item_state = "medievalcloak-nohood"
		cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
		flags_inv = null
		body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

	var/mob/living/carbon/human/H = loc
	H.update_inv_neck()
	H.head_update(src, forced = 1)

	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/neck/cloak/medieval/somethingMoved(mob/user)		//So this shit *would* be good enough but held_items isn't set until after forcemove which calls this and moving it around fucked everything, so uuuh... yeah, probably a better way to do it
	..()
	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/neck/cloak/medieval/somethingPutInHand(mob/user)
	..()
	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/neck/cloak/medieval/somethingDropped(mob/user)
	..()
	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/neck/cloak/medieval/equipped(mob/user, slot)
	..()
	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/neck/cloak/medieval/update_icon()
	..()
	if(!istype(loc, /mob/living))
		return
	var/mob/living/user = loc
	var/list/splitIconName = splittext(icon_state, "-")
	if(cmptext(splitIconName[2], "hood"))
		if(user.held_items[1] && user.held_items[2])
			icon_state = "medievalcloak-hood-both"
			item_state = "medievalcloak-hood-both"
		else if(user.held_items[1])
			icon_state = "medievalcloak-hood-left"
			item_state = "medievalcloak-hood-left"
		else if(user.held_items[2])
			icon_state = "medievalcloak-hood-right"
			item_state = "medievalcloak-hood-right"
		else
			icon_state = "medievalcloak-hood"
			item_state = "medievalcloak-hood"
	else
		if(user.held_items[1] && user.held_items[2])
			icon_state = "medievalcloak-nohood-both"
			item_state = "medievalcloak-nohood-both"
		else if(user.held_items[1])
			icon_state = "medievalcloak-nohood-left"
			item_state = "medievalcloak-nohood-left"
		else if(user.held_items[2])
			icon_state = "medievalcloak-nohood-right"
			item_state = "medievalcloak-nohood-right"
		else
			icon_state = "medievalcloak-nohood"
			item_state = "medievalcloak-nohood"
	user.update_inv_neck()