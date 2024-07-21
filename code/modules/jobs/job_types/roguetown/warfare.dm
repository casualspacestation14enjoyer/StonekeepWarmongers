/datum/job/roguetown/warfare/red
	warfare_faction = RED_WARTEAM
	selection_color = CLOTHING_RED

/datum/job/roguetown/warfare/red/lord
	title = "Heartfelt Lord"
	tutorial = "todo"
	department_flag = NOBLEMEN
	flag = LORD
	total_positions = 1
	spawn_positions = 1
	faction = "Station"
	outfit = null
	allowed_races = list(
		"Humen"
	)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)

/datum/job/roguetown/warfare/red/soldier
	title = "Heartfelt Infantry"
	tutorial = "You're treated like shit. The run of the litter, garbage men and beggars drafted into yet another inresolvable conflict. But if you risk your life and get out of this mess, maybe you'll get a better life when you got back. At least the pay is good, but what use is it when a ball of lead is enough to put you back into your place?"
	department_flag = PEASANTS
	flag = SOLDIER
	total_positions = 99
	spawn_positions = 10
	faction = "Station"
	outfit = /datum/outfit/job/roguetown/redsoldier
	allowed_races = list(
		"Humen",
		"Elf",
		"Dwarf"
	)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)

/datum/outfit/job/roguetown/redsoldier
	name = "Heartfelt Soldier"
	jobtype = /datum/job/roguetown/warfare/red/soldier

/datum/outfit/job/roguetown/redsoldier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard/reddy
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	neck = /obj/item/clothing/neck/roguetown/gorget
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/quiver/bullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(prob(70))
		head = /obj/item/clothing/head/roguetown/helmet/kettle
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/bayo
	else
		head = /obj/item/clothing/head/roguetown/helmet
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", 1)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/datum/job/roguetown/warfare/blu
	warfare_faction = BLUE_WARTEAM
	selection_color = CLOTHING_BLUE

/datum/job/roguetown/warfare/blu/lord
	title = "Grenzelhoft Lord"
	tutorial = "todo"
	department_flag = NOBLEMEN
	flag = LORD
	total_positions = 1
	spawn_positions = 1
	faction = "Station"

/datum/job/roguetown/warfare/blu/soldier
    title = "Grenzelhoft Infantry"
    tutorial = "You're treated like shit. The run of the litter, garbage men and beggars drafted into yet another inresolvable conflict. But if you risk your life and get out of this mess, maybe you'll get a better life when you got back. At least the pay is good, but what use is it when a ball of lead is enough to put you back into your place?"
    department_flag = PEASANTS
    flag = SOLDIER
    total_positions = 99
    spawn_positions = 10
    faction = "Station"
    outfit = /datum/outfit/job/roguetown/blusoldier
    allowed_races = list(
		"Humen",
		"Elf",
		"Dwarf"
	)
    allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)

/datum/outfit/job/roguetown/blusoldier
	name = "Grenzelhoftian Soldier"
	jobtype = /datum/job/roguetown/warfare/blu/soldier

/datum/outfit/job/roguetown/blusoldier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/stabard/guard/bluey
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	neck = /obj/item/clothing/neck/roguetown/gorget
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/quiver/bullets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	if(prob(70))
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/bayo
	else
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", 1)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)