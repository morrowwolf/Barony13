
/mob
	var/bloody_hands = 0 //what the fuck

/obj/item/clothing/gloves
	var/transfer_blood = 0


/obj/item/reagent_containers/glass/rag
	name = "damp rag"
	desc = "For cleaning up messes, you suppose. Make sure to wet it first with water."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	item_flags = NOBLUDGEON
	container_type = OPENCONTAINER
	amount_per_transfer_from_this = 2
	possible_transfer_amounts = list()
	volume = 10
	spillable = FALSE
	var/cleanspeed = 50 //slower than mop, same as soap

/obj/item/reagent_containers/glass/rag/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is smothering [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (OXYLOSS)

/obj/item/reagent_containers/glass/rag/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity || !check_allowed_items(target))
		return
	if(iscarbon(target) && target.reagents && reagents.total_volume)
		var/mob/living/carbon/C = target
		var/reagentlist = pretty_string_from_reagent_list(reagents)
		var/log_object = "a damp rag containing [reagentlist]"
		if(user.a_intent == INTENT_HARM && !C.is_mouth_covered())
			reagents.reaction(C, INGEST)
			reagents.trans_to(C, reagents.total_volume)
			C.visible_message("<span class='danger'>[user] has smothered \the [C] with \the [src]!</span>", "<span class='userdanger'>[user] has smothered you with \the [src]!</span>", "<span class='italics'>You hear some struggling and muffled cries of surprise.</span>")
			log_combat(user, C, "smothered", log_object)
		else
			reagents.reaction(C, TOUCH)
			reagents.clear_reagents()
			C.visible_message("<span class='notice'>[user] has touched \the [C] with \the [src].</span>")
			log_combat(user, C, "touched", log_object)
		return

	if(!reagents.has_reagent("water") || reagents.total_volume < 2)
		to_chat(user, "<span class='warning'>\The [src] is dry! Wet it with water first.</span>")
		return

	if(user.client && ((target in user.client.screen) && !user.is_holding(target)))
		to_chat(user, "<span class='warning'>You need to take that [target.name] off before cleaning it!</span>")

	else if(istype(target, /obj/effect/decal/cleanable))
		user.visible_message("[user] begins to scrub \the [target.name] out with [src].", "<span class='warning'>You begin to scrub \the [target.name] out with [src]...</span>")
		if(do_after(user, cleanspeed, target = target))
			to_chat(user, "<span class='notice'>You scrub \the [target.name] out.</span>")
			qdel(target)
			reagents.remove_reagent("water", 2)

	else if(istype(target, /obj/structure/window))
		user.visible_message("[user] begins to clean \the [target.name] with [src]...", "<span class='notice'>You begin to clean \the [target.name] with [src]...</span>")
		if(do_after(user, cleanspeed, target = target))
			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			target.set_opacity(initial(target.opacity))
			SEND_SIGNAL(target, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)
			reagents.remove_reagent("water", 2)
	else
		user.visible_message("[user] begins to clean \the [target.name] with [src]...", "<span class='notice'>You begin to clean \the [target.name] with [src]...</span>")
		if(do_after(user, cleanspeed, target = target))
			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
			var/obj/effect/decal/cleanable/C = locate() in target
			qdel(C)
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			SEND_SIGNAL(target, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
			target.wash_cream()
			reagents.remove_reagent("water", 2)
	return
