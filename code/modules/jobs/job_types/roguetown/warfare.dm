/datum/job/roguetown/warfare/red
	warfare_faction = RED_WARTEAM
	selection_color = CLOTHING_RED

/datum/job/roguetown/warfare/red/lord
	title = "Heartfelt Lord"
	tutorial = "todo"
	department_flag = REDSS
	flag = REDKING
	total_positions = 1
	spawn_positions = 1
	faction = "Station"
	outfit = null
	allowed_races = list(
		"Humen"
	)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)

/datum/outfit/job/roguetown/redking
	name = "Heartfelt Lord"
	jobtype = /datum/job/roguetown/warfare/red/lord

/datum/outfit/job/roguetown/redking/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	neck = /obj/item/clothing/neck/roguetown/gorget
	head = /obj/item/clothing/head/roguetown/crownred
	shoes = /obj/item/clothing/shoes/roguetown/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/cloak/heartfelt
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt/lord
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol
	beltl = /obj/item/quiver/bullets
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 4, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("intelligence", 3)
		H.change_stat("endurance", 3)
		H.change_stat("speed", 1)
		H.change_stat("perception", 2)

/datum/job/roguetown/warfare/red/soldier
	title = "Heartfelt Infantry"
	tutorial = "You're treated like shit. The run of the litter, garbage men and beggars drafted into yet another inresolvable conflict. But if you risk your life and get out of this mess, maybe you'll get a better life when you got back. At least the pay is good, but what use is it when a ball of lead is enough to put you back into your place?"
	department_flag = REDSS
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
	department_flag = BLUES
	flag = BLUKING
	total_positions = 1
	spawn_positions = 1
	faction = "Station"
	outfit = /datum/outfit/job/roguetown/bluking

/datum/outfit/job/roguetown/bluking
	name = "Grenzelhoft Lord"
	jobtype = /datum/job/roguetown/warfare/blu/lord

/datum/outfit/job/roguetown/bluking/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	neck = /obj/item/clothing/neck/roguetown/gorget
	head = /obj/item/clothing/head/roguetown/crownblu
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/cloak/lordcloak
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol
	beltl = /obj/item/quiver/bullets
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 4, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("intelligence", 3)
		H.change_stat("endurance", 3)
		H.change_stat("speed", 1)
		H.change_stat("perception", 2)

/datum/job/roguetown/warfare/blu/soldier
    title = "Grenzelhoft Infantry"
    tutorial = "You're treated like shit. The run of the litter, garbage men and beggars drafted into yet another inresolvable conflict. But if you risk your life and get out of this mess, maybe you'll get a better life when you got back. At least the pay is good, but what use is it when a ball of lead is enough to put you back into your place?"
    department_flag = BLUES
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