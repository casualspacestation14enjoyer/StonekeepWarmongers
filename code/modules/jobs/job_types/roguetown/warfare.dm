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
			ADD_TRAIT(HU, TRAIT_BRITTLE, TRAIT_GENERIC)

		if(aspect_chosen(/datum/round_aspect/kicking))
			ADD_TRAIT(HU, TRAIT_NUTCRACKER, TRAIT_GENERIC)
			
		/*
		if(aspect_chosen(/datum/round_aspect/cripplefight))
			var/datum/brain_trauma/severe/paralysis/paraplegic/T = new()
			var/obj/vehicle/ridden/wheelchair/wheels = new(HU.loc)

			HU.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)
			wheels.buckle_mob(HU)

		
		if(aspect_chosen(/datum/round_aspect/goblino))
			HU.set_species(/datum/species/goblin)
		*/

		//HU.add_client_colour(/datum/client_colour/sepia)
		switch(HU.warfare_faction)
			if(RED_WARTEAM)
				HU.speech_sound = 'sound/vo/speech_heartfelt.ogg'
				HU.cmode_music = 'sound/music/combatheartfelt.ogg'
			if(BLUE_WARTEAM)
				HU.speech_sound = 'sound/vo/speech_grenzelhoft.ogg'
				HU.cmode_music = 'sound/music/combatgrenzelhoft.ogg'
		if(HAS_TRAIT(HU, TRAIT_NOBLE))
			HU.speech_sound = 'sound/vo/speech_lord.ogg'

// Lord Procs

/proc/getlordtitle()
	return pick("of Volfs", "the Tyrant", "the Idiot", "the Foolish", "the Bloody", "the Impaler", "the Discombobulater", "the Risktaker", "the Golden", "of Gold", "the Warmonger", "the Thief", "the Waterborn", "the Bloodborn", "the Barker", "the Volf", "the Predator", "of Predators", "the Stealthy", "the Sneaky", "the Destroyer", "the Ambusher", "the Bomber", "the Strategist", "of Strategy", "of Bombing", "of Ambushing", "the Racist", "the Hater of Elves", "the Suicidal", "the Buffoon", "the Baboon", "the Bear", "the Bringer of Death", "of Death", "the Ordinary", "the Boring", "the Peaceful", "the Negotiator", "the Actor", "the Funny", "the Jestful", "of Jesters", "of Heartfelt", "of Grenzelhoft", "of Life")

/mob/living/carbon/human/proc/warfare_announce()
	set name = "ANNOUNCE!"
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
	set name = "COMMAND!"
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
			if(aspect_chosen(/datum/round_aspect/halo))
				M.playsound_local(M.loc, 'sound/vo/halo/hail2theking.mp3', 75)
			else
				M.playsound_local(M.loc, 'sound/foley/trumpt.ogg', 75)

/mob/living/carbon/human/proc/warfare_shop()
	set name = "REDEEM SUPPORT POINTS"
	set category = "LORD"
	var/datum/game_mode/warfare/C = SSticker.mode
	var/list/shippables = list()

	for(var/s in subtypesof(/datum/warshippable))
		var/datum/warshippable/WS = new s()
		if(C.reinforcementwave >= WS.reinforcement)
			shippables[WS.name] = WS

	var/choice = input(src, "URGENT AIRSHIP SHIPPING STRAIGHT FROM ENIGMA!", "BUY NOW!!!") as null|anything in shippables
	var/datum/warshippable/shoppin = shippables[choice]
	if(!shoppin)
		return
	if(!do_after(src, 5 SECONDS, TRUE, loc))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	switch(warfare_faction)
		if(RED_WARTEAM)
			if(C.red_bonus >= 1)
				C.red_bonus--
				playsound(loc, 'sound/misc/machinevomit.ogg', 100, FALSE, -1)
			else
				playsound(loc, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				to_chat(src, "<span class='info'>Insufficient points.</span>")
				return
		if(BLUE_WARTEAM)
			if(C.blu_bonus >= 1)
				C.blu_bonus--
				playsound(loc, 'sound/misc/machinevomit.ogg', 100, FALSE, -1)
			else
				playsound(loc, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				to_chat(src, "<span class='info'>Insufficient points.</span>")
				return
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

	for(var/i in shoppin.items)
		new i(get_turf(src))

///////////////////////////// RED ///////////////////////////////////////

/datum/job/roguetown/warfare/red
	warfare_faction = RED_WARTEAM
	selection_color = CLOTHING_RED

/datum/job/roguetown/warfare/red/lord
	title = "Heartfelt Lord"
	tutorial = "Heartfelt is under attack. Your men are demoralized and little is left. But not all is lost just yet, with supplies coming in from the Foglands you might be able to push the Grenzelhoft barbarians off this land."
	department_flag = REDSS
	flag = REDKING
	min_pq = 0
	total_positions = 1
	spawn_positions = 1
	faction = "Station"
	allowed_races = list(
		"Humen"
	)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	outfit = /datum/outfit/job/roguetown/redking

/datum/job/roguetown/warfare/red/lord/after_spawn(mob/living/carbon/human/H, mob/M, latejoin)
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
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
		ADD_TRAIT(H, TRAIT_RIVERSWIMMER, TRAIT_GENERIC)

	if(aspect_chosen(/datum/round_aspect/veteranlords))
		H.change_stat("strength", 3)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.charflaw = new /datum/charflaw/noeyer()
		if(!istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
			qdel(H.wear_mask)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/eyepatch, SLOT_WEAR_MASK)
		ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC) // Desensitized through thousand campaigns

/datum/outfit/job/roguetown/redking
	name = "Heartfelt Lord"
	jobtype = /datum/job/roguetown/warfare/red/lord

/datum/outfit/job/roguetown/redking/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light/hitatare/heartfelt
	mask = /obj/item/clothing/mask/rogue/kaizoku/menpo/facemask/colourable/oni
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/quiver/bullets
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/suneate
	pants = /obj/item/clothing/under/roguetown/trou/tobi
	belt = /obj/item/storage/belt/rogue/kaizoku/leather/daisho/heartfelt
	beltr = GetSidearmForWarfare()
	beltl = /obj/item/rogueweapon/sword/sabre/piandao/dec
	armor = /obj/item/clothing/suit/roguetown/armor/medium/surcoat/heartfelt
	cloak = /obj/item/clothing/cloak/heartfelt
	if(SSmapping.config.map_name == "LD-Bloodfort")
		head = /obj/item/clothing/head/roguetown/crownred
	if(!(findtext(H.real_name, " of ") || findtext(H.real_name, " the ")))
		H.change_name("[H.real_name] [getlordtitle()]")
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
	tutorial = "Every day feels as though its worst than the last, hope is dwindling and food is getting scarcer. You never wanted any of this, but even though no man wants war it will find him eventually regardless. You have two choices, die, or take up arms and drive these barbarians back into the sea! For Heartfelt!"
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
		if(aspect_chosen(/datum/round_aspect/monkwarfare))
			H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 6)
		H.advsetup = TRUE
		H.status_flags |= GODMODE
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		H.apply_status_effect(/datum/status_effect/incapacitating/stun)

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
	pants = /obj/item/clothing/under/roguetown/trou/tobi
	cloak = /obj/item/clothing/cloak/jinbaori/reddy
	shirt = /obj/item/clothing/suit/roguetown/shirt/looseshirt
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/tatami
	shoes = /obj/item/clothing/shoes/roguetown/boots/jikatabi
	belt = /obj/item/storage/belt/rogue/kaizoku/leather/daisho/heartfelt
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/tanto
	beltr = /obj/item/quiver/bullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/kote
	backr = GetMainGunForWarfareHeartfelt()
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	if(prob(70))
		head = /obj/item/clothing/head/roguetown/helmet/jingasa
	else
		head = /obj/item/clothing/head/roguetown/helmet/jingasa
		mouth = /obj/item/clothing/mask/cigarette/rollie/nicotine
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
	tutorial = "Elite and stalwart melee combatants. While great with swords and polearms, they forego the use of firearms entirely."
	outfit = /datum/outfit/job/roguetown/redsamurai
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 1

/datum/outfit/job/roguetown/redsamurai/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/tobi
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light/hitatare/heartfelt
	armor = /obj/item/clothing/suit/roguetown/armor/medium/surcoat/heartfelt/abyssariad/heartfelt
	backl = /obj/item/rogue/musicpack/heartfelt // Zamurai are mostly a unit only still trained because it boosts moral, they're a potent masculine figure in Heartfelt. Like lumberjacks!
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/suneate
	belt = /obj/item/storage/belt/rogue/kaizoku/leather/daisho/heartfelt
	beltl = /obj/item/rogueweapon/sword/short/wakizashi
	backr = /obj/item/rogueweapon/halberd/naginata
	wrists = /obj/item/clothing/wrists/roguetown/bracers/kote
	gloves = /obj/item/clothing/gloves/roguetown/leather/abyssal
	mask = /obj/item/clothing/mask/rogue/kaizoku/menpo/steel/half
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
	tutorial = "Military engineers that are well equipped for construction, while also being strong enough to hold the line against incursions. Despite this they are not well armed when it comes to firearms."
	outfit = /datum/outfit/job/roguetown/redsapper
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0

/datum/outfit/job/roguetown/redsapper/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	pants = /obj/item/clothing/under/roguetown/trou/tobi
	cloak = /obj/item/clothing/cloak/jinbaori/reddy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light/hitatare
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/rattan
	shoes = /obj/item/clothing/shoes/roguetown/boots/jikatabi
	belt = /obj/item/storage/belt/rogue/kaizoku/leather/daisho/heartfelt
	if(H.dna.species.id == "dwarf")
		beltl = /obj/item/rogueweapon/woodcut/pick
	else
		beltl = /obj/item/rogueweapon/battle/ono
	beltr = GetSidearmForWarfare()
	wrists = /obj/item/clothing/wrists/roguetown/bracers/kote
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/shield/rattan
	if(prob(70))
		head = /obj/item/clothing/head/roguetown/helmet/skullcap/rattan
	else
		head = /obj/item/clothing/head/roguetown/helmet/skullcap/rattan
		mouth = /obj/item/clothing/mask/cigarette/rollie/nicotine
	backpack_contents = list(/obj/item/sandbagkit = 4, /obj/item/rogueweapon/shovel = 1)
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

//// FIRELANCER ////

/datum/advclass/red/firelancer
	name = "Firelancer"
	tutorial = "Heartfelts answer to Grenzelhofts Grenadiers. The Firelance, formerly 'Widowmaker' is a strange, difficult to operate, and most importantly dangerous weapon. Only Firelancers are trained in their operation."
	outfit = /datum/outfit/job/roguetown/firelancer
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 3

/datum/outfit/job/roguetown/firelancer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	pants = /obj/item/clothing/under/roguetown/trou/tobi
	cloak = /obj/item/clothing/cloak/jinbaori/reddy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light/hitatare
	armor = /obj/item/clothing/suit/roguetown/armor/cuirass/sanmaido
	shoes = /obj/item/clothing/shoes/roguetown/boots/jikatabi
	backr = /obj/item/rogueweapon/spear/firelance
	belt = /obj/item/storage/belt/rogue/kaizoku/leather/daisho/heartfelt
	beltr = /obj/item/flint
	beltl = /obj/item/rogueweapon/mace/ararebo
	wrists = /obj/item/clothing/wrists/roguetown/bracers/kote
	backl = /obj/item/storage/backpack/rogue/satchel
	if(prob(70))
		head = /obj/item/clothing/head/roguetown/helmet/zijinguan
	else
		head = /obj/item/clothing/head/roguetown/helmet/zijinguan
		mask = /obj/item/clothing/mask/cigarette/rollie/nicotine
	backpack_contents = list(/obj/item/sanctiflux = 3)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)

//// HEARTFELT NINJA ////

/datum/advclass/red/ninja
	name = "Ninja"
	tutorial = "Assassins hired into the military, fighting for coin. Utilizing bows, bombs, and knives they strike unseen where the enemy expects them the least."
	outfit = /datum/outfit/job/roguetown/redninja
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 2

/datum/outfit/job/roguetown/redninja/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather/shinobizubon
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/shozoku
	shirt = /obj/item/clothing/suit/roguetown/shirt/looseshirt
	head = /obj/item/clothing/head/roguetown/shinobi_zukin
	shoes = /obj/item/clothing/shoes/roguetown/boots/jikatabi
	belt = /obj/item/storage/belt/rogue/kaizoku/leather/daisho/heartfelt
	beltr = /obj/item/quiver/arrows
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/tanto
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/hankyu
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/khudagach
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/bomb/smoke = 1, /obj/item/bomb/poison = 2, /obj/item/rogue/caltrop = 2, /obj/item/throwing_star/ninja = 1)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE) //No more firearms, strictly bows and crossbows, fog arrows should provide boost in that regard.
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
	H.cmode_music = 'sound/music/combatspecial.ogg'
	ADD_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NINJA, TRAIT_GENERIC)

//// RIFLEMEN ////

/datum/advclass/red/riflemen //Forgoes head protection, physical stats, and weapon skills in exchange for better flintlock skills and more perception.
	name = "Sharpbarker"
	tutorial = "Far better trained compared to the common soldiery, and with a marksmans rifle as well. The only issue is lacking in melee combat even worse than Ashigaru."
	outfit = /datum/outfit/job/roguetown/redriflemen
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 2

/datum/outfit/job/roguetown/redriflemen/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/tobi
	cloak = /obj/item/clothing/cloak/raincloak/mino
	shirt = /obj/item/clothing/suit/roguetown/shirt/looseshirt
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/tatami
	shoes = /obj/item/clothing/shoes/roguetown/boots/jikatabi
	belt = /obj/item/storage/belt/rogue/kaizoku/leather/daisho/heartfelt
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/tanto
	beltr = /obj/item/quiver/bullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/kote
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/heart
	r_hand = GetMainGunForWarfareHeartfelt()
	if(prob(70))
		head = /obj/item/clothing/head/roguetown/tengai/gasa
	else
		head = /obj/item/clothing/head/roguetown/tengai/gasa
		mouth = /obj/item/clothing/mask/cigarette/rollie/nicotine
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
		H.change_stat("speed", -2)
		H.change_stat("constitution", -3)
	ADD_TRAIT(H, TRAIT_SNIPER, TRAIT_GENERIC)

//// OFFICER ////

/datum/advclass/red/officer
	name = "Officer"
	tutorial = "Officers of Heartfelt are expected to lead from the front, rousing the troops and braving bullets and blades alike in order to achieve victory."
	outfit = /datum/outfit/job/roguetown/redofficer
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0
	min_pq = -5

/datum/outfit/job/roguetown/redofficer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/tobi
	shirt = /obj/item/clothing/suit/roguetown/shirt/looseshirt
	armor = /obj/item/clothing/suit/roguetown/armor/medium/surcoat/heartfelt/hand
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/suneate
	belt = /obj/item/storage/belt/rogue/kaizoku/leather/daisho/heartfelt
	beltl = /obj/item/rogueweapon/sword/sabre/piandao
	beltr = GetSidearmForWarfare()
	head = /obj/item/clothing/head/roguetown/helmet/leather/malgai/kaizoku
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	backr = /obj/item/quiver/ironbullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/kote
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/leather/malgai/kaizoku
	else
		head = /obj/item/clothing/head/roguetown/helmet/leather/malgai/kaizoku
		mouth = /obj/item/clothing/mask/cigarette/pipe/westman
	if(H.gender == FEMALE)
		armor =	/obj/item/clothing/suit/roguetown/armor/medium/surcoat/heartfelt/hand/female
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
	H.cmode_music = 'sound/music/combatspecial.ogg'
	ADD_TRAIT(H, TRAIT_OFFICER, TRAIT_GENERIC)

//// MEDIC ////

/datum/advclass/red/medic
	name = "Medic"
	tutorial = "The task of a Medic is a difficult one, with far more corpses than wounded soldiers. They do their bit regardless and ensure those who do survive will last longer."
	outfit = /datum/outfit/job/roguetown/redmedic
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0

/datum/outfit/job/roguetown/redmedic/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/tobi
	shirt = /obj/item/clothing/suit/roguetown/shirt/looseshirt
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/light/hitatare
	shoes = /obj/item/clothing/shoes/roguetown/boots/jikatabi
	backl = /obj/item/storage/backpack/rogue/satchel/surgbag
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	belt = /obj/item/storage/belt/rogue/leather/medic
	beltl = /obj/item/cranker
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/healthpot
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
	H.slowed_by_drag = FALSE
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_RIVERSWIMMER, TRAIT_GENERIC)

//// ELVEN SLAVE ////

/datum/advclass/red/slave
	name = "Elven Slave"
	tutorial = "You got into this war either by force or a by treasonous act to your home, either way you're not coming back, they hate you, they all hate you."
	outfit = /datum/outfit/job/roguetown/redslave
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = "Elf"
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0

/datum/outfit/job/roguetown/redslave/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/red
	shoes = /obj/item/clothing/shoes/roguetown/boots
	r_hand = pick(/obj/item/rogueweapon/woodstaff,/obj/item/rogueweapon/spear,/obj/item/rogueweapon/spear/billhook,/obj/item/rogueweapon/spear/stone,/obj/item/rogueweapon/copperspear)
	belt = /obj/item/storage/belt/rogue/leather/cloth
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE)
		H.change_stat("speed", 2)
		H.change_stat("intelligence", -3)
		H.change_stat("strength", -3)

/////////////////////////////////////// BLU //////////////////////////////////////////////

/datum/job/roguetown/warfare/blu
	warfare_faction = BLUE_WARTEAM
	selection_color = CLOTHING_BLUE

/datum/job/roguetown/warfare/blu/lord
	title = "Grenzelhoft Lord"
	tutorial = "A middle-class noble with aspirations for something greater. You've been given charge of a small detachment and sent directly into the meat grinder. You will either return to Grenzelhoft a conquerer, or not at all."
	department_flag = BLUES
	flag = BLUKING
	min_pq = 0
	total_positions = 1
	spawn_positions = 1
	faction = "Station"
	allowed_races = list(
		"Humen"
	)
	outfit = /datum/outfit/job/roguetown/bluking

/datum/job/roguetown/warfare/blu/lord/after_spawn(mob/living/carbon/human/H, mob/M, latejoin)
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
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
		ADD_TRAIT(H, TRAIT_RIVERSWIMMER, TRAIT_GENERIC)

	if(aspect_chosen(/datum/round_aspect/veteranlords))
		H.change_stat("strength", 3)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.charflaw = new /datum/charflaw/noeyer()
		if(!istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
			qdel(H.wear_mask)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/eyepatch, SLOT_WEAR_MASK)
		ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC) // Desensitized through thousand campaigns

/datum/outfit/job/roguetown/bluking
	name = "Grenzelhoft Lord"
	jobtype = /datum/job/roguetown/warfare/blu/lord

/datum/outfit/job/roguetown/bluking/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	H.patron = GLOB.patronlist[/datum/patron/divine/psydon]
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	neck = /obj/item/clothing/neck/roguetown/gorget
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/quiver/bullets
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/black
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/commander/blue
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = GetSidearmForWarfare()
	beltl = /obj/item/rogueweapon/sword
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	if(SSmapping.config.map_name == "LD-Bloodfort")
		cloak = /obj/item/clothing/cloak/lordcloak
		head = /obj/item/clothing/head/roguetown/crownblu
	else
		head = /obj/item/clothing/head/roguetown/commander
	if(!(findtext(H.real_name, " of ") || findtext(H.real_name, " the ")))
		H.change_name("[H.real_name] [getlordtitle()]")
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
	tutorial = "Yours is a just task, to expand the borders of the Grenzelhoft Imperiate, the lack of food in your belly and pay in your pocket is easily ignored by knowing you're doing your part, in the unending colossus that is Grenzelhoft. For the Empire! For the KAISER! For the One True God!"
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
		if(aspect_chosen(/datum/round_aspect/monkwarfare))
			H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 6)
		H.patron = GLOB.patronlist[/datum/patron/divine/psydon] // Grenzelhoft worships Psydon in lore. Why wouldn't they here?
		H.advsetup = TRUE
		H.status_flags |= GODMODE
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		H.apply_status_effect(/datum/status_effect/incapacitating/stun)

//// MUSKETEER ////

/datum/advclass/blu/musketeer
	name = "Musketeer"
	tutorial = "The backbone of the army, musketeers are expected to fight at range, as their melee prowess is lacking compared to other divisions."
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
	backr = GetMainGunForWarfareGrenzelhoft()
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	if(prob(70))
		head = /obj/item/clothing/head/roguetown/helmet/kettle/pickl
	else
		head = /obj/item/clothing/head/roguetown/helmet/kettle/pickl
		mouth = /obj/item/clothing/mask/cigarette/rollie/nicotine
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
	tutorial = "Elite shocktroops which excel with dicing apart enemies with ferocity, but they are poorly armored, and unable to use firearms due to lack of training."
	outfit = /datum/outfit/job/roguetown/bluzweihander
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 1

/datum/outfit/job/roguetown/bluzweihander/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/grenzelgloves
	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/grenzelhoft/warfare
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/grenzelhoft
	backr = /obj/item/rogueweapon/sword/long/reskin
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/grenzelhofthat
	else
		head = /obj/item/clothing/head/roguetown/grenzelhofthat
		mouth = /obj/item/clothing/mask/cigarette/pipe
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

//// HUSSAR ////

/datum/advclass/blu/hussar
	name = "Hussar"
	tutorial = "Elite cavalry troops who can quickly turn the battle in favor of the Imperiate."
	outfit = /datum/outfit/job/roguetown/bluhussar
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled
	maximum_possible_slots = -1
	reinforcements_wave = 3

/datum/outfit/job/roguetown/bluhussar/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/nobleboot
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	beltl = GetSidearmForWarfare()
	beltr = /obj/item/quiver/bullets
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	head = /obj/item/clothing/head/roguetown/helmet/hussarhelm
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/hussar
	backr = /obj/item/rogueweapon/spear
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", -1)
		H.change_stat("endurance", 1)
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
	reinforcements_wave = 0

/datum/outfit/job/roguetown/blugrenadier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard/bluey
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = GetSidearmForWarfare()
	if(H.dna.species.id == "dwarf")
		beltl = /obj/item/rogueweapon/woodcut/pick
	else
		beltl = /obj/item/rogueweapon/woodcut/steel
	backr = /obj/item/quiver/woodbullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	backl = /obj/item/storage/backpack/rogue/backpack
	if(prob(70))
		head = /obj/item/clothing/head/roguetown/helmet/kettle/steelhelm
		mask = /obj/item/clothing/mask/rogue/platemask
	else
		head = /obj/item/clothing/head/roguetown/helmet/kettle/steelhelm
		mouth = /obj/item/clothing/mask/cigarette/rollie/nicotine
	backpack_contents = list(/obj/item/bomb = 4, /obj/item/flint = 1)
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
	backl = /obj/item/rogue/musicpack
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogue/caltrop/bombed
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
	H.cmode_music = 'sound/music/combatspecial.ogg'
	ADD_TRAIT(H, TRAIT_JESTER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)

/obj/item/rogue/caltrop
	name = "caltrop"
	desc = "Heartfeltians call this thing a tetsubishi. But now armed with a bomb theres only one thing you can call it, funny. "
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
							QDEL_NULL(loaded_bomb)
							loaded_bomb = null
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
	name = "Sharpbarker"
	tutorial = "Marksmen trained to handle firearms more efficiently than the common infantry, though fare even worse in melee."
	outfit = /datum/outfit/job/roguetown/bluriflemen
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 2

/datum/outfit/job/roguetown/bluriflemen/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife/cleaver/combat
	beltr = /obj/item/quiver/bullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	mask = /obj/item/clothing/mask/rogue/snipermask
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/grenz
	r_hand = GetMainGunForWarfareGrenzelhoft()
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
		H.change_stat("speed", -2)
		H.change_stat("constitution", -3)
	ADD_TRAIT(H, TRAIT_SNIPER, TRAIT_GENERIC)

//// OFFICER ////

/datum/advclass/blu/officer
	name = "Officer"
	tutorial = "Officers who have been given good training in tactics, strategy, and inspiring the men, but are not as good at fighting as the common soldiery. Lead from the front and keep morale in the ranks."
	outfit = /datum/outfit/job/roguetown/bluofficer
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0
	min_pq = -5

/datum/outfit/job/roguetown/bluofficer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/blue
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/sword/rapier
	beltr = GetSidearmForWarfare()
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	backr = /obj/item/quiver/ironbullets
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/offitser
	else
		head = /obj/item/clothing/head/roguetown/offitser
		mouth = /obj/item/clothing/mask/cigarette/pipe
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
	H.cmode_music = 'sound/music/combatspecial.ogg'
	ADD_TRAIT(H, TRAIT_OFFICER, TRAIT_GENERIC)

//// MEDIC ////

/datum/advclass/blu/medic
	name = "Medic"
	tutorial = "Sanitaters feel like gravediggers, considering they deal with more corpses than wounded soldiers. Still, they do their part however they can."
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
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	belt = /obj/item/storage/belt/rogue/leather/medic
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
	H.slowed_by_drag = FALSE
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_RIVERSWIMMER, TRAIT_GENERIC)

//// ELVEN SLAVE ////

/datum/advclass/blu/slave
	name = "Elven Slave"
	tutorial = "You got into this war either by force or a by treasonous act to your home, either way you're not coming back, they hate you, they all hate you."
	outfit = /datum/outfit/job/roguetown/bluslave
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = "Elf"
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0

/datum/outfit/job/roguetown/bluslave/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/warfare/blue
	shoes = /obj/item/clothing/shoes/roguetown/boots
	r_hand = pick(/obj/item/rogueweapon/woodstaff,/obj/item/rogueweapon/spear,/obj/item/rogueweapon/spear/billhook,/obj/item/rogueweapon/spear/stone,/obj/item/rogueweapon/copperspear)
	belt = /obj/item/storage/belt/rogue/leather/cloth
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/bows, 5, TRUE)
		H.change_stat("speed", 2)
		H.change_stat("intelligence", -3)
		H.change_stat("strength", -1)