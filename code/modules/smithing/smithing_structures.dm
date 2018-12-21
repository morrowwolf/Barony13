/obj/structure/medieval/oven/forge
	name = "forge"
	desc = "Heats metal to a workable temperature."
	icon = 'barony/icons/smithing/smithing_structures.dmi'
	icon_state = "forge_off"

/obj/structure/medieval/oven/forge/update_icon()
	..()
	if(operating)
		icon_state = "forge_on"
	else
		icon_state = "forge_off"

/obj/structure/medieval/oven/forge/cook()
	if(istype(itemInside, /obj/item/stack/ingot))
		var/obj/item/stack/ingot/I = itemInside
		I.forceMove(loc)
		I.heat()
		itemInside = null
	else
		..()

/obj/structure/medieval/oven/crucible
	name = "crucible"
	desc = "Smelts ore."
	icon = 'barony/icons/smithing/smithing_structures.dmi'
	icon_state = "crucible_off"

/obj/structure/medieval/oven/crucible/update_icon()
	..()
	if(operating)
		icon_state = "crucible_on"
	else
		icon_state = "crucible_off"

/obj/structure/medieval/oven/crucible/cook()
	itemInside = itemInside.fire_act() //This won't go poorly at all
	if(itemInside) //Some things are replaced and "ejected", others aren't. This deals with the latter (hopefully).
		var/atom/movable/I = itemInside //I would limit this to objects but I have no clue what you can stuff in an oven
		I.forceMove(loc)
	itemInside = null
