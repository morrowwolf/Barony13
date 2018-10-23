//Barony13
/*
This file holds some of the stuff related to the Barony charging mechanic,
allowing humans to charge stupidly at their enemy.
*/
#define CHARGE_RANGE 4 // How far a charge goes, in tiles

/mob/proc/charge(atom/A, var/obj/item/I = null)
	return

/mob/living/carbon/human/charge(atom/A, var/obj/item/I = null)
	
	if(charge_cooldown == null || charge_cooldown <= world.time)
		sleep(-1) // To make abso-fucking-lutely sure that the tick is not going to click over while this proc is running
		//Because if it does, then there's a chance that the distance between the attacker and attackée will change and become zero
		//causing a division-by-zero error in the destination calculations below
		//See: https://github.com/morrowwolf/Barony13/issues/30
		if(get_dist(src,A) > 0) // Separating this from the rest of the checks to absolutely minimize the time this whole bit takes,
		//to reduce chance of said divison-by-zero issue
			charge_cooldown = world.time + 50
			charging = TRUE
			if(get_dist(src,A) < CHARGE_RANGE) // If the charge target is too close
			//Then we need to extend the charge to still be CHARGE_RANGE long, so this fuck will still hit a wall if A steps out of the way
				var/destination_x = (A.x - x) / sqrt((A.y - y)*(A.y - y) + (A.x - x)*(A.x - x)) * CHARGE_RANGE + x
				var/destination_y = (A.y - y) / sqrt((A.y - y)*(A.y - y) + (A.x - x)*(A.x - x)) * CHARGE_RANGE + y
				A = locate(round(destination_x, 1), round(destination_y, 1), z)
			playsound(get_turf(src), 'sound/effects/charge_2.ogg', 150, 1, -1)
			throw_at(A, CHARGE_RANGE, 1, src, FALSE, FALSE, callback = CALLBACK(src, .proc/charge_end) // throw_at() handles the charge target being too far away just fine, btw
	
/mob/living/carbon/human/proc/charge_end()
	charging = FALSE
	
/mob/living/carbon/human/throw_impact(atom/A)
	if(!charging)
		return ..()
	else if(A)
		if(istype(A, /turf/closed/) || istype(A, /obj/structure/) || (istype(A, /obj/machinery/) && A.density))
			playsound(get_turf(src), 'sound/effects/woodhit.ogg', 75, 1, -1)
			src.Knockdown(30)
			changeNext_move(CLICK_CD_CHARGE_HIT_WALL)
			
			src.visible_message("<span class='danger'>[src] has charged straight into [A]!</span>", \
							"<span class='userdanger'>[src] has charged straight into [A]!</span>", null, COMBAT_MESSAGE_RANGE)
			
		else if(istype(A, /mob/living/))
			changeNext_move(CLICK_CD_MELEE)
			if(get_active_held_item())
				hitMobItem(A)
			else
				hitMobNoItem(A)
		else
			changeNext_move(CLICK_CD_CHARGE_MISS)
			
/mob/living/carbon/human/proc/hitMobNoItem(mob/living/L)
	src.do_attack_animation(L, ATTACK_EFFECT_PUNCH)

	var/damage = 3*rand(src.dna.species.punchdamagelow, src.dna.species.punchdamagehigh)

	var/obj/item/bodypart/affecting = L.get_bodypart(ran_zone(src.zone_selected))

	var/armor_block = L.run_armor_check(affecting, "melee")

	playsound(L.loc, src.dna.species.attack_sound, 25, 1, -1)

	L.visible_message("<span class='danger'>[src] has charged [L]!</span>", \
				"<span class='userdanger'>[src] has charged [L]!</span>", null, COMBAT_MESSAGE_RANGE)

	L.apply_damage(damage, BRUTE, affecting, armor_block)
	log_combat(src, L, "charged")
	
	L.lastattacker = src.real_name
	L.lastattackerckey = src.ckey
	
/mob/living/carbon/human/proc/hitMobItem(mob/living/L)
	var/obj/item/I = get_active_held_item()
	
	src.do_attack_animation(L)
	
	var/damage = 3*I.force

	var/obj/item/bodypart/affecting = L.get_bodypart(ran_zone(src.zone_selected))

	var/armor_block = L.run_armor_check(affecting, "melee")
	
	if(I.hitsound)
		playsound(L.loc, I.hitsound, I.get_clamped_volume(), 1, -1)

	L.visible_message("<span class='danger'>[src] has charged [L] with [I]!</span>", \
				"<span class='userdanger'>[src] has charged [L] with [I]!</span>", null, COMBAT_MESSAGE_RANGE)

	L.apply_damage(damage, BRUTE, affecting, armor_block)
	log_combat(src, L, "charged", I.name, "(INTENT: [uppertext(src.a_intent)]) (DAMTYPE: [uppertext(I.damtype)])")
	
	L.lastattacker = src.real_name
	L.lastattackerckey = src.ckey
	I.add_fingerprint(src)
