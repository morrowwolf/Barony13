/obj/item/reagent_containers/glass/beaker/mug
	name = "mug"
	desc = "A mug for holding all sorts."
	icon = 'yogstation/icons/obj/medieval.dmi'
	icon_state = "mug"
	item_state = "mug"

	possible_transfer_amounts = list(2, 5, 10)
	volume = 10

/obj/item/reagent_containers/glass/beaker/mug/update_icon()
	if(reagents.total_volume)
		var/percent = round((reagents.total_volume / volume) * 100)

		if(percent >= 90)
			icon_state = "mug-full"
		else
			icon_state = "mug"

/obj/item/reagent_containers/glass/beaker/mug/after_throw(datum/callback/callback)
	..()
	update_icon()