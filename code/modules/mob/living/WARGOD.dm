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
		sleep(60)
		to_chat(world, "The sky rumbles...")
		sleep(90)
		to_chat(world, "Something speaks.")
		sleep(10)
		SEND_SOUND(world, sound('sound/vo/GOD/GOD_monologue.ogg'))
		sleep(31 SECONDS)
		SEND_SOUND(world, sound('sound/vo/GOD/GOD_is_here.ogg'))
		to_chat(world, "<span class='narsie'>GOD IS HERE.</span>")
		invisibility = 0
		flick("GOD_appear",src)
		SSticker.godfight = TRUE
		sleep(20)
		for(var/mob/I in GLOB.mob_living_list)
			I?.client?.showtext("GOD IS HERE")
			SEND_SOUND(I, sound('sound/music/combatcult.ogg'))

/mob/living/simple_animal/wargod/check_projectile_wounding(obj/projectile/P, def_zone)
	if(!hitwithbulletsalready)
		hitwithbulletsalready = TRUE
		to_chat(world, "<span class='narsiesmall'>YOU DARE TRY USE MY OWN CREATION AGAINST ME?</span>")
		SEND_SOUND(world, sound('sound/vo/GOD/GOD_invoke.ogg'))

/mob/living/simple_animal/wargod/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced)
	to_chat(world, "<span class='narsiesmall'>[message]</span>")
	SEND_SOUND(world, sound('sound/vo/GOD/GOD_speak.ogg'))
	voice_of_god(message, src, base_multiplier = 5)

/mob/living/simple_animal/wargod/death(gibbed)
	icon_state = "GOD_dying"

	for(var/mob/I in GLOB.mob_living_list)
		SEND_SOUND(I, sound(null))

	SEND_SOUND(world, sound('sound/vo/GOD/GOD_finalstrike.ogg'))
	anchored = TRUE

	to_chat(world, "<span class='narsiesmall'>BESTED BY MY OWN CREATION? VIOLENCE?!</span>")
	sleep(50)
	to_chat(world, "<span class='narsiesmall'>I DIDN'T MAKE THE METAL THAT YOU LAUNCH WITH UNHOLY POWDER ONLY TO BE PEPPERED BY UNTIL MY FORM FAILS!!!</span>")
	sleep(40)
	to_chat(world, "<span class='narsiesmall'>I... </span>")
	flick("GOD_acceptance",src)
	sleep(40)
	to_chat(world, "<span class='notice'>Perhaps it is for the best. </span>")
	sleep(40)
	to_chat(world, "<span class='notice'>I was only a little boy when my father died in the war. My mother was sent soon after.</span>")
	sleep(40)
	to_chat(world, "<span class='notice'>I was drafted as a medic, I wanted to help both sides, no one deserves to die.</span>")
	sleep(45)
	to_chat(world, "<span class='notice'>The dead men that followed me sang songs of praise about my deeds.</span>")
	sleep(40)
	to_chat(world, "<span class='notice'>I became a being of unimaginable power. But then a man tricked me.</span>")
	sleep(40)
	to_chat(world, "<span class='notice'>A no good, mother killing... GOOD FOR NOTHING-</span>")
	sleep(25)
	to_chat(world, "<span class='narsiesmall'>PIECE.</span>")
	SEND_SOUND(world, sound('sound/vo/GOD/GOD_speak.ogg'))
	sleep(20)
	to_chat(world, "<span class='narsiesmall'>OF.</span>")
	SEND_SOUND(world, sound('sound/vo/GOD/GOD_speak.ogg'))
	sleep(20)
	to_chat(world, "<span class='narsie'>SHIT!</span>")
	SEND_SOUND(world, sound('sound/vo/GOD/GOD_invoke.ogg'))
	sleep(40)
	to_chat(world, "<span class='notice'>...</span>")
	sleep(35)
	to_chat(world, "<span class='notice'>So many... died for nothing.</span>")
	sleep(45)
	to_chat(world, "<span class='notice'>Don't let him trick you again.</span>")
	sleep(50)
	to_chat(world, "<span class='notice'>Let my essence birth a universe, where war prospers no more.</span>")
	sleep(80)
	SEND_SOUND(world, sound('sound/vo/GOD/GOD_death.ogg', volume = 35))
	flick("GOD_die",src)
	QDEL_IN(src, 15.3)

	sleep(10 SECONDS)
	SSticker.force_ending = TRUE