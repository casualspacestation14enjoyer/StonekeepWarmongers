#define BLUE_WARTEAM "Grenzelhofts" // Grenzelhoft
#define RED_WARTEAM "Heartfelts" // Heartfelt

/datum/game_mode/warfare
	name = "warmode"
	config_tag = "warmode"
	report_type = "warmode"
	false_report_weight = 0
	required_players = 0
	required_enemies = 0
	recommended_enemies = 0
	enemy_minimum_age = 0

	var/whowon = null // use RED_WARTEAM and BLUE_WARTEAM
	var/mob/living/carbon/human/crownbearer = null

	var/reinforcementwave = 1 // max 5

	var/mob/redlord = null
	var/mob/blulord = null

	var/list/heartfelts = list() // clients
	var/list/grenzels = list()

	var/warfare_start_time = 5 // in minutes
	var/warfare_reinforcement_time = 5 // in minutes

	announce_span = "danger"
	announce_text = "The"

/datum/game_mode/warfare/post_setup(report)
	. = ..()
	begin_countDown()
	reinforcements()

/datum/game_mode/warfare/proc/reinforcements()
	if(!(reinforcementwave >= 5))
		if(!SSticker.warfare_ready_to_die)
			reinforcements()
			return
		spawn(warfare_reinforcement_time MINUTES)
			SSticker.SendReinforcements()
			reinforcements()
	return

/datum/game_mode/warfare/proc/begin_countDown()
	if(SSticker.warfare_ready_to_die)
		return
	spawn(warfare_start_time MINUTES)
		if(redlord == null)
			to_chat(world, "We are waiting for the lord of Heartfelt to arrive.")
			begin_countDown()
			return
		if(blulord == null)
			to_chat(world, "We are waiting for the lord of Grenzelhoft to arrive.")
			begin_countDown()
			return
		SSticker.ReadyToDie()