/obj/item/storage/backpack/quiver
	name = "quiver"
	desc = "A quiver used to store arrows"
	icon = 'yogstation/icons/obj/medieval.dmi'
	icon_state = "quiver-0"
	righthand_file = 'yogstation/icons/mob/inhands/medieval_righthand.dmi'
	lefthand_file = 'yogstation/icons/mob/inhands/medieval_lefthand.dmi'
	
/obj/item/storage/backpack/quiver/ComponentInitialize()
	. = ..()
	GET_COMPONENT(STR, /datum/component/storage)
	STR.max_items = 8
	STR.can_hold = typecacheof(list(/obj/item/ammo_casing/arrow))
	
/obj/item/storage/backpack/quiver/update_icon()
	var/arrows = contents.len
	if(arrows == 0)
		icon_state = "quiver-0"
	else if(arrows > 0 && arrows < 4)
		icon_state = "quiver-1"
	else if(arrows > 3 && arrows < 7)
		icon_state = "quiver-2"
	else
		icon_state = "quiver-3"
	..()