//////////////////////////////////////////////////////////////////////////////////////////////
// How to use these: 																		//
// In map view, right click on the object for the walls then, generate instances by DIR		//
// That'll now give you all the wall sprites												//
// You definately want to icon smooth these, but I succ at that.							//
// See baystation's repo for that. It has the template										//
// Merry christmas :)																		//
//////////////////////////////////////////////////////////////////////////////////////////////


/turf/closed/wall/barony
	name = "Poor quality wooden wall"
	desc = "Thees wall be of lowest qualitee"
	icon = 'barony/icons/turf/barony_turfs.dmi'
	icon_state = "woodwallshit"
	smooth = FALSE //coming soon when I can be assed ~Kmc

/turf/closed/wall/barony/stone
	name = "Cobblestone wall"
	desc = "It looks very strong"
	icon = 'barony/icons/turf/barony_turfs.dmi'
	icon_state = "stonewall"
	smooth = FALSE

/turf/open/floor/barony
	name = "rickety floor"
	desc = "Creak"
	icon = 'barony/icons/turf/barony_turfs.dmi'
	icon_state = "woodfloorshit"

/turf/open/floor/barony/cobble
	name = "cobblestone floor"
	desc = "Thees floor be of very high qualitee stoon"
	icon = 'barony/icons/turf/barony_turfs.dmi'
	icon_state = "stonefloor"

/turf/open/floor/barony/cobble/mossy
	name = "mossy cobblestone floor"
	desc = "Thees floor be of very high qualitee stoon, yet still dirtee"
	icon = 'barony/icons/turf/barony_turfs.dmi'
	icon_state = "stonefloor_mossy"

/obj/structure/window/fulltile/barony
	name = "Woodeyn Port-hool"
	desc = "We can't afforde glass"
	icon = 'barony/icons/turf/barony_turfs.dmi'
	icon_state = "wooden_window"
	smooth = FALSE

/obj/structure/window/fulltile/barony/stone
	name = "Stoon Port-hool"
	desc = "We can't afforde glass"
	icon = 'barony/icons/turf/barony_turfs.dmi'
	icon_state = "stone_window"
	max_integrity = 250 //Tough
