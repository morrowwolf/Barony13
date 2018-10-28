/*
DOHICKEYS
The medieval analogy to obj/machinery

*/

/obj/dohickey // If you come up with a better name for this, Morrow, please do change it.
	name = "dohickey"
	icon = 'icons/obj/stationobjs.dmi'
	desc = "It looks like a thing that does a thing for a thing. Presumably."
	verb_say = "creaks"
	verb_yell = "chatters"
	anchored = TRUE
	
/obj/dohickey/process()
	return PROCESS_KILL
