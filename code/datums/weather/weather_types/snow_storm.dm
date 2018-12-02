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


/datum/weather/snow_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(15,30))

/datum/weather/snow_storm/start()
	..()

	/*
	for(var/i in impacted_areas)
		var/turf/T = i
		if(istype(T, /turf/open))
			var/temp_turf_before = T.type
			var/turf/open/floor/grass/snow/S = T.ChangeTurf(/turf/open/floor/grass/snow)
			S.turf_before_weather = temp_turf_before
			continue
	*/

/datum/weather/snow_storm/wind_down()
	..()

	for(var/i in impacted_areas)
		var/turf/T = i
		for(var/C in T.contents)
			if(istype(C, /obj/effect/decal/cleanable))
				qdel(C)


/datum/weather/snow_storm/end()
	..()

	/*
	for(var/i in impacted_areas)
		var/turf/T = i
		if(istype(T, /turf/open/floor/grass/snow))
			var/turf/open/floor/grass/snow/S = T
			if(S.turf_before_weather)
				addtimer(CALLBACK(S, /turf/open/floor/grass/snow.proc/switch_back), rand(10, 100))
	*/