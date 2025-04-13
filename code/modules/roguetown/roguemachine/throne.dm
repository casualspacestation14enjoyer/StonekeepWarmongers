/obj/structure/roguethrone
	name = "throne of rockhill"
	desc = "A big throne, to hold the Lord's giant personality. Say 'help' with the crown on your head if you are confused."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "throne"
	density = FALSE
	can_buckle = 1
	pixel_x = -32
	max_integrity = 999999
	buckle_lying = FALSE

/obj/structure/roguethrone/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)

/obj/structure/roguethrone/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
	M.reset_offsets("bed_buckle")

/obj/structure/roguethrone/Initialize()
	..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/structure/roguethrone/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/structure/roguethrone/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "throne_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "throne_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)
	GLOB.lordcolor -= src

// WARFARE THRONE

/obj/structure/throne
	name = "throne of Heartfelt"
	desc = "Do not let the enemy sit on this with your crown."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "throne"
	density = FALSE
	can_buckle = 1
	pixel_x = -32
	max_integrity = 999999
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	buckle_lying = FALSE

/obj/structure/throne/proc/beginround()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		to_chat(world, "<span class='danger'>Take the enemy Lord's crown and sit on the Throne of Heartfelt!</span>")
		if(aspect_chosen(/datum/round_aspect/halo))
			SEND_SOUND(world, 'sound/vo/halo/hail2theking.mp3')
		else
			SEND_SOUND(world, 'sound/misc/alert.ogg')

/obj/structure/throne/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode
		if(C.crownbearer == H)
			return // Gets rid of people farming triumphs
		switch(H.warfare_faction)
			if(RED_WARTEAM)
				if(istype(H.head, /obj/item/clothing/head/roguetown/crownblu))
					C.do_war_end(H, RED_WARTEAM)
			if(BLUE_WARTEAM)
				if(istype(H.head, /obj/item/clothing/head/roguetown/crownred))
					C.do_war_end(H, BLUE_WARTEAM)

/obj/structure/throne/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
	M.reset_offsets("bed_buckle")

/obj/structure/throne/Initialize()
	..()
	lordcolor(CLOTHING_RED,CLOTHING_YELLOW)

/obj/structure/throne/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/structure/throne/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "throne_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "throne_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)
	GLOB.lordcolor -= src