/obj/structure/medieval/oven/forge
	name = "forge"
	desc = "Forges things."

/obj/structure/medieval/oven/forge/cook()
	if(istype(itemInside, /obj/item/stack/ingot))
		var/obj/item/stack/ingot/I = itemInside
		I.forceMove(loc)
		I.heat()
	else
		itemInside = itemInside.fire_act()
	itemInside = null
