/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock
	name = "barksteel"
	desc = "Alternative names include 'firebow' for Elven militaries and something along the lines of 'Musker' for Dwarven militias."
	icon = 'icons/roguetown/weapons/64.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "longgun"
	item_state = "musket"
	possible_item_intents = list(INTENT_GENERIC)
	gripped_intents = list(/datum/intent/shoot/musket)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/musk
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	randomspread = 1
	spread = 0
	var/cocked = FALSE
	bigboy = TRUE
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
	dropshrink = 0.7
	associated_skill = /datum/skill/combat/flintlocks

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/bayo
	icon_state = "longgun_b"
	item_state = "longgun_b"
	gripped_intents = list(/datum/intent/shoot/musket, /datum/intent/dagger/cut, /datum/intent/dagger/thrust)

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/dropped(mob/user)
	. = ..()
	if(wielded)
		ungrip(user)
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/attack_right(mob/user)
	. = ..()
	playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
	if(cocked)
		cocked = FALSE
		to_chat(user, "<span class='warning'>I carefully de-cock \the [src].</span>")
	else
		cocked = TRUE
		to_chat(user, "<span class='info'>I cock \the [src].</span>")

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol
	name = "barkiron"
	desc = "A type of barksteel made with cheaper materials, usually used by civilian militias or supplied to policing forces. It is rarely used by infrantrymen, but officer's regard it as more noble than a barksteel."
	icon = 'icons/roguetown/weapons/32.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "pistol"
	item_state = "gun"
	bigboy = FALSE
	recoil = 8
	randomspread = 2
	spread = 3
	possible_item_intents = list(/datum/intent/shoot/musket, INTENT_GENERIC)
	gripped_intents = null
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol/attack_self(mob/living/user)
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol/update_icon()
	return

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
	if(!cocked)
		return
	playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
	cocked = FALSE

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
	if(!cocked)
		return
	playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
	cocked = FALSE
	sleep(3)
	..()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/shoot_live_shot(mob/living/user, pointblank, mob/pbtarget, message)
	..()
	new /obj/effect/particle_effect/smoke(get_turf(user))
	SSticker.musketsshot++

/obj/item/ammo_box/magazine/internal/shot/musk
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	caliber = "musketball"
	max_ammo = 1
	start_empty = TRUE