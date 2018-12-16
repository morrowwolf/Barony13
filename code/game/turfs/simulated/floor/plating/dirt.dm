/turf/open/floor/plating/dirt
	gender = PLURAL
	name = "dirt"
	desc = "Upon closer examination, it's still dirt."
	icon = 'icons/turf/floors.dmi'
	icon_state = "dirt"
	attachment_holes = FALSE
	baseturfs = /turf/open/floor/plating/dirt

/turf/open/floor/plating/dirt/dark
	icon_state = "greenerdirt"

/turf/open/floor/plating/dirt/MakeSlippery() //Slipping on dirt is silly
	return

/turf/open/floor/plating/dirt/attackby(obj/item/C, mob/user, params)
	if((C.tool_behaviour == TOOL_SHOVEL) && params)
		if(locate(/obj/machinery/hydroponics/soil) in get_turf(src))
			to_chat(user, "This has already been cultivated.")
			return
		user.visible_message("[user] starts to cultivate \the [src].", "<span class='notice'>You start to cultivate \the [src].</span>")
		if(do_after(user, 50, target=src))
			user.visible_message("[user] cultivates \the [src].", "<span class='notice'>You cultivate \the [src].</span>")
			playsound(src, 'sound/effects/shovel_dig.ogg', 50, 1)
			var/obj/machinery/hydroponics/soil/medieval/S = new(get_turf(src))
			S.waterlevel = rand(25, 50)

	if(..())
		return
