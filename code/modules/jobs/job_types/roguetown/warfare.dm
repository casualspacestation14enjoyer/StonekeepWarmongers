// HEARTFELT

/datum/job/roguetown/warfare/red
    warfare_faction = RED_WARTEAM

/datum/job/roguetown/warfare/red/soldier
    title = "Heartfelt Infantry"
    tutorial = "You're treated like shit. The run of the litter, garbage men and beggars drafted into yet another inresolvable conflict. But if you risk your life and get out of this mess, maybe you'll get a better life when you got back. At least the pay is good, but what use is it when a ball of lead is enough to put you back into your place?"
    department_flag = PEASANTS
    flag = SOLDIER
    total_positions = -1
    spawn_positions = 10
    faction = "Station"
    outfit = /datum/outfit/job/roguetown/redsoldier
    allowed_races = list(
		"Humen",
		"Elf",
		"Dwarf",
		"Half-Elf",
		"Tiefling",
		"Dark Elf",
		"Aasimar"
	)
    allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)

/datum/outfit/job/roguetown/redsoldier
	name = "Heartfelt Soldier"

/datum/outfit/job/roguetown/redsoldier/pre_equip(mob/living/carbon/human/H, visualsOnly)
    . = ..()
    