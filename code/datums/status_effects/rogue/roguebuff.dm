/datum/status_effect/buff
	status_type = STATUS_EFFECT_REFRESH


/datum/status_effect/buff/drunk
	id = "drunk"
	alert_type = /atom/movable/screen/alert/status_effect/buff/drunk
	effectedstats = list("intelligence" = -1, "speed" = -1, "endurance" = 1)
	duration = 12 MINUTES

/atom/movable/screen/alert/status_effect/buff/drunk
	name = "Drunk"
	desc = "<span class='nicegreen'>I feel very drunk.</span>\n"
	icon_state = "drunk"

/datum/status_effect/buff/drunk/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stressevent/drunk)
/datum/status_effect/buff/drunk/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/drunk)

/datum/status_effect/buff/foodbuff
	id = "foodbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff
	effectedstats = list("constitution" = 1,"endurance" = 1)
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/buff/foodbuff
	name = "Great Meal"
	desc = "<span class='nicegreen'>That was a good meal!</span>\n"
	icon_state = "foodbuff"

/datum/status_effect/buff/foodbuff/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stressevent/goodfood)

/datum/status_effect/buff/druqks
	id = "druqks"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list("endurance" = 3,"speed" = 3)
	duration = 2 MINUTES

/datum/status_effect/buff/druqks/on_apply()
	. = ..()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)
			var/mob/living/carbon/C = owner
			C.add_stress(/datum/stressevent/high)


/datum/status_effect/buff/druqks/on_remove()
	. = ..()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)
			var/mob/living/carbon/C = owner
			C.remove_stress(/datum/stressevent/high)

/atom/movable/screen/alert/status_effect/buff/druqks
	name = "High"
	desc = "<span class='nicegreen'>I am tripping balls.</span>\n"
	icon_state = "acid"

/datum/status_effect/buff/ozium
	id = "ozium"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list("speed" = -3, "strength" = 3)
	duration = 2 MINUTES

/datum/status_effect/buff/ozium/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stressevent/ozium)
	ADD_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)

/datum/status_effect/buff/ozium/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/ozium)

/datum/status_effect/buff/moondust
	id = "moondust"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list("speed" = 6, "constitution" = 3, "endurance"= -3)
	duration = 2 MINUTES

/datum/status_effect/buff/moondust/nextmove_modifier()
	return 0.5

/datum/status_effect/buff/moondust/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stressevent/moondust)

/datum/status_effect/buff/moondust/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/moondust)

/datum/status_effect/buff/moondust_purest
	id = "purest moondust"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list("speed" = 6, "endurance" = 6)
	duration = 3 MINUTES

/datum/status_effect/buff/moondust_purest/nextmove_modifier()
	return 0.5

/datum/status_effect/buff/moondust_purest/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stressevent/moondust_purest)

/datum/status_effect/buff/moondust_purest/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/moondust_purest)


/datum/status_effect/buff/weed
	id = "weed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/weed
	effectedstats = list("intelligence" = 2,"speed" = -2,"fortune" = 2)
	duration = 5 MINUTES

/datum/status_effect/buff/weed/on_apply()
	. = ..()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)
			var/mob/living/carbon/C = owner
			C.add_stress(/datum/stressevent/weed)

/datum/status_effect/buff/weed/on_remove()
	. = ..()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)
			var/mob/living/carbon/C = owner
			C.remove_stress(/datum/stressevent/weed)

/atom/movable/screen/alert/status_effect/buff/weed
	name = "Dazed"
	desc = "<span class='nicegreen'>I am so high maaaaaaaaan</span>\n"
	icon_state = "weed"

/datum/status_effect/buff/ravox
	id = "ravoxbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ravoxbuff
	effectedstats = list("constitution" = 1,"endurance" = 1,"strength" = 1)
	duration = 240 MINUTES

/atom/movable/screen/alert/status_effect/buff/ravoxbuff
	name = "Divine Power"
	desc = "<span class='nicegreen'>Divine power flows through me.</span>\n"
	icon_state = "ravox"

/datum/status_effect/buff/calm
	id = "calm"
	alert_type = /atom/movable/screen/alert/status_effect/buff/calm
	effectedstats = list("fortune" = 1)
	duration = 240 MINUTES

/atom/movable/screen/alert/status_effect/buff/calm
	name = "Calmness"
	desc = "<span class='nicegreen'>I feel a supernatural calm coming over me.</span>\n"
	icon_state = "stressg"

/datum/status_effect/buff/calm/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stressevent/calm)

/datum/status_effect/buff/calm/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/calm)

/datum/status_effect/buff/noc
	id = "nocbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/nocbuff
	effectedstats = list("intelligence" = 3)
	duration = 240 MINUTES

/atom/movable/screen/alert/status_effect/buff/nocbuff
	name = "Divine Knowledge"
	desc = "<span class='nicegreen'>Divine knowledge flows through me.</span>\n"
	icon_state = "intelligence"

/datum/status_effect/buff/inspired
	id = "inspired"
	alert_type = /atom/movable/screen/alert/status_effect/buff/inspired
	effectedstats = list("speed" = 5,"constitution" = 3,"endurance" = 3,"strength" = 2)
	duration = 2 MINUTES

/atom/movable/screen/alert/status_effect/buff/inspired
	name = "Inspired"
	desc = "<span class='nicegreen'>I'm inspired to fight!</span>\n"
	icon_state = "intelligence"

/datum/status_effect/buff/inspired/great
	id = "inspired_great"
	alert_type = /atom/movable/screen/alert/status_effect/buff/inspired/great
	effectedstats = list("speed" = 7,"constitution" = 6,"endurance" = 6,"strength" = 5)
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/inspired/great
	name = "Greatly Inspired"
	desc = "<span class='nicegreen'>I feel very inspired to fight!</span>\n"
	icon_state = "intelligence"

/datum/status_effect/buff/spawn_protection
	id = "spawnprotect"
	alert_type = null
	duration = 250

/datum/status_effect/buff/spawn_protection/on_apply()
	owner.status_flags |= GODMODE
	to_chat(owner, "<span class='info'>Spawn protection now active.</span>")
	if(aspect_chosen(/datum/round_aspect/halo))
		owner.playsound_local(src, 'sound/vo/halo/invincible.mp3', 100)
	return ..()

/datum/status_effect/buff/spawn_protection/on_remove()
	owner.status_flags &= ~GODMODE
	to_chat(owner, "<span class='info'>Your moment of spawn protection invulnerability has ended.</span>")