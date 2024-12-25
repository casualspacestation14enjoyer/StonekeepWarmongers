/mob/living/carbon/human/gib_animation()
	new /obj/effect/temp_visual/gib_animation(loc, "gibbed-h")

/mob/living/carbon/human/dust_animation()
	new /obj/effect/temp_visual/dust_animation(loc, "dust-h")

/mob/living/carbon/human/spawn_gibs(with_bodyparts)
	if(with_bodyparts)
		new /obj/effect/gibspawner/human(drop_location(), src, get_static_viruses())
	else
		new /obj/effect/gibspawner/human/bodypartless(drop_location(), src, get_static_viruses())

/mob/living/carbon/human/spawn_dust(just_ash = FALSE)
	if(just_ash)
		for(var/i in 1 to 5)
			new /obj/item/ash(loc)
	else
		new /obj/effect/decal/remains/human(loc)

/proc/rogueviewers(range, object)
	. = list(viewers(range, object))
	if(isliving(object))
		var/mob/living/LI = object
		for(var/mob/living/L in .)
			if(!L.can_see_cone(LI))
				. -= L
			if(HAS_TRAIT(L, TRAIT_BLIND))
				. -= L

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)
		return

	if(mind)
		SSticker.deaths++
		switch(warfare_faction)
			if(RED_WARTEAM)
				SSticker.heartfelt_deaths++
			if(BLUE_WARTEAM)
				SSticker.grenzelhoft_deaths++

	/* No zombies in PvP.
	if(!gibbed)
		if(!is_in_roguetown(src))
			zombie_check()
	*/

	if(HAS_TRAIT(src, TRAIT_JESTER))
		playsound(src, 'sound/foley/honk.ogg', 75, FALSE, -3)

	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode

		if(istype(SSjob.GetJob(job),/datum/job/roguetown/warfare/red/lord))
			testing("Red lord is dead!")
			for(var/client/X in C.heartfelts)
				var/mob/living/carbon/human/V = X.mob
				to_chat(V, "<span class='red>OUR LORD IS DEAD! WE ARE DOOMED! DOOMED!</span>")
				V.playsound_local(get_turf(V), 'sound/music/fallenangel.ogg', 80, FALSE, pressure_affected = FALSE)
				V.add_stress(/datum/stressevent/deadlord)
		if(istype(SSjob.GetJob(job),/datum/job/roguetown/warfare/blu/lord))
			testing("Blue lord is dead!")
			for(var/client/X in C.grenzels)
				var/mob/living/carbon/human/V = X.mob
				to_chat(V, "<span class='red>OUR LORD IS DEAD! WE ARE DOOMED! DOOMED!</span>")
				V.playsound_local(get_turf(V), 'sound/music/fallenangel.ogg', 80, FALSE, pressure_affected = FALSE)
				V.add_stress(/datum/stressevent/deadlord)

	stop_sound_channel(CHANNEL_HEARTBEAT)
	var/obj/item/organ/heart/HE = getorganslot(ORGAN_SLOT_HEART)
	if(HE)
		HE.beat = BEAT_NONE

	if(!gibbed)
		for(var/mob/living/carbon/human/HU in viewers(7, src))
			if(HU != src && !HAS_TRAIT(HU, TRAIT_BLIND))
				if(!HAS_TRAIT(HU, TRAIT_VILLAIN))
					if(HU.dna?.species && dna?.species)
						if(HU.dna.species.id == dna.species.id)
							HU.add_stress(/datum/stressevent/viewdeath)

	var/mob/dead/observer/rogue/G = ghostize()

	if(G?.client)
		SSdroning.kill_droning(G.client)
		SSdroning.kill_loop(G.client)
		SSdroning.kill_rain(G.client)
		G.playsound_local(src, 'sound/misc/deth.ogg', 100)

		var/atom/movable/screen/gameover/hog/H = new()
		var/list/iconstato = list(
			"hog"=90,
			"mortis"=50,
			"ashbaby"=1 // warmongers is a serious game about the horrors of war
		)
		var/chosen = pickweight(iconstato)
		H.icon_state = chosen
		H.layer = SPLASHSCREEN_LAYER+0.5
		G.client.screen += H
		H.Fade()
		to_chat(G, "<span class='notice'>You've died! Don't worry, this happens all the time. Press the button that looks like a skull on the left side of your screen to respawn.</span>")
		mob_timers["lastdied"] = world.time
		addtimer(CALLBACK(H, TYPE_PROC_REF(/atom/movable/screen/gameover, Fade), TRUE), 30)
		G.add_client_colour(/datum/client_colour/monochrome)

	. = ..()

	dizziness = 0
	jitteriness = 0

	if(ismecha(loc))
		var/obj/mecha/M = loc
		if(M.occupant == src)
			M.go_out()

	dna.species.spec_death(gibbed, src)
	
	if(aspect_chosen(/datum/round_aspect/exploding))
		gib(TRUE)

	if(SSticker.HasRoundStarted())
		SSblackbox.ReportDeath(src)
		log_message("has died (BRUTE: [src.getBruteLoss()], BURN: [src.getFireLoss()], TOX: [src.getToxLoss()], OXY: [src.getOxyLoss()], CLONE: [src.getCloneLoss()])", LOG_ATTACK)
	if(is_devil(src))
		INVOKE_ASYNC(is_devil(src), TYPE_PROC_REF(/datum/antagonist/devil, beginResurrectionCheck), src)

/mob/living/carbon/human/proc/zombie_check()
	if(!mind)
		return
	if(mind.has_antag_datum(/datum/antagonist/vampirelord))
		return
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return
	if(mind.has_antag_datum(/datum/antagonist/zombie))
		return
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return
	if(HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE))
		return
	return mind.add_antag_datum(/datum/antagonist/zombie)

/mob/living/carbon/human/gib(no_brain, no_organs, no_bodyparts, safe_gib = FALSE)
	for(var/mob/living/carbon/human/CA in viewers(7, src))
		if(CA != src && !HAS_TRAIT(CA, TRAIT_BLIND))
			if(HAS_TRAIT(CA, TRAIT_STEELHEARTED))
				continue
			if(CA.marriedto == src)
				CA.adjust_triumphs(-1)
			var/mob/living/carbon/V = CA
			if(V.has_flaw(/datum/charflaw/addiction/maniac))
				V.add_stress(/datum/stressevent/viewgibmaniac)
				V.sate_addiction()
				continue
			V.add_stress(/datum/stressevent/viewgib)
	. = ..()

/mob/living/carbon/human/proc/makeSkeleton()
	ADD_TRAIT(src, TRAIT_DISFIGURED, TRAIT_GENERIC)
	set_species(/datum/species/skeleton)
	return TRUE

/mob/living/carbon/proc/Drain()
	become_husk(CHANGELING_DRAIN)
	ADD_TRAIT(src, TRAIT_BADDNA, CHANGELING_DRAIN)
	blood_volume = 0
	return TRUE

/mob/living/carbon/proc/makeUncloneable()
	ADD_TRAIT(src, TRAIT_BADDNA, MADE_UNCLONEABLE)
	blood_volume = 0
	return TRUE
