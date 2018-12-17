/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = 'ICON FILENAME' 			(defaults to 'icons/turf/areas.dmi')
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = FALSE 				(defaults to true)
	music = null					(defaults to nothing, look in sound/ambience for music)

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/


/*-----------------------------------------------------------------------------*/

/area/ai_monitored	//stub defined ai_monitored.dm

/area/ai_monitored/turret_protected

/area/arrival
	requires_power = FALSE

/area/arrival/start
	name = "Arrival Area"
	icon_state = "start"

/area/admin
	name = "Admin room"
	icon_state = "start"

/area/space
	icon_state = "space"
	requires_power = TRUE
	always_unpowered = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	valid_territory = FALSE
	outdoors = TRUE
	ambientsounds = SPACE
	blob_allowed = FALSE //Eating up space doesn't count for victory as a blob.

/area/space/nearstation
	icon_state = "space_near"
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT

/area/start
	name = "start area"
	icon_state = "start"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	has_gravity = STANDARD_GRAVITY


//EXTRA

/area/asteroid
	name = "Asteroid"
	icon_state = "asteroid"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	blob_allowed = FALSE //Nope, no winning on the asteroid as a blob. Gotta eat the station.
	valid_territory = FALSE
	ambientsounds = MINING

/area/asteroid/nearstation
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	ambientsounds = RUINS
	always_unpowered = FALSE
	requires_power = TRUE
	blob_allowed = TRUE

/area/asteroid/nearstation/bomb_site
	name = "Bomb Testing Asteroid"

/area/asteroid/cave
	name = "Asteroid - Underground"
	icon_state = "cave"
	requires_power = FALSE
	outdoors = TRUE

/area/asteroid/cave/space
	name = "Asteroid - Space"

/area/asteroid/artifactroom
	name = "Asteroid - Artifact"
	icon_state = "cave"
	ambientsounds = RUINS

/area/asteroid/artifactroom/Initialize()
	. = ..()
	set_dynamic_lighting()

//Command

/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = "signal"

//Crew

/area/crew_quarters/dorms
	name = "Dormitories"
	icon_state = "Sleep"
	safe = TRUE

/area/crew_quarters/dorms/male
	name = "Male Dorm"
	icon_state = "Sleep"

/area/crew_quarters/dorms/female
	name = "Female Dorm"
	icon_state = "Sleep"

/area/crew_quarters/lounge
	name = "Lounge"
	icon_state = "yellow"

/area/crew_quarters/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/crew_quarters/kitchen/backroom
	name = "Kitchen Coldroom"
	icon_state = "kitchen"

/area/crew_quarters/bar
	name = "Bar"
	icon_state = "bar"

/area/crew_quarters/bar/atrium
	name = "Atrium"
	icon_state = "bar"

/area/crew_quarters/abandoned_gambling_den
	name = "Abandoned Gambling Den"
	icon_state = "abandoned_g_den"

/area/crew_quarters/abandoned_gambling_den/secondary
	icon_state = "abandoned_g_den_2"

/area/crew_quarters/theatre
	name = "Theatre"
	icon_state = "Theatre"

/area/crew_quarters/theatre/abandoned
	name = "Abandoned Theatre"
	icon_state = "Theatre"

/area/library
 	name = "Library"
 	icon_state = "library"
 	flags_1 = NONE

/area/library/lounge
 	name = "Library Lounge"
 	icon_state = "library"

/area/library/abandoned
 	name = "Abandoned Library"
 	icon_state = "library"
 	flags_1 = NONE

/area/chapel
	icon_state = "chapel"
	ambientsounds = HOLY
	flags_1 = NONE
	clockwork_warp_allowed = FALSE
	clockwork_warp_fail = "The consecration here prevents you from warping in."

/area/chapel/main
	name = "Chapel"

/area/chapel/main/monastery
	name = "Monastery"

/area/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"

/area/chapel/asteroid
	name = "Chapel Asteroid"
	icon_state = "explored"

/area/gateway
	name = "Gateway"
	icon_state = "gateway"
	music = "signal"
	ambientsounds = ENGINEERING

//MedBay

/area/medical
	name = "Medical"
	icon_state = "medbay3"
	ambientsounds = MEDICAL

/area/medical/abandoned
	name = "Abandoned Medbay"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay/central
	name = "Medbay Central"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay/front_office
	name = "Medbay Front Office"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay/lobby
	name = "Medbay Lobby"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

//Medbay is a large area, these additional areas help level out APC load.

/area/medical/medbay/zone2
	name = "Medbay"
	icon_state = "medbay2"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay/zone3
	name = "Medbay"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay/aft
	name = "Medbay Aft"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/storage
	name = "Medbay Storage"
	icon_state = "medbay2"
	music = 'sound/ambience/signal.ogg'

/area/medical/patients_rooms
	name = "Patients' Rooms"
	icon_state = "patients"

/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"
	ambientsounds = SPOOKY

/area/medical/chemistry
	name = "Chemistry"
	icon_state = "chem"

/area/medical/surgery
	name = "Surgery"
	icon_state = "surgery"

/area/medical/exam_room
	name = "Exam Room"
	icon_state = "exam_room"

//Security

/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/security/courtroom
	name = "Courtroom"
	icon_state = "courtroom"

/area/security/prison
	name = "Prison Wing"
	icon_state = "sec_prison"

/area/security/armory
	name = "Armory"
	icon_state = "armory"

/area/security/vacantoffice
	name = "Vacant Office"
	icon_state = "security"

/area/security/vacantoffice/a
	name = "Vacant Office A"
	icon_state = "security"

/area/security/vacantoffice/b
	name = "Vacant Office B"
	icon_state = "security"

/area/quartermaster
	name = "Quartermasters"
	icon_state = "quart"

/area/janitor
	name = "Custodial Closet"
	icon_state = "janitor"
	flags_1 = NONE

/area/hydroponics/garden
	name = "Garden"
	icon_state = "garden"

/area/hydroponics/garden/abandoned
	name = "Abandoned Garden"
	icon_state = "abandoned_garden"

/area/hydroponics/garden/monastery
	name = "Monastery Garden"
	icon_state = "hydro"
	
//Science

/area/science/research/abandoned
	name = "Abandoned Research Lab"
	icon_state = "medresearch"

//Storage

/area/storage/auxiliary
	name = "Auxiliary Storage"
	icon_state = "auxstorage"

/area/storage/testroom
	requires_power = FALSE
	name = "Test Room"
	icon_state = "storage"
