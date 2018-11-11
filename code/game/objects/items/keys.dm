/obj/item/key
	name = "key"
	desc = "A random key.  Doesn't seem to go to anything..."
	icon_state = "key"
	item_state = "key"
	icon = 'icons/obj/keys.dmi'
	slot_flags = ITEM_SLOT_ID
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	w_class = WEIGHT_CLASS_TINY
	var/list/access = list()

/obj/item/key/armory
	name = "armory key"
	desc = "A key that goes to the armory."
	access = list(ACCESS_KEY_ARMORY)