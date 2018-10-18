//This file is here to add a special snowflake version of the plant soil
//That is simplified, for use in Morrow's medieval lavaland ruin
//Some bits of the hydro code are chopped off and overwritten for this.
//If something breaks, consult the process() and addChemical() procs in the original file,
//and spot the differences.

/obj/machinery/hydroponics/soil/medieval
	desc = "Be a part of soil!" // https://www.youtube.com/watch?v=Eg6NIxS7jpM

/obj/machinery/hydroponics/soil/medieval/applyChemicals(datum/reagents/S, mob/user)
	//Alright, Morrow wants this shit to be super simple, so it's super simple.
	//This overrides a LOT of chemical reactions goin' on with hydroponics,
	//and replaces it with some stupid shit
	// It is water!
	if(S.has_reagent("water", 1))
		adjustWater(round(S.get_reagent_amount("water") * 1))
	if(S.has_reagent("holywater", 1))
		adjustWater(round(S.get_reagent_amount("holywater") * 1))
		adjustHealth(round(S.get_reagent_amount("holywater") * 0.1))

/obj/machinery/hydroponics/soil/medieval/process()
	//Continuing to be super simple, as per Morrow's wants
	//So, as of the initial creation of this proc, there's only
	//A: A need to water your shit
	//B: Aging
	var/needs_update = FALSE // Checks if the icon needs updating so we don't redraw empty trays every time
	if(myseed && (myseed.loc != src))
		myseed.forceMove(src)

	if(world.time > (lastcycle + cycledelay)) // If we need to do a plant cycle
	//Then do a plant cycle
		lastcycle = world.time
		if(myseed && !dead)
			// Advance age
			age++
			if(age < myseed.maturation)
				lastproduce = age
			needs_update = TRUE
			// Plant dies if plant_health <= 0
			if(plant_health <= 0)
				plantdies()
//Water//////////////////////////////////////////////////////////////////
			// Drink random amount of water
			adjustWater(-rand(1,6) / rating)

			// If the plant is dry, it loses health pretty fast, unless mushroom
			//(Slightly edited post medievaling to reduce the number of branches)
			if(!myseed.get_gene(/datum/plant_gene/trait/plant_type/fungal_metabolism))
				if(waterlevel <= 0)
					adjustHealth(-rand(0,3) / rating)
				else if(waterlevel <= 10)
					adjustHealth(-rand(0,1) / rating)
				// Sufficient water level and nutrient level = plant healthy but also spawns weeds
				//Except it doesn't (as of the creation of this special snowflake soil, YMMV)
				else
					adjustHealth(rand(1,2) / rating)

			// If the plant is too old, lose health fast
			if(age > myseed.lifespan)
				adjustHealth(-rand(1,5) / rating)

			// Harvest code
			if(age > myseed.production && (age - lastproduce) > myseed.production && (!harvest && !dead))
				nutrimentMutation()
				if(myseed && myseed.yield != -1) // Unharvestable shouldn't be harvested
					harvest = 1
				else
					lastproduce = age
		if(needs_update)
			update_icon()
	return
