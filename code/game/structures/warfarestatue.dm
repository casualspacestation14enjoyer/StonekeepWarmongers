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
		var/datum/game_mode/warfare/C = SSticker.mode
		C.warmode = GAMEMODE_STAND
		to_chat(world, "<span class='danger'>Secure [win_kills] kills for your team to win!</span>")
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