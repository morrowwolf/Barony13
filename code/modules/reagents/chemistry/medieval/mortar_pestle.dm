/obj/item/reagent_containers/glass/beaker/mortar
	name = "mortar"
	desc = "Used with a pestle to grind, juice, or mix reagents."
	icon = 'yogstation/icons/obj/medieval.dmi'
	icon_state = "mortar"

	var/limit = 10
	var/list/holdingitems = list()

	//TODO: GOTTA GO BACK AND ADD TIMERS TO SHIT

/obj/item/reagent_containers/glass/beaker/mortar/update_icon()
	if(reagents.total_volume)
		var/percent = round((reagents.total_volume / volume) * 100) + (holdingitems.len * 10)

		if(percent >= 50)
			icon_state = "mortar-misc"
		else
			icon_state = "mortar"

/obj/item/reagent_containers/glass/beaker/mortar/throw_at()
	..()
	update_icon()

/obj/item/reagent_containers/glass/beaker/mortar/Destroy()
	drop_all_items()
	return ..()

/obj/item/reagent_containers/glass/beaker/mortar/proc/drop_all_items()
	for(var/i in holdingitems)
		var/atom/movable/AM = i
		AM.forceMove(drop_location())
	holdingitems = list()

/obj/item/reagent_containers/glass/beaker/mortar/examine(mob/user)
	..()
	var/dat = ""
	if(holdingitems.len == 1)
		dat = " [holdingitems[holdingitems.len].name]."
	else
		for (var/i in holdingitems)
			var/obj/item/O = i
			if(O == holdingitems[holdingitems.len])
				dat += "and [O.name]."
			else
				dat += "[O.name], "

	to_chat(user, "The mortar contains the following for processing: [dat]")
	

/obj/item/reagent_containers/glass/beaker/mortar/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pestle))
		var/obj/item/pestle/P = I

		if(cmptext(P.action, "grind"))
			grind(user)
		else if(cmptext(P.action, "juice"))
			juice(user)
		else
			mix(user)

		return FALSE

	if(holdingitems.len >= limit)
		to_chat(user, "<span class='warning'>[src] is filled to capacity!</span>")
		return TRUE

	if(!I.grind_results && !I.juice_results)
		return ..()

	if(!I.grind_requirements(src)) //Error messages should be in the objects' definitions
		return

	if(user.transferItemToLoc(I, src))
		to_chat(user, "<span class='notice'>You add [I] to [src].</span>")
		holdingitems[I] = TRUE
		return FALSE

/obj/item/reagent_containers/glass/beaker/mortar/AltClick(mob/user)
	if(!length(holdingitems))
		return
	for(var/i in holdingitems)
		var/obj/item/O = i
		O.forceMove(drop_location())
		holdingitems -= O

/obj/item/reagent_containers/glass/beaker/mortar/proc/juice(mob/user)
	if(reagents.total_volume >= reagents.maximum_volume)
		return

	for(var/obj/item/i in holdingitems)
		if(reagents.total_volume >= reagents.maximum_volume)
			break
		var/obj/item/I = i
		if(I.juice_results)
			to_chat(user,"You juice the [I.name].")
			juice_item(I)

/obj/item/reagent_containers/glass/beaker/mortar/proc/juice_item(obj/item/I) //Juicing results can be found in respective object definitions
	if(I.on_juice(src) == -1)
		to_chat(usr, "<span class='danger'>[I] doesn't seem to juice correctly.</span>")
		return
	reagents.add_reagent_list(I.juice_results)
	remove_object(I)

/obj/item/reagent_containers/glass/beaker/mortar/proc/grind(mob/user)
	if(reagents.total_volume >= reagents.maximum_volume)
		return

	for(var/i in holdingitems)
		if(reagents.total_volume >= reagents.maximum_volume)
			break
		var/obj/item/I = i
		if(I.grind_results)
			to_chat(user,"You grind the [I.name].")
			grind_item(i)

/obj/item/reagent_containers/glass/beaker/mortar/proc/grind_item(obj/item/I) //Grind results can be found in respective object definitions
	if(I.on_grind(src) == -1) //Call on_grind() to change amount as needed, and stop grinding the item if it returns -1
		to_chat(usr, "<span class='danger'>[I] doesn't seem to grind correctly.</span>")
		return
	reagents.add_reagent_list(I.grind_results)
	if(I.reagents)
		I.reagents.trans_to(src, I.reagents.total_volume)
	remove_object(I)

/obj/item/reagent_containers/glass/beaker/mortar/proc/mix(mob/user)
	//For butter and other things that would change upon shaking or mixing
	mix_complete()

/obj/item/reagent_containers/glass/beaker/mortar/proc/mix_complete()
	if(reagents.total_volume)
		//Recipe to make Butter
		var/butter_amt = FLOOR(reagents.get_reagent_amount("milk") / MILK_TO_BUTTER_COEFF, 1)
		reagents.remove_reagent("milk", MILK_TO_BUTTER_COEFF * butter_amt)
		for(var/i in 1 to butter_amt)
			new /obj/item/reagent_containers/food/snacks/butter(drop_location())
		//Recipe to make Mayonnaise
		if (reagents.has_reagent("eggyolk"))
			var/amount = reagents.get_reagent_amount("eggyolk")
			reagents.remove_reagent("eggyolk", amount)
			reagents.add_reagent("mayonnaise", amount)

/obj/item/reagent_containers/glass/beaker/mortar/proc/remove_object(obj/item/O)
	holdingitems -= O
	qdel(O)

/obj/item/pestle
	name = "pestle"
	desc = "Used with a mortar to grind, juice, or mix reagents."
	icon = 'yogstation/icons/obj/medieval.dmi'
	icon_state = "pestle"

	var/action = "grind"
	var/list/action_types = list("grind", "juice", "mix")

/obj/item/pestle/examine(mob/user)
	..()
	to_chat(user, "The pestle is currently going to [action] when used with a mortar.")

/obj/item/pestle/attack_self(mob/living/user)
	if(cmptext(action, action_types[1]))
		action = action_types[2]
		to_chat(user, "You will now juice when using the pestle on a mortar.")
	else if(cmptext(action, action_types[2]))
		action = action_types[3]
		to_chat(user, "You will now mix when using the pestle on a mortar.")
	else
		action = action_types[1]
		to_chat(user, "You will now grind when using the pestle on a mortar.")
