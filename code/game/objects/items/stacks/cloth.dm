/obj/item/stack/torncloth
	name = "strip of torn cloth"
	desc = "Looks like it was pulled from a piece of clothing with considerable force. Could be used for a makeshift bandage if worked a little bit on a sturdy surface."
	icon = 'yogstation/icons/obj/items.dmi'
	icon_state = "clothscrap"
	max_amount = 50
	
/obj/item/stack/torncloth/Initialize(mapload, new_amount, merge = TRUE)
	recipes = list(new/datum/stack_recipe("Improvised Bandage",  /obj/item/medical/bandage/improvised, 1))
	. = ..()