/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock
	name = "barksteel"
	desc = "Alternative names include 'firebow' for Elven militaries and something along the lines of 'Musker' for Dwarven militias."
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "longgun"
	item_state = "longgun"
	possible_item_intents = list(INTENT_GENERIC)
	gripped_intents = list(/datum/intent/shoot/musket)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/musk
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	randomspread = 1
	spread = 0
	can_parry = TRUE
	pin = /obj/item/firing_pin
	force = 10
	cartridge_wording = "ball"
	recoil = 4
	load_sound = 'sound/foley/nockarrow.ogg'
	fire_sound = 'sound/combat/Ranged/muskshoot.ogg'
	equip_sound = 'sound/foley/gun_equip.ogg'
	pickup_sound = 'sound/foley/gun_equip.ogg'
	drop_sound = 'sound/foley/gun_drop.ogg'
	dropshrink = 0.8
	associated_skill = /datum/skill/combat/flintlocks

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/update_icon()
	icon_state = "[initial(icon_state)][wielded]"

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/attack_self(mob/living/user)
	if(!wielded)
		wield(user)
		update_icon()
	else
		ungrip(user)
		update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/shoot_with_empty_chamber(mob/living/user)
	playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		if(user.STAPER > 10)
			BB.damage = BB.damage * (user.STAPER / 10)
	..()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/shoot_live_shot(mob/living/user, pointblank, mob/pbtarget, message)
	playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
	sleep(3)
	..()
	new /obj/effect/particle_effect/smoke(get_turf(user))
	SSticker.musketsshot++

/obj/item/ammo_box/magazine/internal/shot/musk
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	caliber = "musketball"
	max_ammo = 1
	start_empty = TRUE