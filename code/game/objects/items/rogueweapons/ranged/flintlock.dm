/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock
	name = "barksteel"
	desc = "A firearm without a bayonet, typically used by marksmen."
	icon = 'icons/roguetown/weapons/64.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "longgun"
	item_state = "musket"
	experimental_inhand = FALSE
	experimental_onback = FALSE
	possible_item_intents = list(INTENT_GENERIC)
	gripped_intents = list(/datum/intent/shoot/musket/rifle, /datum/intent/shoot/musket/arc,)
	wieldsound = 'sound/combat/musket_wield.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/shot/musk
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	spread = 5
	max_integrity = 600 // having your gun broken while parrying sucks
	var/cocked = FALSE
	var/rammed = FALSE
	var/click_delay = 2
	var/obj/item/rogue/ramrod/rod
	bigboy = TRUE
	can_parry = TRUE
	pin = /obj/item/firing_pin
	force = 10
	cartridge_wording = "ball"
	recoil = 4
	load_sound = 'sound/foley/nockarrow.ogg'
	fire_sound = list('sound/combat/Ranged/muskshoot.ogg','sound/combat/Ranged/muskshot1.ogg','sound/combat/Ranged/muskshot2.ogg','sound/combat/Ranged/muskshot3.ogg')
	fire_sound_volume = 500
	vary_fire_sound = TRUE
	drop_sound = 'sound/foley/gun_drop.ogg'
	dropshrink = 0.7
	associated_skill = /datum/skill/combat/flintlocks
	var/ramtime = 5.5

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/heart
	icon_state = "barotrauma1"

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/grenz
	icon_state = "ironbarkmarksman"

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/equipped(mob/living/user, slot)
	. = ..()
	playsound(loc, 'sound/foley/gun_equip.ogg', 100, TRUE)

/obj/item/rogue/ramrod
	name = "rod of ramming"
	desc = ""
	drop_sound = 'sound/combat/ramrod_pickup.ogg' // lol
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "ramrod"

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/Initialize()
	. = ..()
	var/obj/item/rogue/ramrod/rrod = new(src)
	rod = rrod

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/attackby(obj/item/A, mob/user, params)
	var/tt = ramtime
	tt = ramtime - (user.mind.get_skill_level(/datum/skill/combat/flintlocks) / 2.5)

	var/mob/living/carbon/human/U
	if(ishuman(user))
		U = user
	
	for(var/atom/T in get_step(src, NORTH))
		if(ishuman(T))
			var/mob/living/carbon/human/H = T
			if(H.warfare_faction == U.warfare_faction)
				ramtime = ramtime - 0.5

	for(var/atom/T in get_step(src, SOUTH))
		if(ishuman(T))
			var/mob/living/carbon/human/H = T
			if(H.warfare_faction == U.warfare_faction)
				ramtime = ramtime - 0.5

	for(var/atom/T in get_step(src, EAST))
		if(ishuman(T))
			var/mob/living/carbon/human/H = T
			if(H.warfare_faction == U.warfare_faction)
				ramtime = ramtime - 0.5

	for(var/atom/T in get_step(src, WEST))
		if(ishuman(T))
			var/mob/living/carbon/human/H = T
			if(H.warfare_faction == U.warfare_faction)
				ramtime = ramtime - 0.5

	if(aspect_chosen(/datum/round_aspect/noreloading))
		ramtime = 0.1

	if(istype(A, /obj/item/rogue/ramrod))
		if(!user.is_holding(src))
			to_chat(user, "<span class='warning'>I need to hold \the [src] to ram it!</span>")
			return
		if(chambered)
			if(!rammed)
				playsound(src.loc, 'sound/combat/ramrod_working.ogg', 100, FALSE, -3)
				if(do_after(user, tt SECONDS, TRUE, src))
					to_chat(user, "<span class='info'>I ram \the [src].</span>")
					rammed = TRUE
	else
		return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/MiddleClick(mob/user, params)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(rod)
			H.put_in_hands(rod)
			rod = null
			to_chat(user, "<span class='info'>I remove the ramrod from \the [src].</span>")
			playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
		else
			if(istype(H.get_active_held_item(), /obj/item/rogue/ramrod))
				var/obj/item/rogue/ramrod/rrod = H.get_active_held_item()
				rrod.forceMove(src)
				rod = rrod
				to_chat(user, "<span class='info'>I put \the [rrod] into \the [src].</span>")
				playsound(src.loc, 'sound/combat/ramrod_pickup.ogg', 100, FALSE, -1)

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/bayo
	icon_state = "barotrauma_b0"
	desc = "A firearm of Fogland design, provided to Heartfelt to fight the Grenzelhofts."
	spread = 0.5
	gripped_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, /datum/intent/dagger/cut, /datum/intent/dagger/thrust)

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/bayo/grenz
	desc = "A weapon that is common in the ranks of the armies of Grenzelhoft, it gets the job done."
	icon_state = "ironbarker"

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/dropped(mob/user)
	. = ..()
	if(wielded)
		ungrip(user)
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/attack_right(mob/user)
	if(!user.is_holding(src))
		to_chat(user, "<span class='warning'>I need to hold \the [src] to cock it!</span>")
		return
	if(cocked)
		cocked = FALSE
		to_chat(user, "<span class='warning'>I carefully de-cock \the [src].</span>")
		playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
	else
		playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
		to_chat(user, "<span class='info'>I cock \the [src].</span>")
		cocked = TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol
	name = "barkiron"
	desc = "A type of barksteel made with cheaper materials, usually used by civilian militias or supplied to policing forces. It is rarely used by infrantrymen, but officer's regard it as more noble than a barksteel."
	icon = 'icons/roguetown/weapons/32.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "pistol"
	item_state = "pistol"
	bigboy = FALSE
	recoil = 8
	spread = 3
	click_delay = 2.4
	possible_item_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, INTENT_GENERIC)
	gripped_intents = null
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	ramtime = 3.4

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol/attack_self(mob/living/user)
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol/update_icon()
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/update_icon()
	//icon_state = "[initial(icon_state)][wielded]"
	item_state = "[initial(item_state)][wielded]"

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
	rammed = FALSE // just in case

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
		if(user.client)
			if(user.client.chargedprog >= 100)
				BB.accuracy += 20 //better accuracy for fully aiming
		BB.bonus_accuracy += (user.mind.get_skill_level(/datum/skill/combat/flintlocks) * 1.5)
	if(!cocked)
		return
	if(!rammed)
		return
	playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
	cocked = FALSE
	rammed = FALSE
	sleep(click_delay)
	..()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/shoot_live_shot(mob/living/user, pointblank, mob/pbtarget, message)
	if(user.mind.get_skill_level(/datum/skill/combat/flintlocks) <= 0)
		to_chat(user, "<span class='danger'>I do not know how to use this.</span>")
		return
	..()
	new /obj/effect/particle_effect/smoke(get_turf(user))
	SSticker.musketsshot++

/obj/item/ammo_box/magazine/internal/shot/musk
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	caliber = "musketball"
	max_ammo = 1
	start_empty = TRUE