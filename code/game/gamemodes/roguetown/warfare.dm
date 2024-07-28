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
	var/crownbearer = "John Roguetown"

	var/list/heartfelts = list() // clients
	var/list/grenzels = list()

	var/warfare_start_time = 5 // in minutes

	announce_span = "danger"
	announce_text = "The"

/datum/game_mode/warfare/post_setup(report)
	. = ..()
	begin_countDown()
	
/datum/game_mode/warfare/proc/begin_countDown()
	spawn(warfare_start_time MINUTES)
		SSticker.ReadyToDie()