/obj/structure/medieval/oven
	name = "oven"
	desc = "Cooks and boils things."
	icon = 'barony/icons/oven.dmi'
	icon_state = "oven"
	layer = BELOW_OBJ_LAYER
	density = TRUE

	var/obj/item/itemInside
	var/cookProgress = 0				//goes from 0 to 100 while processing to handle cook time, reset on taking itemInside out

	var/list/wood = list() //current wood
	var/gas = 0				//current gas supplied by wood

	var/operating = FALSE // Holds whether it's on or not
	var/datum/looping_sound/oven/soundloop // Noises while it's on


/obj/structure/medieval/oven/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)

/obj/structure/medieval/oven/Destroy()
	if(operating)
		STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/medieval/oven/examine(mob/user)
	..()
	if(itemInside)
		if(cookProgress <= 0)
			to_chat(user, "It has [itemInside.name] inside it ready to cook.")
		else if(cookProgress < 25)
			to_chat(user, "[itemInside] looks as if it just started being cooked.")
		else if(cookProgress < 50)
			to_chat(user, "[itemInside] looks as if it is a little less than halfway done.")
		else if(cookProgress < 75)
			to_chat(user, "[itemInside] looks as if it is over half way done.")
		else if(cookProgress < 100)
			to_chat(user, "[itemInside] looks as if it is almost done.")
	var/amount = 0
	for(var/obj/item/I in wood)
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			amount += S.amount
		else
			amount += 1
	to_chat(user, "The [src] has [amount] logs left.")
	to_chat(user, "Turn the [src] on or off by control-clicking.")

/obj/structure/medieval/oven/attack_hand(mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(itemInside)
		user.put_in_hands(itemInside)
		itemInside = null
		cookProgress = 0
	else if(wood && wood.len)
		user.put_in_hands(wood[wood.len])
		wood.Remove(wood[wood.len])


/obj/structure/medieval/oven/attackby(obj/item/O, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(O, /obj/item/grown/log/tree) || istype(O, /obj/item/stack/sheet/mineral/wood))
		wood.Add(O)
		O.forceMove(src)
	else if(O.w_class <= WEIGHT_CLASS_NORMAL && !istype(O, /obj/item/storage))
		if(itemInside)
			to_chat(user, "An item is already in the [src]!")
			return
		itemInside = O
		O.forceMove(src)
	else
		..()

/obj/structure/medieval/oven/CtrlClick(mob/user)
	if(!(user in range(1, src)))
		return

	if(operating)
		turnOff()
	else
		if(!gas)
			if(!handleGas())
				to_chat(user, "Not enough gas!  Feed the [src] logs or wood.")
				return
		turnOn()

/obj/structure/medieval/oven/proc/turnOn()
	icon_state = "oven_alive"
	START_PROCESSING(SSprocessing, src)
	operating = TRUE
	soundloop.start()
	visible_message("[src] bursts to life.")
	set_light(5)

/obj/structure/medieval/oven/proc/turnOff()
	icon_state = "oven"
	STOP_PROCESSING(SSprocessing, src)
	operating = FALSE
	soundloop.stop()
	visible_message("[src]'s flames die down.")
	set_light(0)

/obj/structure/medieval/oven/proc/handleGas()
	if(wood && wood.len)
		if(istype(wood[1], /obj/item/stack))
			var/obj/item/stack/O = wood[1]
			O.amount -= 1
			if(O.amount <= 0)
				qdel(wood[1])
				wood.Remove(wood[1])
			gas = 100
			return TRUE
		else
			qdel(wood[1])
			wood.Remove(wood[1])
			gas = 100
			return TRUE

	return FALSE

/obj/structure/medieval/oven/process()
	gas -= 10

	if(gas <= 0)
		if(!handleGas())
			turnOff()

	if(itemInside)
		cookProgress += 10
	if(cookProgress >= 100)
		cook()
		cookProgress = 0

/obj/structure/medieval/oven/proc/cook()
	itemInside = itemInside.microwave_act()
	itemInside.forceMove(src)
	itemInside = null
