GLOBAL_LIST_INIT(bum_quotes, world.file2list("string/rt/bumlines.txt"))
GLOBAL_LIST_INIT(bum_aggro, world.file2list("string/rt/bumaggrolines.txt"))

/mob/living/carbon/human/species/human/northern/bum/propsoldier
	aggressive=0
	mode = AI_IDLE
	faction = list("grenzie", "station")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	possible_rmb_intents = list()

	wander = FALSE

/mob/living/carbon/human/species/human/northern/bum/propsoldier/heartfelt
	faction = list("heartie", "station")

/mob/living/carbon/human/species/human/northern/bum/propsoldier/after_creation() // for screenshots and such
	QDEL_NULL(sexcon)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOROGSTAM, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/blusoldier)

/mob/living/carbon/human/species/human/northern/bum/propsoldier/heartfelt/after_creation() // for screenshots and such
	QDEL_NULL(sexcon)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOROGSTAM, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/redsoldier)

/mob/living/carbon/human/species/human/northern/bum
	aggressive=0
	mode = AI_IDLE
	faction = list("bums", "station")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	possible_rmb_intents = list()

	wander = FALSE

/mob/living/carbon/human/species/human/northern/bum/death(gibbed)
	. = ..()
	mode = AI_OFF

/mob/living/carbon/human/species/human/northern/bum/ambush
	aggressive=1

	wander = TRUE

/mob/living/carbon/human/species/human/northern/bum/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
		if(target != newtarg)
			say(pick(GLOB.bum_aggro))
			linepoint(target)

/mob/living/carbon/human/species/human/northern/bum/should_target(var/mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/human/northern/bum/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	spawn(10)
		after_creation()
	//addtimer(CALLBACK(src, PROC_REF(after_creation)), 10)

/mob/living/carbon/human/species/human/northern/bum/after_creation()
	..()
	job = "Beggar"
	QDEL_NULL(sexcon)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOROGSTAM, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/vagrant)

/mob/living/carbon/human/species/human/northern/bum/npc_idle()
	if(m_intent == MOVE_INTENT_SNEAK)
		return
	if(world.time < next_idle)
		return
	next_idle = world.time + rand(30, 70)
	if((mobility_flags & MOBILITY_MOVE) && isturf(loc) && wander)
		if(prob(20))
			var/turf/T = get_step(loc,pick(GLOB.cardinals))
			if(!istype(T, /turf/open/transparent/openspace))
				Move(T)
		else
			face_atom(get_step(src,pick(GLOB.cardinals)))
	if(!wander && prob(10))
		face_atom(get_step(src,pick(GLOB.cardinals)))
	if(prob(3))
		say(pick(GLOB.bum_quotes))
	if(prob(3))
		emote(pick("laugh","burp","yawn","grumble","mumble","blink_r","clap"))
