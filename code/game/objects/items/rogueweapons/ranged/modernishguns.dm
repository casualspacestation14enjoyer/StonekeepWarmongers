// 'modern' firearms of WARMONGERS, includes a repeater aswell as a revolver
// DONUT STEAL!!1!

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater
	name = "levershot"
	desc = "A type of gun invented by a dwarven engineer to stop wood elves stealing his plants for alcohol brewing off of his garden, the authenticity of this story is being challenged due to the fact that dwarves generally don't live above ground. The part about wood elf murder is true due to the fact the engineer which has chosen to stay anonymous has written many books with the same basis of elves being inferior in every aspect."
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "repeatergun"
	item_state = "musket"
	possible_item_intents = list(INTENT_GENERIC)
	gripped_intents = list(/datum/intent/shoot/musket/peter, /datum/intent/shoot/musket/arc)
	experimental_inhand = FALSE
	experimental_onback = FALSE
	wieldsound = 'sound/combat/musket_wield.ogg'
	dry_fire_sound = 'sound/combat/Ranged/muskclick.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/shot/peter
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	bolt_type = BOLT_TYPE_STANDARD
	semi_auto = FALSE
	casing_ejector = FALSE
	internal_magazine = TRUE
	tac_reloads = FALSE
	max_integrity = 600
	randomspread = 1
	spread = 0
	bigboy = TRUE
	can_parry = TRUE
	pin = /obj/item/firing_pin
	force = 10
	cartridge_wording = "ball"
	recoil = 4
	load_sound = 'sound/foley/nockarrow.ogg'
	fire_sound = list('sound/combat/Ranged/muskshot1.ogg','sound/combat/Ranged/muskshot2.ogg','sound/combat/Ranged/muskshot3.ogg')
	fire_sound_volume = 500
	equip_sound = 'sound/foley/gun_equip.ogg'
	pickup_sound = 'sound/foley/gun_equip.ogg'
	drop_sound = 'sound/foley/gun_drop.ogg'
	dropshrink = 0.7
	associated_skill = /datum/skill/combat/flintlocks
	var/flunked = FALSE

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/empty
	mag_type = /obj/item/ammo_box/magazine/internal/shot/peter/startempty

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/examine(mob/user)
	. = ..()
	if(chambered)
		. += "<span class='info'>It is loaded.</span>"

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/chamber_round(spin_cylinder)
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/proc/reloadact(mob/user)
	if(chambered)
		return
	if(!do_after(user, 0.5 SECONDS, TRUE, src))
		return
	var/obj/item/ammo_casing/caseless/rogue/bullet/B = magazine.get_round(TRUE)
	if(B)
		if(flunked)
			chambered = B
			flunked = FALSE
			to_chat(user, "<span class='info'>I pull the lever back up, chambering \the [src].</span>")
			playsound(user, 'sound/foley/trap_arm.ogg', 75)
		else
			flunked = TRUE
			to_chat(user, "<span class='info'>I pull the lever down, preparing to chamber \the [src].</span>")
			playsound(user, 'sound/foley/trap.ogg', 75)

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/attack_right(mob/user)
	. = ..()
	reloadact(user)

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/rmb_self(mob/user)
	. = ..()
	reloadact(user)

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/dropped(mob/user)
	. = ..()
	if(wielded)
		ungrip(user)
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/update_icon()
	//icon_state = "[initial(icon_state)][wielded]"
	item_state = "[initial(item_state)][wielded]"

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/attack_self(mob/living/user)
	if(!wielded)
		wield(user)
		update_icon()
	else
		ungrip(user)
		update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	..()

/obj/item/gun/ballistic/revolver/grenadelauncher/repeater/shoot_live_shot(mob/living/user, pointblank, mob/pbtarget, message)
	if(user.mind.get_skill_level(/datum/skill/combat/flintlocks) <= 0)
		to_chat(user, "<span class='danger'>I do not know how to use this.</span>")
		return
	..()
	QDEL_NULL(chambered)
	//new /obj/effect/particle_effect/smoke(get_turf(user))
	SSticker.musketsshot++

/obj/item/ammo_box/magazine/internal/shot/peter // petah.. the saiga is here.
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	caliber = "musketball"
	max_ammo = 6
	start_empty = FALSE

/obj/item/ammo_box/magazine/internal/shot/peter/startempty
	start_empty = TRUE

// revolver

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot
	name = "revolleyer"
	desc = "This gun iterates on the hypothetical design of the same dwarven gunsmith that created the levershot. The design, found inside his basement after his suicide (by his own invention, a levershot) was then stolen and passed off as someone elses a week after his death. He was called out by the wife of the dwarven engineer and murdered by said wife. The wife was not jailed under the dwarven lawcode as this exact scenario was covered by the writers of the Ardcnoc League Constitution. It deviates from the previous naming convention as the creator found it to be 'barbaric'."
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon = 'icons/roguetown/weapons/32.dmi'
	icon_state = "shitvolver"
	item_state = "pistol"
	possible_item_intents = list(/datum/intent/shoot/musket/peter, /datum/intent/shoot/musket/arc, INTENT_GENERIC)
	experimental_inhand = FALSE
	experimental_onback = FALSE
	wieldsound = 'sound/combat/musket_wield.ogg'
	dry_fire_sound = 'sound/combat/Ranged/muskclick.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/shot/peter
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	bolt_type = BOLT_TYPE_STANDARD
	semi_auto = FALSE
	casing_ejector = FALSE
	internal_magazine = TRUE
	tac_reloads = FALSE
	max_integrity = 600
	randomspread = 1
	spread = 0
	bigboy = FALSE
	can_parry = TRUE
	pin = /obj/item/firing_pin
	force = 10
	cartridge_wording = "ball"
	recoil = 4
	load_sound = 'sound/foley/nockarrow.ogg'
	fire_sound = list('sound/combat/Ranged/muskshot1.ogg','sound/combat/Ranged/muskshot2.ogg','sound/combat/Ranged/muskshot3.ogg')
	fire_sound_volume = 500
	equip_sound = 'sound/foley/gun_equip.ogg'
	pickup_sound = 'sound/foley/gun_equip.ogg'
	drop_sound = 'sound/foley/gun_drop.ogg'
	associated_skill = /datum/skill/combat/flintlocks

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot/empty
	mag_type = /obj/item/ammo_box/magazine/internal/shot/peter/startempty

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot/examine(mob/user)
	. = ..()
	if(chambered)
		. += "<span class='info'>It is loaded.</span>"

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot/attack_self(mob/living/user)
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot/chamber_round(spin_cylinder)
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot/proc/reloadact(mob/user)
	if(chambered)
		return
	if(!do_after(user, 1.5 SECONDS, TRUE, src))
		return
	var/obj/item/ammo_casing/caseless/rogue/bullet/B = magazine.get_round(TRUE)
	if(B)
		chambered = B
		to_chat(user, "<span class='info'>I pull the clicker down, chambering \the [src].</span>")
		playsound(user, 'sound/combat/Ranged/muskclick.ogg', 100)
		flick("shitvolver_anim", src)
		update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot/attack_right(mob/user)
	. = ..()
	reloadact(user)

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot/rmb_self(mob/user)
	. = ..()
	reloadact(user)

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot/update_icon()
	if(chambered)
		icon_state = "[initial(icon_state)]_cock"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	..()

/obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot/shoot_live_shot(mob/living/user, pointblank, mob/pbtarget, message)
	if(user.mind.get_skill_level(/datum/skill/combat/flintlocks) <= 0)
		to_chat(user, "<span class='danger'>I do not know how to use this.</span>")
		return
	..()
	QDEL_NULL(chambered)
	//new /obj/effect/particle_effect/smoke(get_turf(user))
	SSticker.musketsshot++
	update_icon()