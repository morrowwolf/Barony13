/area/barony
	ambientsounds = null
	music = null

/area/barony/outside
	name = "Barony Outside"
	icon_state = "barony_outside"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	atmos = FALSE
	has_gravity = TRUE
	
/area/barony/inside
	name = "Barony Inside"
	icon_state = "barony_inside"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	atmos = FALSE
	has_gravity = TRUE

/area/barony/armory
	name = "Barony Armory"
	icon_state = "barony_armory" // I hope you're happy I didn't spell it as "armoury," Morrow
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	atmos = FALSE
	has_gravity = TRUE

/area/barony/edge
	name = "Barony Edge"
	icon_state = "barony_edge"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	atmos = FALSE
	has_gravity = TRUE
	
/obj/effect/light_emitter/sun_light // A light emitter to run across the border of any inside space, so that light from the outside glows into the inside of the building when there's a hole or open door
	set_luminosity = 4
	set_cap = 1