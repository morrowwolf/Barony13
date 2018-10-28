//See: code\modules\food_and_drinks\kitchen_machinery\microwave.dm

/obj/dohickey/oven
	name = "oven"
	desc = "Cooks and boils things."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	pass_flags = PASSTABLE
	var/wood = 0 // How much wood is in the dang thing
	var/max_wood = 10 // The most wood it can hold
	var/operating = FALSE // Holds whether it's on or not
	var/max_n_of_items = 10 // How many things fit in the oven
	
/obj/dohickey/oven/examine(mob/user)
	..()
	if(wood)
		to_chat(user,"There seems to be [wood] logs within the oven.")
	else
		to_chat(user,"<span class='notice'>There's no wood inside of [src]!</span>")
	if(contents.len)
		to_chat(user,"There's something in the oven to cook.")
	else
		to_chat(user,"There's nothing inside of the oven to cook.")
		
/obj/dohickey/oven/proc/start()
	visible_message("The [src] roars to life!", "<span class='italics'>You smell something burning.</span>")
	//soundloop.start()
	operating = TRUE
	icon_state = "mw1"
	updateUsrDialog()
	
/obj/dohickey/oven/proc/stop()
	operating = FALSE // Turn it off again aferwards
	icon_state = "mw"
	updateUsrDialog()
	//soundloop.stop()

/obj/dohickey/oven/proc/startcook()
	if(!wood) // If it's broken or there ain't no wood
		return FALSE// Naw
	start()
	cook()
	stop()
	return TRUE
	
/obj/dohickey/oven/proc/dispose()
	for (var/obj/O in contents)
		O.forceMove(drop_location())
	to_chat(usr, "<span class='notice'>You dispose of \the [src]'s contents.</span>")
	updateUsrDialog()

/obj/dohickey/oven/proc/cook()
	visible_message("<span class='notice'>[src] is set alight and begins cooking.</span>")
	for(var/obj/item/O in contents)
		if(!wood)
			return
		O.microwave_act(src)
		visible_message("<span class='notice'>[src] cooked a thing!!.</span>")
		wood -= 1
		sleep(12) // The old SS13 microwave, regular parts, did basically sleep(10), so we're doing that too, more or less

/obj/dohickey/oven/AltClick(mob/user)
	if(user.canUseTopic(src, BE_CLOSE) && anchored && wood)
		startcook()

/obj/dohickey/oven/attackby(obj/item/O, mob/user, params)
	to_chat(user,"Penis!")
	if(operating)
		..()
		return
	if(!O) // If there's no object in their hand, then we're assuming that they're trying to make the dang thing cook.
		if(!startcook()) // Starts cooking. If it fails, it warns there ain't enough wood.
			to_chat(user,"<span class='warning'>There's not enough wood in [src] to start cooking!</span>")
		else
			to_chat(user,"It should start cooking, I guess!")
	else if(istype(O, /obj/item/storage/bag/tray))
		var/obj/item/storage/T = O
		var/loaded = 0
		for(var/obj/item/reagent_containers/food/snacks/S in T.contents)
			if (contents.len>=max_n_of_items)
				to_chat(user, "<span class='warning'>[src] is full, you can't put anything in!</span>")
				return 1
			if(SEND_SIGNAL(T, COMSIG_TRY_STORAGE_TAKE, S, src))
				loaded++

		if(loaded)
			to_chat(user, "<span class='notice'>You insert [loaded] items into [src].</span>")
	else if(istype(O, /obj/item/grown/log/tree))
		//Delete the log from their hand
		qdel(O)
		//Add 1 Wood unit to the oven
		wood += 1
	else if(O.w_class <= WEIGHT_CLASS_NORMAL && !istype(O, /obj/item/storage) && user.a_intent == INTENT_HELP)
		if (contents.len>=max_n_of_items)
			to_chat(user, "<span class='warning'>[src] is full, you can't put anything in!</span>")
			return 1
		else
			if(!user.transferItemToLoc(O, src))
				to_chat(user, "<span class='warning'>\the [O] is stuck to your hand, you cannot put it in \the [src]!</span>")
				return 0

			user.visible_message( \
				"[user] has added \the [O] to \the [src].", \
				"<span class='notice'>You add \the [O] to \the [src].</span>")

	else
		..()
	updateUsrDialog()

/*
/obj/dohickey/oven/Topic(href, href_list)
	if(..())
		return

	//usr.set_machine(src)
	if(operating)
		updateUsrDialog()
		return

	switch(href_list["action"])
		if ("cook")
			startcook()

		if ("eject")
			dispose()
	updateUsrDialog()
*/
	
