#define WARMONGERS_SHIPPABLES		list("FIVE SMOKE BOMBS",\
									"GAS BOMBS",\
									"BOMBS",\
									"FIRE BOMB",\
									"WOODEN BALLS",\
									"CROWN POINTER",\
									"LEAD BALLS",\
									"LARGE LEAD BALLS",\
									"BOMBARDIER",\
									"TETSUBISHI CALTROPS")

/datum/job/roguetown/warfare/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	var/obj/S = null
	for(var/obj/effect/landmark/start/sloc in GLOB.start_landmarks_list)
		if(sloc.name != title)
			continue
		S = sloc
		sloc.used = TRUE
		break
	if(S)
		S.JoinPlayerHere(M)
	
	if(H)
		var/mob/living/carbon/human/HU = H

		if(check_bypasslist(H.ckey))
			if(!HU.wear_neck)
				HU.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/noc(HU), SLOT_NECK)

		if(aspect_chosen(/datum/round_aspect/squishyhumans))
			HU.STACON = 6

		if(aspect_chosen(/datum/round_aspect/cripplefight))
			var/datum/brain_trauma/severe/paralysis/paraplegic/T = new()
			var/obj/vehicle/ridden/wheelchair/wheels = new(get_turf(HU))

			HU.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)
			wheels.buckle_mob(HU)

		/*
		if(aspect_chosen(/datum/round_aspect/goblino))
			HU.set_species(/datum/species/goblin)
		*/

		//HU.add_client_colour(/datum/client_colour/sepia)
		switch(HU.warfare_faction)
			if(RED_WARTEAM)
				HU.speech_sound = 'sound/vo/speech_heartfelt.ogg'
			if(BLUE_WARTEAM)
				HU.speech_sound = 'sound/vo/speech_grenzelhoft.ogg'
		if(HAS_TRAIT(HU, TRAIT_NOBLE))
			HU.speech_sound = 'sound/vo/speech_lord.ogg'

// Captain Verbs

/mob/living/carbon/human/proc/warfare_announce()
	set name = "Announce!"
	set category = "LORD"
	var/ann = input(usr, "ANNOUNCE TO YOUR FLOCK!", "WARMONGERS") as null|text

	if(ann)
		shoutbubble()
		for(var/mob/living/carbon/human/M in GLOB.player_list)
			if(M.warfare_faction != src.warfare_faction)
				continue
			if(M.can_hear())
				to_chat(M, "<br><span class='alert'>THE WORTHY LORD SAYS: \"[ann]\"</span>")
				M.playsound_local(M.loc, 'sound/foley/trumpt.ogg', 75)

/mob/living/carbon/human/proc/warfare_command()
	set name = "Command!"
	set category = "LORD"
	var/ann = input(usr, "COMMAND YOUR FLOCK!", "WARMONGERS") as null|text

	if(ann)
		shoutbubble()
		for(var/mob/living/carbon/human/M in GLOB.player_list)
			if(M.warfare_faction != src.warfare_faction)
				continue
			if(M.can_hear())
				to_chat(M, "<br><span class='alert'>THE WORTHY LORD COMMANDS: \"[ann]\"</span>")
				M.playsound_local(M.loc, 'sound/foley/trumpt.ogg', 75)

/mob/living/carbon/human/proc/warfare_inspire()
	set name = "MASS INSPIRE (3 TRI)"
	set category = "LORD"
	var/ann = alert(usr, "ARE YOU SURE?", "WARMONGERS", "Yes", "No")
	var/mob/living/carbon/human/H = usr

	if(ann == "Yes")
		if(H.get_triumphs() < 3)
			to_chat(H, "<span class='warning'>I haven't TRIUMPHED enough.</span>")
			return
		H.adjust_triumphs(-3)
		H.shoutbubble()
		for(var/mob/living/carbon/human/M in GLOB.player_list)
			if(M.warfare_faction != src.warfare_faction)
				continue
			M.apply_status_effect(/datum/status_effect/buff/inspired)
			to_chat(M, "<span class='alert'>I WILL DIE FOR THE LORD!</span>")
			M.playsound_local(M.loc, 'sound/foley/trumpt.ogg', 75)

/mob/living/carbon/human/proc/warfare_shop()
	set name = "REDEEM SUPPORT POINTS"
	set category = "LORD"
	var/mob/living/carbon/human/H = usr
	var/datum/game_mode/warfare/C = SSticker.mode
	var/shoppin = input(usr, "URGENT BALOON AIRSHIP SHIPPING STRAIGHT FROM ENIGMA!", "BUY NOW!!!") as null|anything in WARMONGERS_SHIPPABLES
	if(!shoppin)
		return
	if(!do_after(H, 5 SECONDS, TRUE, H.loc))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	switch(H.warfare_faction)
		if(RED_WARTEAM)
			if(C.red_bonus >= 1)
				C.red_bonus--
				playsound(loc, 'sound/misc/machinevomit.ogg', 100, FALSE, -1)
			else
				playsound(loc, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				to_chat(H, "<span class='info'>Insufficient points.</span>")
				return
		if(BLUE_WARTEAM)
			if(C.blu_bonus >= 1)
				C.blu_bonus--
				playsound(loc, 'sound/misc/machinevomit.ogg', 100, FALSE, -1)
			else
				playsound(loc, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				to_chat(H, "<span class='info'>Insufficient points.</span>")
				return
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	switch(shoppin)
		if("FIVE SMOKE BOMBS")
			new /obj/item/bomb/smoke(H.loc)
			new /obj/item/bomb/smoke(H.loc)
			new /obj/item/bomb/smoke(H.loc)
			new /obj/item/bomb/smoke(H.loc)
			new /obj/item/bomb/smoke(H.loc)
		if("GAS BOMBS")
			new /obj/item/bomb/poison(H.loc)
			new /obj/item/bomb/poison(H.loc)
		if("BOMBS")
			new /obj/item/bomb(H.loc)
			new /obj/item/bomb(H.loc)
			new /obj/item/bomb(H.loc)
		if("CROWN POINTER")
			new /obj/item/pinpointer/crown(H.loc)
		if("FIRE BOMB")
			new /obj/item/bomb/fire(H.loc)
		if("WOODEN BALLS")
			new /obj/item/quiver/woodbullets(H.loc)
		if("LEAD BALLS")
			new /obj/item/quiver/bullets(H.loc)
		if("LARGE LEAD BALLS")
			new /obj/item/ammo_casing/caseless/rogue/cball(H.loc)
			new /obj/item/ammo_casing/caseless/rogue/cball(H.loc)
			new /obj/item/ammo_casing/caseless/rogue/cball(H.loc)
		if("BOMBARDIER")
			new /obj/structure/bombard(H.loc)
		if("TETSUBISHI CALTROPS")
			new /obj/item/rogue/caltrop(H.loc)
			new /obj/item/rogue/caltrop(H.loc)
			new /obj/item/rogue/caltrop(H.loc)

///////////////////////////// RED ///////////////////////////////////////

/datum/job/roguetown/warfare/red
	warfare_faction = RED_WARTEAM
	selection_color = CLOTHING_RED

/datum/job/roguetown/warfare/red/lord
	title = "Heartfelt Lord"
	tutorial = "Heartfelt is under attack. Your men are demoralized and little is left. Thankfully, most of the enemy is tied up elsewhere, maybe you might have a chance of making it out alive today."
	department_flag = REDSS
	flag = REDKING
	min_pq = -10
	total_positions = 1
	spawn_positions = 1
	faction = "Station"
	allowed_races = list(
		"Humen"
	)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	outfit = /datum/outfit/job/roguetown/redking

/datum/job/roguetown/warfare/red/lord/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	H.verbs += list(
		/mob/living/carbon/human/proc/warfare_announce,
		/mob/living/carbon/human/proc/warfare_command,
		/mob/living/carbon/human/proc/warfare_inspire,
		/mob/living/carbon/human/proc/warfare_shop
	)
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode
		C.redlord = H

	if(aspect_chosen(/datum/round_aspect/stronglords))
		H.STASTR = 20

/datum/outfit/job/roguetown/redking
	name = "Heartfelt Lord"
	jobtype = /datum/job/roguetown/warfare/red/lord

/datum/outfit/job/roguetown/redking/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	neck = /obj/item/clothing/neck/roguetown/gorget
	head = /obj/item/clothing/head/roguetown/crownred
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = GetSidearmForWarfare()
	beltl = /obj/item/quiver/bullets
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/lord
	cloak = /obj/item/clothing/cloak/heartfelt
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/red //females cant wear standard armor...
		cloak = /obj/item/clothing/cloak/raincloak/red //ditto
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/leadership, 5, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("intelligence", 3)
		H.change_stat("endurance", 3)
		H.change_stat("speed", 1)
		H.change_stat("perception", 2)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/inspire)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)

////////////// RED SOLDIERS AND CLASSES /////////////////

/datum/job/roguetown/warfare/red/soldier
	title = "Heartfelt Infantry"
	tutorial = "You're treated like shit. The runt of the litter, garbage men and beggars drafted into yet another inresolvable conflict. But if you risk your life and get out of this mess, maybe you'll get a better life when you got back. At least the pay is good, but what use is it when a ball of lead is enough to put you back into your place?"
	department_flag = REDSS
	flag = SOLDIER
	total_positions = 99
	spawn_positions = 10
	faction = "Station"
	outfit = null
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	advclass_cat_rolls = list(CTAG_REDSOLDIER = 99)

/datum/job/roguetown/warfare/red/soldier/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(aspect_chosen(/datum/round_aspect/nomood))
			ADD_TRAIT(H, TRAIT_NOMOOD, TRAIT_GENERIC)
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")

//// MUSKETEER ////

/datum/advclass/red/musketeer
	name = "Musketeer"
	tutorial = "Common infantry. Poorly armored and unsuited for melee, but equipped and trained for musket combat."
	outfit = /datum/outfit/job/roguetown/redsoldier
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0

/datum/outfit/job/roguetown/redsoldier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard/reddy
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife/cleaver/combat
	beltr = /obj/item/quiver/bullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	r_hand = GetMainGunForWarfareHeartfelt()
	if(prob(70))
		head = /obj/item/clothing/head/roguetown/helmet/kettle
	else
		head = /obj/item/clothing/head/roguetown/helmet
		mask = /obj/item/clothing/mask/rogue/chainmask
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", 1)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)

//// SAMURAI ////

/datum/advclass/red/samurai // Good health, armor, and a spear make for a stalwart defender. However, no gun skills, and slow.
	name = "Zamurai"
	tutorial = "Elite and stalwart melee combatants. While great with swords and polearms, they are terrible with guns and are slow moving."
	outfit = /datum/outfit/job/roguetown/redsamurai
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 2

/datum/outfit/job/roguetown/redsamurai/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/light
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/sword/sabre
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	head = /obj/item/clothing/head/roguetown/helmet/sallet
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	gloves = /obj/item/clothing/gloves/roguetown/angle
	if(H.dna?.species)
		if(H.dna.species.id == "human")
			armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/hand
		else
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/red //nonhumans cannot wear the standard armor
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/red //females cant wear standard armor either...
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", -1)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 2)
		H.change_stat("speed", -6)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

//// SAPPER ////

/datum/advclass/red/sapper
	name = "Sapper"
	tutorial = "Military engineers that are well equipped for construction, while also being strong and able to swing an ax. However, they lack firearms or good training in them."
	outfit = /datum/outfit/job/roguetown/redsapper
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0

/datum/outfit/job/roguetown/redsapper/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	head = /obj/item/clothing/head/roguetown/helmet
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard/reddy
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/woodcut/steel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(/obj/item/sandbagkit = 5)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 5, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)

//// HEARTFELT NINJA ////

/datum/advclass/red/ninja
	name = "Ninja"
	tutorial = "Assassins hired into the military, fighting for coin. Utilizing their stealth, knifework, and trusty pistol, they will kill all who oppose their masters."
	outfit = /datum/outfit/job/roguetown/redninja
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 2

/datum/outfit/job/roguetown/redninja/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/bullet
	beltl = /obj/item/rogueweapon/huntingknife/cleaver/combat
	beltr = GetSidearmForWarfare()
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/bomb/smoke = 1, /obj/item/flint = 1, /obj/item/rogue/caltrop = 1)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE) //average bow skills, for silent killings
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE) //ditto
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
		H.change_stat("speed", 2)
		H.change_stat("endurance", 1)
	ADD_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)

//// RIFLEMEN ////

/datum/advclass/red/riflemen //Forgoes head protection, physical stats, and weapon skills in exchange for better flintlock skills and more perception.
	name = "Riflemen"
	tutorial = "Riflemen trained to handle firearms more efficiently than the common infantry, though fare even worse in melee."
	outfit = /datum/outfit/job/roguetown/redriflemen
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 2

/datum/outfit/job/roguetown/redriflemen/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard/reddy
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife/cleaver/combat
	beltr = /obj/item/quiver/bullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	head = /obj/item/clothing/head/roguetown/bardhat
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	mask = /obj/item/clothing/mask/rogue/snipermask
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 6, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.change_stat("perception", 4)
		H.change_stat("strength", -3)
		H.change_stat("endurance", -4)
		H.change_stat("speed", -1)
		H.change_stat("constitution", -3)

//// OFFICER ////

/datum/advclass/red/officer
	name = "Officer"
	tutorial = "Officers who have been given good training in tactics, strategy, and inspiring the men, but are not as good at fighting as the common soldiery. You personally have won 30 medals, in addition the men speak that you have low blood sugar. Make them regret that!"
	outfit = /datum/outfit/job/roguetown/redofficer
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 1

/datum/outfit/job/roguetown/redofficer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/red
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/sword/rapier
	beltr = GetSidearmForWarfare()
	head = /obj/item/clothing/head/roguetown/fancyhat
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	backr = /obj/item/quiver/ironbullets
	backl = /obj/item/rogue/musicpack/heartfelt
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/leadership, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/inspire)
		H.change_stat("intelligence", 3)

//// MEDIC ////

/datum/advclass/red/medic
	name = "Medic"
	tutorial = "You like saving lives and keeping people in line. That's why you got this job."
	outfit = /datum/outfit/job/roguetown/redmedic
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0

/datum/outfit/job/roguetown/redmedic/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/red
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel/surgbag
	mask = /obj/item/clothing/mask/rogue/platemask
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/cranker
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/healthpot
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	cloak = /obj/item/clothing/cloak/apron/cook/medical
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 6, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 6, TRUE)
		H.change_stat("speed", 4)
		H.change_stat("intelligence", 3)
		H.change_stat("strength", -4)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)

/////////////////////////////////////// BLU //////////////////////////////////////////////

/datum/job/roguetown/warfare/blu
	warfare_faction = BLUE_WARTEAM
	selection_color = CLOTHING_BLUE

/datum/job/roguetown/warfare/blu/lord
	title = "Grenzelhoft Lord"
	tutorial = "A middle-class noble with inspirations for something greater. You've been given charge of a small detachment and were sent directly into the meat grinder. They said it was to build experience, but you know better."
	department_flag = BLUES
	flag = BLUKING
	min_pq = -10
	total_positions = 1
	spawn_positions = 1
	faction = "Station"
	allowed_races = list(
		"Humen"
	)
	outfit = /datum/outfit/job/roguetown/bluking

/datum/job/roguetown/warfare/blu/lord/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	H.verbs += list(
		/mob/living/carbon/human/proc/warfare_announce,
		/mob/living/carbon/human/proc/warfare_command,
		/mob/living/carbon/human/proc/warfare_inspire,
		/mob/living/carbon/human/proc/warfare_shop
	)
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode
		C.blulord = H

	if(aspect_chosen(/datum/round_aspect/stronglords))
		H.STASTR = 20

/datum/outfit/job/roguetown/bluking
	name = "Grenzelhoft Lord"
	jobtype = /datum/job/roguetown/warfare/blu/lord

/datum/outfit/job/roguetown/bluking/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	H.patron = GLOB.patronlist[/datum/patron/divine/psydon]
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	neck = /obj/item/clothing/neck/roguetown/gorget
	head = /obj/item/clothing/head/roguetown/crownblu
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/cloak/lordcloak
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = GetSidearmForWarfare()
	beltl = /obj/item/quiver/bullets
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/leadership, 5, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("intelligence", 3)
		H.change_stat("endurance", 3)
		H.change_stat("speed", 1)
		H.change_stat("perception", 2)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/inspire)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)

/////// BLU SOLDIERS AND CLASSES /////////////////

/datum/job/roguetown/warfare/blu/soldier
	title = "Grenzelhoft Infantry"
	tutorial = "You're treated like shit. The runt of the litter, garbage men and beggars drafted into yet another inresolvable conflict. But if you risk your life and get out of this mess, maybe you'll get a better life when you got back. At least the pay is good, but what use is it when a ball of lead is enough to put you back into your place?"
	department_flag = BLUES
	flag = SOLDIER
	total_positions = 99
	spawn_positions = 10
	faction = "Station"
	outfit = null
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	advclass_cat_rolls = list(CTAG_BLUSOLDIER = 99)

/datum/job/roguetown/warfare/blu/soldier/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(aspect_chosen(/datum/round_aspect/nomood))
			ADD_TRAIT(H, TRAIT_NOMOOD, TRAIT_GENERIC)
		H.patron = GLOB.patronlist[/datum/patron/divine/psydon] // Grenzelhoft worships Psydon in lore. Why wouldn't they here?
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")

//// MUSKETEER ////

/datum/advclass/blu/musketeer
	name = "Musketeer"
	tutorial = "Common infantry. Poorly armored and unsuited for melee, but equipped and trained for musket combat."
	outfit = /datum/outfit/job/roguetown/blusoldier
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0

/datum/outfit/job/roguetown/blusoldier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard/bluey
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife/cleaver/combat
	beltr = /obj/item/quiver/bullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	r_hand = GetMainGunForWarfareGrenzelhoft()
	head = /obj/item/clothing/head/roguetown/helmet/kettle/pickl
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	mask = /obj/item/clothing/mask/rogue/chainmask
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", 1)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)

//// ZWEIHANDER ////

/datum/advclass/blu/zweihander //High stamina, speed, and damage. However, no gun skills, and really not that well armored.
	name = "Zweihander"
	tutorial = "Elite shocktroops which excel with dicing apart enemies with ferocity, though they lack skill with firearms, and are not very well armored."
	outfit = /datum/outfit/job/roguetown/bluzweihander
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 2

/datum/outfit/job/roguetown/bluzweihander/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/grenzelgloves
	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/grenzelhoft/warfare
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/grenzelhoft
	backr = /obj/item/rogueweapon/sword/long/reskin
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("perception", -1)
		H.change_stat("endurance", 2)
		H.change_stat("constitution", 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

////// GRENADIER //////

/datum/advclass/blu/grenadier ///Less gun related skills in exchange for some bombs, higher strength, and an axe with accompanying skill for it
	name = "Grenadier"
	tutorial = "Specialized heavy grenade throwers and axe wielders. Slow, but strong."
	outfit = /datum/outfit/job/roguetown/blugrenadier
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 3

/datum/outfit/job/roguetown/blugrenadier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard/bluey
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = GetSidearmForWarfare()
	beltl = /obj/item/rogueweapon/woodcut/steel
	backr = /obj/item/quiver/woodbullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(/obj/item/bomb = 3, /obj/item/flint = 1, /obj/item/rogueweapon/shovel = 1)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 5, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)
		H.change_stat("speed", -6)

////// JESTER //////

/datum/advclass/blu/blujester ///Mostly a joke class. They do move fast though and can use knives.
	name = "Jester"
	tutorial = "You don't remember how the hell you got pulled into a war, but you may as well make a mockery of it."
	outfit = /datum/outfit/job/roguetown/blujester
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 2

/datum/outfit/job/roguetown/blujester/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/jester
	pants = /obj/item/clothing/under/roguetown/tights
	armor = /obj/item/clothing/suit/roguetown/shirt/jester
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogue/caltrop
	beltl = pick(/obj/item/rogueweapon/huntingknife/cleaver/combat, /obj/item/rogueweapon/sword/rapier)
	head = /obj/item/clothing/head/roguetown/jester
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	playsound(H, 'sound/foley/honk.ogg', 100, FALSE, 2)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/stealing, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/music, pick(1,2), TRUE)
		H.change_stat("speed", 6)
	ADD_TRAIT(H, TRAIT_JESTER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)

/obj/item/rogue/caltrop
	name = "caltrop"
	desc = "Grenzels call it a caltrop, Heartfeltians on the other hand a tetsubishi. Both are the same thing, they just have different names. One sane, the second a random mess of letters."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "tetsubishi"
	var/obj/item/bomb/loaded_bomb = null
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_HIP
	embedding = list("embedded_unsafe_removal_time" = 40, "embedded_pain_chance" = 40, "embedded_pain_multiplier" = 1, "embed_chance" = 100, "embedded_fall_chance" = 0)

/obj/item/rogue/caltrop/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/bomb))
		I.forceMove(src)
		loaded_bomb = I
		to_chat(user, "<span class='notice'>You attach \the [I] on \the [src].</span>")
		icon_state = "mine"
		playsound(src, 'sound/foley/trap_arm.ogg', 65)

/obj/item/rogue/caltrop/bombed/Initialize()
	. = ..()
	var/obj/item/bomb/B = new(src)
	loaded_bomb = B
	icon_state = "mine"

/obj/item/rogue/caltrop/Crossed(AM as mob|obj)
	if(isturf(loc))
		if(isliving(AM))
			var/mob/living/L = AM
			var/snap = TRUE
			if(istype(L.buckled, /obj/vehicle))
				var/obj/vehicle/ridden_vehicle = L.buckled
				if(!ridden_vehicle.are_legs_exposed)
					return ..()

			if(L.throwing)
				return ..()

			if(L.movement_type & (FLYING|FLOATING))
				return ..()

			var/def_zone = BODY_ZONE_CHEST
			if(ishuman(L))
				var/mob/living/carbon/human/C = L
				if(C.mobility_flags & MOBILITY_STAND)
					def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
					var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
					if(BP)
						add_mob_blood(C)
						if(!BP.is_object_embedded(src))
							BP.add_embedded_object(src)
						C.emote("agony")
						icon_state = "[icon_state]-bloody"
						if(loaded_bomb)
							loaded_bomb.forceMove(get_turf(C))
							loaded_bomb.light()
							loaded_bomb.explode()
			else if(isanimal(L))
				var/mob/living/simple_animal/SA = L
				if(SA.mob_size <= MOB_SIZE_TINY) //don't close the trap if they're as small as a mouse.
					snap = FALSE
			if(snap)
				L.apply_damage(50, BRUTE, def_zone)
				L.Stun(20)
	..()

//// RIFLEMEN ////

/datum/advclass/blu/riflemen
	name = "Riflemen"
	tutorial = "Riflemen trained to handle firearms more efficiently than the common infantry, though fare even worse in melee."
	outfit = /datum/outfit/job/roguetown/bluriflemen
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 3

/datum/outfit/job/roguetown/bluriflemen/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard/bluey
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife/cleaver/combat
	beltr = /obj/item/quiver/bullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	head = /obj/item/clothing/head/roguetown/bardhat
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	mask = /obj/item/clothing/mask/rogue/snipermask
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/grenz
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 6, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.change_stat("perception", 2)
		H.change_stat("strength", -3)
		H.change_stat("endurance", -4)
		H.change_stat("speed", -1)
		H.change_stat("constitution", -3)

//// OFFICER ////

/datum/advclass/blu/officer
	name = "Officer"
	tutorial = "Officers who have been given good training in tactics, strategy, and inspiring the men, but are not as good at fighting as the common soldiery. You personally have won 30 medals, in addition the men speak that you have low blood sugar. Make them regret that!"
	outfit = /datum/outfit/job/roguetown/bluofficer
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 1

/datum/outfit/job/roguetown/bluofficer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/blue
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/sword/rapier
	beltr = GetSidearmForWarfare()
	head = /obj/item/clothing/head/roguetown/fancyhat
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	backr = /obj/item/quiver/ironbullets
	backl = /obj/item/rogue/musicpack
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/leadership, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/inspire)
		H.change_stat("intelligence", 3)

//// MEDIC ////

/datum/advclass/blu/medic
	name = "Medic"
	tutorial = "You like saving lives and keeping people in line. That's why you got this job."
	outfit = /datum/outfit/job/roguetown/blumedic
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0

/datum/outfit/job/roguetown/blumedic/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/blue
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel/surgbag
	mask = /obj/item/clothing/mask/rogue/platemask
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/cranker
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/healthpot
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	cloak = /obj/item/clothing/cloak/apron/cook/medical
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 6, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 6, TRUE)
		H.change_stat("speed", 4)
		H.change_stat("intelligence", 3)
		H.change_stat("strength", -4)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)