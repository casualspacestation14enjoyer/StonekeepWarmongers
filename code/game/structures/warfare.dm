// TDM

/obj/structure/bloodstatue // new LAST STAND
	name = "Sanctified Statue"
	desc = "A derelict of a former age. It demands blood."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "psy" //ironic...
	pixel_x = -32
	resistance_flags = INDESTRUCTIBLE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	var/stalemate_kills = 98
	var/win_kills = 50

/obj/structure/bloodstatue/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/bloodstatue/proc/beginround()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		to_chat(world, "<span class='danger'>Secure [win_kills] kills for your team to win!</span>")
		if(aspect_chosen(/datum/round_aspect/halo))
			SEND_SOUND(world, 'sound/vo/halo/exterminatus.mp3')
		else
			SEND_SOUND(world, 'sound/misc/alert.ogg')

/obj/structure/bloodstatue/process()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode
		if(SSticker.grenzelhoft_deaths >= win_kills)
			C.do_war_end(null, RED_WARTEAM)
			STOP_PROCESSING(SSprocessing, src)
		if(SSticker.heartfelt_deaths >= win_kills)
			C.do_war_end(null, BLUE_WARTEAM)
			STOP_PROCESSING(SSprocessing, src)
		if(SSticker.deaths >= stalemate_kills)
			C.do_war_end()
			STOP_PROCESSING(SSprocessing, src)

/*
/obj/structure/laststandstatue // relic of old LAST STAND
	name = "Sanctified Statue"
	desc = "A massive, holy statue. Heartfeltians feel compelled to protect it, and Grenzelhoftians to destroy it."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "psy" //ironic...
	max_integrity = 800
	pixel_x = -32
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	var/active = FALSE
	var/progress_in_seconds = 0
	var/purpose_fulfilled = FALSE
	var/last_scream = 0
	var/ascend_time = 10 MINUTES
	var/half_way = FALSE

/obj/structure/laststandstatue/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/laststandstatue/proc/begincountdown()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode
		C.warmode = GAMEMODE_STAND
		active = TRUE
		for(var/X in C.heartfelts)
			var/mob/living/carbon/human/H = X
			to_chat(H, "<span class='danger'>Protect the [src] at any cost!</span>")
			to_chat(H, "You must protect the [src] for [ascend_time] seconds.")
			SEND_SOUND(H, 'sound/misc/alert.ogg')
		for(var/X in C.grenzels)
			var/mob/living/carbon/human/H = X
			to_chat(H, "<span class='danger'>Destroy the [src] at any cost!</span>")
			to_chat(H, "You have [ascend_time] seconds to destroy the [src].")
			SEND_SOUND(H, 'sound/misc/notice.ogg')

/obj/structure/laststandstatue/process()
	if(active == FALSE)
		return
	for(var/turf/closed/wall/W in RANGE_TURFS(2, src)) //no cheating by just boxing in the statue, that is super lame.
		W.dismantle_wall()
	progress_in_seconds += 1
	if(progress_in_seconds > ascend_time/2 && half_way == FALSE)
		to_chat(world, "<span class='danger'>The [src] is halfway to ascension!</span>")
		half_way = TRUE
		for(var/mob/M in GLOB.player_list)
			SEND_SOUND(M, 'sound/misc/alert.ogg')
	if(progress_in_seconds > ascend_time && purpose_fulfilled == FALSE)
		to_chat(world, "<span class='danger'>The [src] has ascended!</span>")
		if(istype(SSticker.mode, /datum/game_mode/warfare))
			var/datum/game_mode/warfare/C = SSticker.mode
			purpose_fulfilled = TRUE
			C.do_war_end(team=RED_WARTEAM)

/obj/structure/laststandstatue/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(!purpose_fulfilled)
		to_chat(world, "<span class='danger'>The [src] was destroyed!</span>")
		if(istype(SSticker.mode, /datum/game_mode/warfare))
			var/datum/game_mode/warfare/C = SSticker.mode
			C.do_war_end(team=BLUE_WARTEAM)
	. = ..()

/obj/structure/laststandstatue/examine(mob/user)
	..()
	if(!active)
		to_chat(user,"The [src] is not ready yet.")
	else
		to_chat(user, "<b>The [src] must be protected for another [(ascend_time - progress_in_seconds)] seconds.</b>!")
		to_chat(user, "<b>The [src] has [obj_integrity] health</b>!")

/obj/structure/laststandstatue/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = TRUE, attack_dir, armour_penetration = 0)
	. = ..()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode
		if(last_scream < world.time)
			for(var/X in C.heartfelts)
				var/mob/living/carbon/human/H = X
				SEND_SOUND(H, 'sound/misc/astratascream.ogg')
				to_chat(H, "<span class='danger'>The [src] is taking damage!</span>")
			last_scream = world.time + 600
*/

// CTF

/obj/structure/ponr
	name = "Grenzelhofts Point of No Return"
	desc = "You feel like this was shamelessly stolen from some sort of different place. Oh well, DON'T LET THE HEARTFELTS TOUCH THIS! But if you're a Heartfelt... Eh, sure. Why not."
	icon = 'icons/shamelessly_stolen.dmi'
	icon_state = "destruct"
	max_integrity = 999999
	anchored = TRUE
	climbable = FALSE
	density = TRUE
	opacity = FALSE
	var/team = BLUE_WARTEAM

/obj/structure/ponr/proc/beginround()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		to_chat(world, "<span class='danger'>Capture the enemy flag and take it to your PONR!</span>")
		if(aspect_chosen(/datum/round_aspect/halo))
			SEND_SOUND(world, 'sound/vo/halo/ctf.mp3')
		else
			SEND_SOUND(world, 'sound/misc/alert.ogg')

/obj/structure/ponr/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/ponr/process()
	for(var/turf/closed/wall/W in RANGE_TURFS(2, src)) //no cheating by just boxing in the statue, that is super lame.
		W.dismantle_wall()

/obj/structure/ponr/attack_hand(mob/user)
	. = ..()
	var/mob/living/carbon/human/H
	var/datum/game_mode/warfare/C = SSticker.mode
	if(ishuman(user))
		H = user
	if(H.warfare_faction == team)
		if(C.crownbearer == H && SSticker.current_state != GAME_STATE_FINISHED)
			C.do_war_end(H, team)
			if(aspect_chosen(/datum/round_aspect/halo))
				SEND_SOUND(world, 'sound/vo/halo/flag_cap.mp3')
		else if(C.crownbearer != H)
			to_chat(H, "<span class='info'>Someone else is carrying the flag.</span>")
			return
		else
			to_chat(H, "<span class='info'>This belongs to us.</span>")
		return
	if(C.crownbearer == H)
		return

	C.crownbearer = H
	to_chat(world, "<span class='userdanger'>[uppertext(team)] FLAG TAKEN.</span>")
	if(aspect_chosen(/datum/round_aspect/halo))
		SEND_SOUND(world, 'sound/vo/halo/flag_take.mp3')

/obj/structure/ponr/red
	name = "Heartfelts Point of No Return"
	desc = "You feel like this was shamelessly stolen from some sort of different place. Oh well, DON'T LET THE GRENZELHOFTS TOUCH THIS! But if you're a Grenzelhoft... Eh, sure. Why not."
	team = RED_WARTEAM

// LD

/obj/structure/warthrone
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

/obj/structure/warthrone/proc/beginround()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		to_chat(world, "<span class='danger'>Take the enemy Lord's crown and sit on the Throne of Heartfelt!</span>")
		if(aspect_chosen(/datum/round_aspect/halo))
			SEND_SOUND(world, 'sound/vo/halo/hail2theking.mp3')
		else
			SEND_SOUND(world, 'sound/misc/alert.ogg')

/obj/structure/warthrone/post_buckle_mob(mob/living/M)
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

/obj/structure/warthrone/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
	M.reset_offsets("bed_buckle")

/obj/structure/warthrone/Initialize()
	..()
	lordcolor(CLOTHING_RED,CLOTHING_YELLOW)

/obj/structure/warthrone/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/structure/warthrone/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "throne_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "throne_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)
	GLOB.lordcolor -= src