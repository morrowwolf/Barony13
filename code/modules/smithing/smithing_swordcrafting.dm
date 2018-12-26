/obj/item/tool_head/blade
	name = "blade"
	desc = "A placeholder. Yell on github if you see this."
	icon_state = "dagger"
	requires_quenching = TRUE
	heated_icon_state = TRUE
	finished_tool = /obj/item/melee/medieval/blade/dagger

/obj/item/tool_head/blade/dagger
	name = "dagger blade"
	desc = "A blade for a dagger."

/obj/item/tool_head/blade/short_sword
	name = "shortsword blade"
	desc = "A blade for a shortsword."
	icon_state = "short_sword"
	finished_tool = /obj/item/melee/medieval/blade/shortsword

/obj/item/tool_head/blade/sword
	name = "sword blade"
	desc = "A blade for a sword."
	icon_state = "sword"
	finished_tool = /obj/item/melee/medieval/blade/sword

/obj/item/tool_head/blade/attackby(obj/item/O, mob/user, params)
	if(!check_ready(user))
		return
	if(istype(O, /obj/item/tool_head/sword_crafting/sword_assembly))
		to_chat(user, "<span class='notice'>You start attaching \the [src] to \the [O].</span>")
		if(do_after(user, 50, target = O))
			to_chat(user, "<span class='notice'>You attach \the [src] to \the [O].</span>")
			new finished_tool(drop_location())
			qdel(O)
			qdel(src)

/obj/item/tool_head/sword_crafting
	name = "swordcrafting placeholder"
	desc = "A placeholder. Yell on github if you see this."
	icon_state = "crossguard"

/obj/item/tool_head/sword_crafting/crossguard
	name = "crossguard"
	desc = "A crossguard. It needs a pommel with it to be of any use."
	finished_tool = /obj/item/tool_head/sword_crafting/crossguard_and_pommel

/obj/item/tool_head/sword_crafting/pommel
	name = "pommel"
	desc = "A pommel. It needs a crossguard with it to be of any use."
	icon_state = "pommel"
	finished_tool = /obj/item/tool_head/sword_crafting/crossguard_and_pommel

/obj/item/tool_head/sword_crafting/crossguard_and_pommel
	name = "crossguard and pommel"
	desc = "A crossguard and pommel. All it needs is a short handle and then it'll be ready for a blade."
	icon_state = "crossguard_pommel"
	finished_tool = /obj/item/tool_head/sword_crafting/sword_assembly

/obj/item/tool_head/sword_crafting/sword_assembly
	name = "sword assembly"
	desc = "An assembly for a sword or dagger. Just attach it to a blade."
	icon_state = "sword_assembly"

/obj/item/tool_head/sword_crafting/attackby(obj/item/O, mob/user, params)
	if(!check_ready(user))
		return
	if(istype(O, /obj/item/tool_head))
		var/obj/item/tool_head/H = O
		if(!H.check_ready())
			return
	//We could alternatively use a "type == /whatever/" check instead of an "istype(src, /whatever/)" check, but I don't think it matters.
	if((istype(O, /obj/item/tool_head/sword_crafting/crossguard) && istype(src, /obj/item/tool_head/sword_crafting/pommel)) || (istype(src, /obj/item/tool_head/sword_crafting/pommel) && istype(O, /obj/item/tool_head/sword_crafting/crossguard))) //Let's not care which is combined with which
		to_chat(user, "<span class='notice'>You combine \the [src] with \the [O].</span>")
		new finished_tool(drop_location())
		qdel(O)
		qdel(src)
	else if(istype(src, /obj/item/tool_head/sword_crafting/crossguard_and_pommel) && istype(O, /obj/item/handle))
		if(istype(O, /obj/item/handle/long))
			to_chat(user, "<span class='warning'>\the [src] needs a short handle, you fool!</span>")
			return
		to_chat(user, "<span class='notice'>You start attaching \the [src] to \the [O].</span>")
		if(do_after(user, 50, target = O))
			to_chat(user, "<span class='notice'>You attach \the [src] to \the [O].</span>")
			new finished_tool(drop_location())
			qdel(O)
			qdel(src)
	else if(istype(src, /obj/item/tool_head/sword_crafting/sword_assembly) && istype(O, /obj/item/tool_head/blade))
		var/obj/item/tool_head/B = O
		if(isnull(B.finished_tool))
			CRASH("[B]'s finished_tool is null!")
			return
		to_chat(user, "<span class='notice'>You start attaching \the [src] to \the [B].</span>")
		if(do_after(user, 50, target = B))
			to_chat(user, "<span class='notice'>You attach \the [src] to \the [B].</span>")
			new B.finished_tool(drop_location())
			qdel(B)
			qdel(src)
