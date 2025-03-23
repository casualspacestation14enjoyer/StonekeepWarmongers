/mob/living/simple_animal/wargod
	name = "GOD OF WAR"
	desc = "Kill the creator of death."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "GOD"
	status_flags = GODMODE // I'm too lazy to make something balanced. I'll just kill myself when people think they did enough damage.
	incorporeal_move = INCORPOREAL_MOVE_SHADOW
	footstep_type = FOOTSTEP_MOB_HEAVY
	hud_type = /datum/hud/dextrous
	base_intents = list(/datum/intent/unarmed/ascendedclaw)
	melee_damage_lower = 250
	melee_damage_upper = 550
	maxrogfat = 999999
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	var/hitwithbulletsalready = FALSE
	STACON = 666
	STASTR = 666
	STASPD = 666
	STAEND = 666

/mob/living/simple_animal/wargod/mind_initialize()
	. = ..()
	mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/god)
	mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball/greater/god)
	mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball/greater/godboom)
	mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/repulse/god)

/mob/living/simple_animal/wargod/Initialize()
	. = ..()
	filters += AMBIENT_OCCLUSION
	invisibility = INVISIBILITY_MAXIMUM
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_IGNORESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NODEATH, TRAIT_GENERIC)

	spawn(1)
		to_chat(world, "...")
		sleep(10)
		to_chat(world, "The Heartfelts didn't come to this battle..?")
		sleep(20)
		to_chat(world, "Who do we fight?")
		sleep(20)
		to_chat(world, "The sky rumbles...")
		sleep(20)
		to_chat(world, "Something speaks.")
		sleep(10)
		SEND_SOUND(world, sound('sound/vo/GOD/GOD_monologue.ogg'))
		sleep(31 SECONDS)
		SEND_SOUND(world, sound('sound/vo/GOD/GOD_is_here.ogg'))
		to_chat(world, "<span class='narsie'>GOD IS HERE.</span>")
		sleep(5 SECONDS)
		invisibility = 0
		flick("GOD_appear",src)
		SSticker.godfight = TRUE
		for(var/mob/I in GLOB.mob_living_list)
			SEND_SOUND(I, sound('sound/music/combatcult.ogg'))

/mob/living/simple_animal/wargod/check_projectile_wounding(obj/projectile/P, def_zone)
	if(!hitwithbulletsalready)
		hitwithbulletsalready = TRUE
		to_chat(world, "<span class='narsie'>YOU DARE TRY USE MY OWN CREATION AGAINST ME?</span>")

/mob/living/simple_animal/wargod/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced)
	to_chat(world, "<span class='narsiesmall'>[message]</span>")
	SEND_SOUND(world, sound('sound/vo/GOD/GOD_speak.ogg'))
	voice_of_god(message, src, base_multiplier = 5)

/mob/living/simple_animal/wargod/death(gibbed)
	flick("GOD_die",src)
	QDEL_IN(src, 15.3)