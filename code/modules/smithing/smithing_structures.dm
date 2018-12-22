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

/obj/structure/quenching_barrel
	name = "quenching barrel"
	desc = "A large wooden barrel. You can quench metals inside it, or just use it to hold liquid."
	icon = 'barony/icons/smithing/smithing_structures.dmi'
	icon_state = "quenching_barrel"
	density = TRUE
	anchored = FALSE
	container_type = DRAINABLE | AMOUNT_VISIBLE | REFILLABLE
	pressure_resistance = 2 * ONE_ATMOSPHERE
	max_integrity = 300
	var/start_full = TRUE //Start full of water?

/obj/structure/quenching_barrel/Initialize()
	create_reagents(300)
	if(start_full)
		reagents.add_reagent("water", 300)
	check_anchor()
	. = ..()

/obj/structure/quenching_barrel/examine(mob/user)
	..()
	if(anchored)
		to_chat(user, "<span class='notice'>It is too heavy to move. Try draining it a bit.</span>")

/obj/structure/quenching_barrel/proc/check_anchor() //Moving a barrel full of liquid is hard when you can't roll it. //TODO: Add a way to quickly dump the water
	if(reagents.total_volume > 150)
		anchored = TRUE
	else
		anchored = FALSE

/obj/structure/quenching_barrel/attackby(obj/item/I, mob/user, params) //TODO: Non-water ruins the tool head? Like, if half or more of the total reagent volume is non-water
	if(istype(I, /obj/item/tool_head))
		var/obj/item/tool_head/H = I
		if(!H.heated)
			to_chat(user,"<span class='warning'>\The [H] doesn't need to be quenched!</span>")
			return TRUE
		if(!reagents.has_reagent("water", 10))
			to_chat(user, "<span class='warning'>\The [src] has insufficient water for quenching!</span>")
			return TRUE
		H.quench()
		reagents.remove_reagent("water", 10)
		to_chat(user, "<span class='notice'>You quench \the [H].</span>")
		return TRUE
		check_anchor()
	else
		return ..()

/obj/structure/grindstone
	name = "grindstone"
	desc = "Used to sharpen blades."
	icon = 'barony/icons/smithing/smithing_structures.dmi'
	icon_state = "grindstone"
	density = TRUE
	anchored = TRUE
	max_integrity = 100
