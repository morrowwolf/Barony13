//See: code\modules\food_and_drinks\kitchen_machinery\microwave.dm

/obj/structure/medieval/oven
	name = "oven"
	desc = "Cooks and boils things."
	icon = 'barony/icons/oven.dmi'
	icon_state = "oven"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	var/wood = 0 // How much wood is in the dang thing
	var/max_wood = 10 // The most wood it can hold
	var/operating = FALSE // Holds whether it's on or not
	var/max_items = 10 // How many non-wood things fit in the oven
	var/datum/looping_sound/oven/soundloop // The WOOSH and WoOoOOOo fire noises :D
	var/dirty = 0 // Some vestige of how microwave_act() works. REMOVE THIS WHEN YOU WRITE cook_act() SHIT!
	var/efficiency = 0 // DITTO!!
	
/obj/structure/medieval/oven/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)
	
/obj/structure/medieval/oven/examine(mob/user)
	..()
	if(wood)
		to_chat(user,"<span class='notice'>There seems to be enough wood in the oven to cook about [wood] thing\s.</span>")
	else
		to_chat(user,"<span class='notice'>There's no wood inside of [src]!</span>")
	if(contents.len)
		var/noticed = contents[1]
		to_chat(user,"<span class='notice'>You can see \a [noticed] in the oven.</span>")
	else
		to_chat(user,"<span class='notice'>There's nothing inside of the oven to cook.</span>")
		
/obj/structure/medieval/oven/proc/start()
	visible_message("\The [src] roars to life!", "<span class='italics'>You smell something burning.</span>")
	soundloop.start()
	operating = TRUE
	icon_state = "oven_alive"
	
/obj/structure/medieval/oven/proc/stop()
	operating = FALSE // Turn it off again aferwards
	icon_state = "oven"
	soundloop.stop()

/obj/structure/medieval/oven/proc/startcook()
	if(!wood) // If it's broken or there ain't no wood
		return FALSE// Naw
	start()
	cook()
	stop()
	return TRUE
	
/obj/structure/medieval/oven/proc/dispose()
	for (var/obj/O in contents)
		O.forceMove(drop_location())
	to_chat(usr, "<span class='notice'>You dispose of \the [src]'s contents.</span>")

/obj/structure/medieval/oven/proc/cook()
	visible_message("<span class='notice'>[src] is set alight and begins cooking.</span>")
	for(var/obj/item/O in contents)
		if(!wood)
			return
		sleep(75) // 75 deciseconds per thing
		O.microwave_act(src)
		//visible_message("<span class='notice'>[src] cooked a thing!!.</span>")
		wood -= 1

/obj/structure/medieval/oven/AltClick(mob/user)
	if(user.canUseTopic(src, BE_CLOSE) && anchored && wood)
		startcook()
		
/obj/structure/medieval/oven/attack_hand(mob/user)
	if(!startcook()) // Starts cooking. If it fails, it warns there ain't enough wood.
		to_chat(user,"<span class='warning'>There's not enough wood in [src] to start cooking!</span>")
		
/obj/structure/medieval/oven/attackby(obj/item/O, mob/user, params)
	if(operating)
		..()
		return
	else if(istype(O, /obj/item/storage/bag/tray))
		var/obj/item/storage/T = O
		var/loaded = 0
		for(var/obj/item/reagent_containers/food/snacks/S in T.contents)
			if (contents.len>=max_items)
				to_chat(user, "<span class='warning'>[src] is full, you can't put anything in!</span>")
				return 1
			if(SEND_SIGNAL(T, COMSIG_TRY_STORAGE_TAKE, S, src))
				loaded++

		if(loaded)
			to_chat(user, "<span class='notice'>You insert [loaded] items into [src].</span>")
	else if(istype(O, /obj/item/grown/log/tree)) // If it's a log that can be burned
		//Delete the log from their hand
		qdel(O)
		//Add 1 Wood unit to the oven
		wood += 1
		to_chat(user, "<span class='notice'>You insert \the [O] into [src], for burning.</span>")
	else if(istype(O, /obj/item/stack/sheet/mineral/wood)) // If it's some sheets of wood
		//(Which has to be treated a bit special compared to the logs because we're not 100% sure how much of the sheets the user wants to put into the oven)
		handle_wood(O,user)
	else if(O.w_class <= WEIGHT_CLASS_NORMAL && !istype(O, /obj/item/storage) && user.a_intent == INTENT_HELP)
		if (contents.len>=max_items)
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

/obj/structure/medieval/oven/proc/handle_wood(obj/item/stack/sheet/mineral/wood/O, mob/user)
	/*See: 
	code\datums\components\material_container.dm
	Which seems to be the thing that holds & processes materials & item/stack's in machinery such as the autolathe & protolathe
	*/
	set waitfor = FALSE // This is a separate proc specificaly because I need this
	var/requested_amount = input(user, "How much wood do you insert?", "Inserting wood planks") as num|null
	//First some input scrubbing
	if(isnull(requested_amount) || (requested_amount <= 0)) // If they responded like the retards they are
		return
	if(QDELETED(O) || QDELETED(user) || QDELETED(src)) // If anything magically disappeared or goofed while we were waiting on input
		return
	requested_amount = min(requested_amount, O.amount, max_wood - wood) // If they try to take out more than is in the stack, or put more wood than the oven can fit at the moment, then truncate
	//Now on to the real bidness
	if(O.use(requested_amount))
		wood += requested_amount
		to_chat(user, "<span class='notice'>You insert [requested_amount] plank\s of wood, for burning.</span>")
