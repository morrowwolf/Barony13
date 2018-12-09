GLOBAL_LIST_INIT(iron_ingot_recipes, list ( \
	new/datum/stack_recipe("stool", /obj/structure/chair/stool, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("bar stool", /obj/structure/chair/stool/bar, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("chair", /obj/structure/chair, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("bed", /obj/structure/bed, 2, one_per_turf = TRUE, on_floor = TRUE), \
	new/datum/stack_recipe("felling axe head", /obj/item/tool_head/felling_axe, 2, on_floor = TRUE) \
))

/obj/item/stack/ore/iron/medieval
	refined_type = /obj/item/stack/ingot/iron

/obj/item/stack/ore/iron/medieval/five
	amount = 5

/obj/item/stack/ingot
	name = "ingot"
	desc = "It's an ingot."
	icon = 'icons/obj/economy.dmi'
	icon_state = "coin__heads"
	singular_name = "ingot"
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)
	throwforce = 10
	flags_1 = CONDUCT_1
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/ingot
	var/heated = FALSE

/obj/item/stack/ingot/examine(mob/user)
	..()
	if(heated)
		to_chat(user, "\The [src]\s [amount > 1 ? "are" : "is"] heated.")
	else
		to_chat(user, "\The [src]\s [amount > 1 ? "aren't" : "isn't"] heated.")

/obj/item/stack/ingot/proc/heat()
	name = "heated [initial(name)]"
	heated = TRUE
	//update_icon() //TODO: separate icon for heated ingots
	addtimer(CALLBACK(src, .proc/cool), 150)

/obj/item/stack/ingot/proc/cool()
	name = "[initial(name)]"
	heated = FALSE
	//update_icon()

/obj/item/stack/ingot/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/hammer))
		if(!heated)
			to_chat(user, "\The [src][amount > 1 ? "s" : ""] [amount > 1 ? "aren't" : "isn't"] heated.")
		else
			interact(user)

	else
		..()

/obj/item/stack/ingot/attack_self(mob/user)
	if(!heated)
		to_chat(user, "You need to heat \the [src][amount > 1 ? "s" : ""].")
	else
		to_chat(user, "Use a hammer to shape \the [src][amount > 1 ? "s" : ""].")
	return

/obj/item/stack/ingot/iron
	name = "iron ingot"
	desc = "Ingots of iron."
	icon_state = "coin_iron_heads"
	singular_name = "iron ingot"
	grind_results = list("iron" = 20)
	merge_type = /obj/item/stack/ingot/iron

/obj/item/stack/ingot/iron/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.iron_ingot_recipes
	return ..()

/obj/item/stack/ingot/iron/five
	amount = 5

/obj/item/hammer
	desc = "It's hammertime."
	name = "hammer"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "toyhammer"
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	attack_verb = list("hammered", "smashed")

/obj/item/handle
	name = "handle"
	desc = "A handle for a tool or weapon."
	icon_state = "nullrod"
	item_state = "nullrod"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	force = 6
	throw_speed = 3
	throw_range = 4
	throwforce = 4
	w_class = WEIGHT_CLASS_TINY

/obj/item/handle/long
	name = "long handle"
	desc = "A long handle for a tool or weapon."
	force = 8
	throwforce = 6
	w_class = WEIGHT_CLASS_SMALL

/obj/item/tool_head
	name = "tool head"
	desc = "A tool head. It'd probably work better with a handle."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "toolhead_axe"
	item_state = "toolhead_axe"
	var/heated = TRUE
	var/finished_tool
	var/long_handle = FALSE //Set to true if it needs a long handle

/obj/item/tool_head/Initialize()
	. = ..()
	if(heated)
		name = "heated [initial(name)]"

/obj/item/tool_head/proc/quench()
	heated = FALSE
	name = "[initial(name)]"

/obj/item/tool_head/examine(mob/user)
	..()
	if(heated)
		to_chat(user, "Quench it before you burn yourself.")

/obj/item/tool_head/attackby(obj/item/O, mob/user, params)
	if(heated)
		to_chat(user, "Quench it first you fool.")
		return
	if(isnull(finished_tool))
		CRASH("[src]'s finished_tool is null!'")
		return
	if(istype(O, /obj/item/handle) && !istype(O, /obj/item/handle/long))
		if(long_handle)
			to_chat(user, "[src] needs a long handle.")
			return
		to_chat(user, "You start attaching \the [src] to \the [O].")
		if(do_after(user, 50, target = O))
			to_chat(user, "You attach \the [src] to \the [O].")
			new finished_tool(drop_location())
			qdel(O)
			qdel(src)
	else if(istype(O, /obj/item/handle/long))
		if(!long_handle)
			to_chat(user, "[src] needs a short handle.")
			return
		to_chat(user, "You start attaching \the [src] to \the [O].")
		if(do_after(user, 50, target = O))
			to_chat(user, "You attach \the [src] to \the [O].")
			new finished_tool(drop_location())
			qdel(O)
			qdel(src)

/obj/item/tool_head/felling_axe
	name = "felling axe head"
	desc = "A felling axe head."
	finished_tool = /obj/item/twohanded/fireaxe/fellingaxe
	long_handle = TRUE
