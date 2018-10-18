/obj/effect/mob_spawn/human/medieval
	desc = "An old bed that looks out of place.  Something... seems to be under there?"
	icon = 'yogstation/icons/obj/medieval.dmi'
	icon_state = "medieval_spawner"
	density = TRUE
	roundstart = FALSE
	death = FALSE
	outfit = /datum/outfit/medieval
	
/obj/effect/mob_spawn/human/medieval/special(mob/living/new_spawn)
	if(ishuman(new_spawn))
		var/mob/living/carbon/human/H = new_spawn
		H.gender = pick(FEMALE, MALE)
		H.real_name = random_unique_name(H.gender)
		H.underwear = "Nude"
		H.update_body()
		return H
	
/obj/effect/mob_spawn/human/medieval/Destroy()
	new/obj/structure/bed/medieval(get_turf(src))
	return ..()
	
/datum/outfit/medieval
	uniform = /obj/item/clothing/under/yogs/peasant
	
/obj/effect/mob_spawn/human/medieval/knight
	name = "covered knightly bed"
	mob_name = "a knight"
	flavour_text = "<span class='big bold'>You are a knight,</span><b> a lord and landowner of the medieval era.  You don't remember what happened except for the vague memories of an angry wizard.  Protect those who serve you and find a new home.  Always use violence as a last resort.</b>"
	assignedrole = "Knight"
	outfit = /datum/outfit/medieval/knight
	
/obj/effect/mob_spawn/human/medieval/knight/special(mob/living/new_spawn)
	. = ..()
	if(istype(., /mob/living/carbon/human))
		var/mob/living/carbon/human/H = .
		H.real_name = "Sir " + H.real_name
		H.job = "knight"
		
/datum/outfit/medieval/knight
	shoes = /obj/item/clothing/shoes/yogs/boots
	suit = /obj/item/clothing/suit/armor/knight
	back = /obj/item/melee/medieval/blade/sword

/obj/effect/mob_spawn/human/medieval/peasant
	name = "covered peasant bed"
	mob_name = "a peasant"
	flavour_text = "<span class='big bold'>You are a peasant,</span><b> a serf and servant of the medieval era.  All you remember is a wizard being angry at your lord.  Serve your lord in all capacities.</b>"
	assignedrole = "Peasant"
	outfit = /datum/outfit/medieval/peasant
	
/datum/outfit/medieval/peasant
	head = /obj/item/clothing/head/yogs/peasant
	belt = /obj/item/melee/medieval/blade/dagger
