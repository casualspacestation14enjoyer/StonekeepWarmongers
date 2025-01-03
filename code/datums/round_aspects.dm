/datum/round_aspect
	var/name = "Round Aspect"

	var/description = "Uh oh."

/datum/round_aspect/proc/apply()
	return

/datum/round_aspect/normal
	name = "Nothing!"
	description = "Normality above all."

/datum/round_aspect/futurewar
	name = "The Future of Warfare"
	description = "These levershots are the future!"

/datum/round_aspect/futurewar/apply()
	SSticker.warfare_techlevel = 2

/datum/round_aspect/nomood
	name = "Moodless"
	description = "All soldiers are put through rigorous training to ensure they are emotionless."

/datum/round_aspect/stronglords
	name = "Strong Lords"
	description = "Everyone knows the crown-bearer should be the strongest man in the platoon."

/datum/round_aspect/squishyhumans
	name = "Squishy Soldiers"
	description = "You're coming in terms with yourself, you're not as resilient as you thought."

/datum/round_aspect/exploding
	name = "Explosive Death"
	description = "A terrible curse has descended upon us! If we die we explode!"

/datum/round_aspect/noguns // wow
	name = "Oops! No guns!"
	description = "A terrible logistics disaster caused all of us to be without firearms."

/datum/round_aspect/noguns/apply()
	SSticker.warfare_techlevel = 3
	
/datum/round_aspect/sexmongers
	name = "SEXMONGERS"
	description = "freeky.... Sex is enabled on the battlefield!"

/* People aren't ready for this.
/datum/round_aspect/goblino
	name = "It's all goblins"
	description = "The Lords accidentally recruited goblins instead of humens."
*/

/datum/round_aspect/starvingmarvins
	name = "Starvin' Marvins"
	description = "Sadly, it's like old WARMONGERS all over again! Everyone is hungry and thirsty at the start of the round!"

/datum/round_aspect/cripplefight
	name = "Cripple Fight"
	description = "Sadly, due to a previous skirmish everyone has their legs crippled. Thankfully we have been provided with wheelchairs!"

/datum/round_aspect/supplypoints
	name = "Favors in the Right Places"
	description = "Because the Lords both have favors to the Quartermaster of Enigma, they both get five supply points on the start of the battle."

/datum/round_aspect/supplypoints/apply()
	var/datum/game_mode/warfare/W = SSticker.mode
	W.blu_bonus = 5
	W.red_bonus = 5