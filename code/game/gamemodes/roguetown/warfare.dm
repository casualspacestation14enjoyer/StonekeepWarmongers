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
	var/obj/item/redcrown = null
	var/red_bonus = 2 // reinforcement points

	var/mob/blulord = null
	var/obj/item/blucrown = null
	var/blu_bonus = 2 // reinforcement points

	var/list/heartfelts = list() // clients
	var/list/grenzels = list()

	var/warfare_start_time = 5 // in minutes
	var/warfare_reinforcement_time = 5 // in minutes
	
	var/stalematecooldown // a cooldown before another stalemate can be held
	
	var/warmode = null

	announce_span = "danger"
	announce_text = "The"

/datum/game_mode/warfare/post_setup(report)
	begin_countDown()
	return ..()

/datum/game_mode/warfare/proc/award_triumphs()
	if(whowon == BLUE_WARTEAM)
		for(var/client/C in grenzels)
			if(ishuman(C.mob))
				var/mob/living/carbon/human/H = C.mob
				H.adjust_triumphs(1)
	if(whowon == RED_WARTEAM)
		for(var/client/C in heartfelts)
			if(ishuman(C.mob))
				var/mob/living/carbon/human/H = C.mob
				H.adjust_triumphs(1)

/datum/game_mode/warfare/proc/do_war_end(var/mob/living/carbon/human/crownguy = null, var/team = null) // if you call this with zero arguments, its a stalemate.
	whowon = team
	SSticker.force_ending = TRUE
	if(crownguy)
		crownbearer = crownguy
		crownguy.adjust_triumphs(5)

/datum/game_mode/warfare/proc/begin_autobalance_loop()
	set waitfor = 0
	while(1)
		CHECK_TICK
		if(SSticker.oneteammode)
			break
		CHECK_TICK
		for(var/mob/dead/new_player/P in GLOB.player_list)
			CHECK_TICK
			P.autobalance()

/datum/game_mode/warfare/proc/reinforcements()
	set waitfor = 0
	while(1)
		CHECK_TICK
		if((reinforcementwave >= 5))
			break
		sleep(warfare_reinforcement_time MINUTES)
		testing("Sending reinforcement loop works")
		SSticker.SendReinforcements()

/datum/game_mode/warfare/proc/begin_countDown()
	set waitfor = 0
	while(1)
		sleep(1 MINUTES)
		CHECK_TICK
		if(SSticker.warfare_ready_to_die)
			break
		if(!redlord)
			continue
		CHECK_TICK
		if(!blulord)
			continue
		CHECK_TICK
		to_chat(world, "Both sides are present. We will begin in [warfare_start_time] minutes.")
		sleep(warfare_start_time MINUTES)
		SSticker.ReadyToDie()
		CHECK_TICK