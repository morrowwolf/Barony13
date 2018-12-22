GLOBAL_LIST_INIT(iron_ingot_recipes, list ( \
	new/datum/stack_recipe("shovel head", /obj/item/tool_head/shovel, 2, on_floor = TRUE), \
	new/datum/stack_recipe("felling axe head", /obj/item/tool_head/felling_axe, 2, on_floor = TRUE), \
	new/datum/stack_recipe("hammer head", /obj/item/tool_head/hammer, 1, on_floor = TRUE) \
))

//TODO: steel and gold recipes
//TODO: Handcuff crafting?

/obj/item/stack/ore/iron/medieval
	refined_type = /obj/item/stack/ingot/iron

/obj/item/stack/ore/iron/medieval/five
	amount = 5

/obj/item/stack/ingot
	name = "ingot"
	desc = "It's an ingot."
	icon = 'barony/icons/smithing/ingots.dmi'
	icon_state = "iron"
	singular_name = "ingot"
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)
	throwforce = 10
	flags_1 = CONDUCT_1
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/ingot
	var/heated = FALSE

/obj/item/stack/ingot/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/ingot/examine(mob/user)
	..()
	if(heated)
		to_chat(user, "<span class='notice'>\The [src]\s [amount > 1 ? "are" : "is"] heated.</span>")
	else
		to_chat(user, "<span class='notice'>\The [src]\s [amount > 1 ? "aren't" : "isn't"] heated.</span>")

/obj/item/stack/ingot/update_icon()
	if(heated)
		icon_state = "heated[amount > 1 ? "_multiple" : ""]"
	else
		icon_state = "[initial(icon_state)][amount > 1 ? "_multiple" : ""]"


/obj/item/stack/ingot/proc/heat()
	name = "heated [initial(name)]"
	heated = TRUE
	update_icon()
	addtimer(CALLBACK(src, .proc/cool), 150)

/obj/item/stack/ingot/proc/cool()
	name = "[initial(name)]"
	heated = FALSE
	update_icon()

/obj/item/stack/ingot/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/hammer))
		if(!heated)
			to_chat(user, "<span class='warning'>\The [src][amount > 1 ? "s" : ""] [amount > 1 ? "aren't" : "isn't"] heated.</span>")
		else
			interact(user)

	else
		..()

/obj/item/stack/ingot/attack_self(mob/user)
	if(!heated)
		to_chat(user, "<span class='notice'>You need to heat \the [src][amount > 1 ? "s" : ""].</span>")
	else
		to_chat(user, "<span class='notice'>Use a hammer to shape \the [src][amount > 1 ? "s" : ""].</span>")
	return

/obj/item/stack/ingot/iron
	name = "iron ingot"
	desc = "Ingots of iron."
	singular_name = "iron ingot"
	grind_results = list("iron" = 20)
	merge_type = /obj/item/stack/ingot/iron

/obj/item/stack/ingot/steel
	name = "steel ingot"
	desc = "Ingots of steel."
	icon_state = "steel"
	singular_name = "steel ingot"
	grind_results = list("iron" = 20, "coal" = 20)
	merge_type = /obj/item/stack/ingot/steel

/obj/item/stack/ingot/gold
	name = "gold ingot"
	desc = "Ingots of gold."
	icon_state = "gold"
	singular_name = "gold ingot"
	grind_results = list("gold" = 20)
	merge_type = /obj/item/stack/ingot/gold

/obj/item/stack/ingot/iron/Initialize(mapload, new_amount, merge = TRUE)
	recipes = GLOB.iron_ingot_recipes
	return ..()

/obj/item/stack/ingot/iron/five
	amount = 5

/obj/item/hammer
	desc = "It's hammertime."
	name = "hammer"
	icon = 'barony/icons/smithing/smithing_items.dmi'
	icon_state = "hammer"
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
	icon = 'barony/icons/smithing/smithing_items.dmi'
	icon_state = "handle_short"
	force = 6
	throw_speed = 3
	throw_range = 4
	throwforce = 4
	w_class = WEIGHT_CLASS_TINY

/obj/item/handle/long
	name = "long handle"
	desc = "A long handle for a tool or weapon."
	icon_state = "handle_long"
	force = 8
	throwforce = 6
	w_class = WEIGHT_CLASS_SMALL

// TOOL HEADS

/obj/item/tool_head
	name = "tool head"
	desc = "A tool head. It'd probably work better with a handle."
	icon = 'barony/icons/smithing/smithing_items.dmi'
	icon_state = "head_axe"
	var/ruined = FALSE //If someone fucked something up and made the tool head unusable for some reason.
	var/heated = TRUE
	var/finished_tool
	var/long_handle = FALSE //Set to true if it needs a long handle
	var/requires_quenching = FALSE //It's mainly just weapons that require quenching, since they're steel
	var/heated_icon_state //if it has a special heated icon. Mainly just swords.

/obj/item/tool_head/Initialize()
	. = ..()
	if(heated)
		name = "heated [initial(name)]"
		addtimer(CALLBACK(src, .proc/quench, FALSE), 3000) //5 minutes before it air-cools. Not super realistic but whatever.
	update_icon()

/obj/item/tool_head/proc/quench(var/proper_quenching = TRUE)
	if(ruined || !heated) //Quenching is pointless
		return
	heated = FALSE
	update_icon()
	if(requires_quenching && !proper_quenching)
		visible_message("<span class='warning'>\The [src] was not properly quenched in time. It has been ruined!</span>")
		ruined = TRUE
		name = "ruined [initial(name)]"
		return
	name = "[initial(name)]"

/obj/item/tool_head/update_icon()
	if(heated && heated_icon_state)
		icon_state = "[heated_icon_state]"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/tool_head/examine(mob/user)
	..()
	if(ruined)
		to_chat(user, "<span class='warning'>[src] is ruined, it can't be used for anything!</span>")
		return
	if(heated)
		if(requires_quenching)
			to_chat(user, "<span class='warning'>Quench it before it's ruined!</span>")
		else
			to_chat(user, "<span class='warning'>Quench it or wait a few minutes for it to cool.</span>")
	else //Avoid spamming the user with tons of info at once
		if(long_handle)
			to_chat(user, "<span class='notice'>[src] requires a long handle.</span>")
		else
			to_chat(user, "<span class='notice'>[src] requires a short handle.</span>")


/obj/item/tool_head/attackby(obj/item/O, mob/user, params)
	if(ruined)
		to_chat(user, "<span class='warning'>[src] is ruined, it can't be used for anything!</span>")
		return
	if(heated)
		if(requires_quenching)
			to_chat(user, "<span class='warning'>Quench it first you fool.</span>")
		else
			to_chat(user, "<span class='warning'>Quench it or wait for it to cool.</span>")
		return
	if(isnull(finished_tool))
		CRASH("[src]'s finished_tool is null!'")
		return
	if(istype(O, /obj/item/handle) && !istype(O, /obj/item/handle/long))
		if(long_handle)
			to_chat(user, "<span class='warning'>[src] needs a long handle.</span>")
			return
		to_chat(user, "<span class='notice'>You start attaching \the [src] to \the [O].</span>")
		if(do_after(user, 50, target = O))
			to_chat(user, "<span class='notice'>You attach \the [src] to \the [O].</span>")
			new finished_tool(drop_location())
			qdel(O)
			qdel(src)
	else if(istype(O, /obj/item/handle/long))
		if(!long_handle)
			to_chat(user, "<span class='warning'>[src] needs a short handle.</span>")
			return
		to_chat(user, "<span class='notice'>You start attaching \the [src] to \the [O].</span>")
		if(do_after(user, 50, target = O))
			to_chat(user, "<span class='notice'>You attach \the [src] to \the [O].</span>")
			new finished_tool(drop_location())
			qdel(O)
			qdel(src)

// RECIPES

/obj/item/tool_head/felling_axe
	name = "felling axe head"
	desc = "A felling axe head."
	finished_tool = /obj/item/twohanded/fireaxe/fellingaxe
	long_handle = TRUE

/obj/item/tool_head/shovel
	name = "shovel head"
	desc = "A shovel head."
	finished_tool = /obj/item/shovel
	long_handle = TRUE
	icon_state = "head_shovel"

/obj/item/tool_head/hammer
	name = "hammer head"
	desc = "A hammer head. The tool, not the shark."
	finished_tool = /obj/item/hammer
