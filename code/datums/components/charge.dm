/datum/component/charge

/datum/component/charge/Initialize()
	if(!istype(parent, /obj/item/))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, list(COMSIG_ITEM_PRE_ATTACK), .proc/pre_attack)
	RegisterSignal(parent, list(COMSIG_ITEM_AFTERATTACK), .proc/afterattack)
	
/datum/component/charge/proc/pre_attack(atom/A, mob/living/user, params)
	if(isturf(A))
		if(user.double_click_cooldown && user.double_click_cooldown >= world.time)
			user.charge(A, src)
			user.double_click_cooldown = null
		else
			user.double_click_cooldown = world.time + 2
		return COMPONENT_NO_ATTACK

/datum/component/charge/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag)
		return
	if(user.double_click_cooldown && user.double_click_cooldown >= world.time)
		user.charge(target, src)
		user.double_click_cooldown = null
	else
		user.double_click_cooldown = world.time + 2