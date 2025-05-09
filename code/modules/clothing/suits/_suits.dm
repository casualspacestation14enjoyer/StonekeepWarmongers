/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	allowed = list(/obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	drop_sound = 'sound/blank.ogg'
	pickup_sound =  'sound/blank.ogg'
	slot_flags = ITEM_SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	var/togglename = null
	var/obj/item/clothing/accessory/attached_accessory
	var/mutable_appearance/accessory_overlay
	bloody_icon_state = "bodyblood"


/obj/item/clothing/suit/worn_overlays(isinhands = FALSE)
	. = list()
	if(!isinhands)
//		if(damaged_clothes)
//			. += mutable_appearance('icons/effects/item_damage.dmi', "damaged[blood_overlay_type]")
//		if(HAS_BLOOD_DNA(src))
//			. += mutable_appearance('icons/effects/blood.dmi', "[blood_overlay_type]blood")
		var/mob/living/carbon/human/M = loc
		if(ishuman(M) && M.wear_pants)
			var/obj/item/clothing/under/U = M.wear_pants
			if(istype(U) && U.attached_accessory)
				var/obj/item/clothing/accessory/A = U.attached_accessory
				if(A.above_suit)
					. += U.accessory_overlay

/obj/item/clothing/suit/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
//		M.update_inv_wear_suit()
		M.update_inv_shirt()
		M.update_inv_armor()