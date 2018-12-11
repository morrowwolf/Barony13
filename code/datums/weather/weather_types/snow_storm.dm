/datum/weather/snow_storm
	name = "snow storm"
	desc = "Harsh snowstorms roam the topside of this arctic planet, burying any area unfortunate enough to be in its path."
	probability = 90

	telegraph_message = "<span class='warning'>Drifting particles of snow begin to dust the surrounding area..</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_snow"

	weather_message = "<span class='userdanger'><i>Harsh winds pick up as dense snow begins to fall from the sky! Seek shelter!</i></span>"
	weather_overlay = "snow_storm"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_opacity = TRUE

	end_duration = 100
	end_message = "<span class='boldannounce'>The snowfall dies down, it should be safe to go outside again.</span>"

	area_type = /area/barony/outside
	target_trait = ZTRAIT_STATION

	immunity_type = "snow"

	barometer_predictable = TRUE

	var/list/things_to_melt = list()


/datum/weather/snow_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(15,30))

/datum/weather/snow_storm/start()
	..()

	for(var/i in impacted_areas)
		var/list/area_turfs = get_area_turfs(i)
		CHECK_TICK
		for(var/turf/open/O in area_turfs)
			var/temp_turf_before = O.type
			O.ChangeTurf(/turf/open/floor/grass/snow)
			var/turf/open/floor/grass/snow/S = O
			S.turf_before_weather = temp_turf_before
			CHECK_TICK


/datum/weather/snow_storm/wind_down()
	..()

	for(var/i in impacted_areas)
		var/list/area_turfs = get_area_turfs(i)
		CHECK_TICK
		for(var/X in area_turfs) //Hey we can actually be typeless here...
			var/turf/T = X
			for(var/obj/effect/decal/cleanable/C in T.contents)
				qdel(C)
			CHECK_TICK

/datum/weather/snow_storm/end()
	..()

	for(var/i in impacted_areas)
		var/list/area_turfs = get_area_turfs(i)
		CHECK_TICK
		for(var/turf/open/floor/grass/snow/S in area_turfs)
			if(S.turf_before_weather)
				addtimer(CALLBACK(S, /turf/open/floor/grass/snow.proc/switch_back), rand(10, 100))
			CHECK_TICK

	for(var/atom/thing in things_to_melt)
		things_to_melt -= thing
		QDEL_IN(thing, (rand(300, 900)))
		CHECK_TICK
