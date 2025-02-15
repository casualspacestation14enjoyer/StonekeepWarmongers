/obj/item/cranker
	name = "CRANKeR"
	desc = "A strange skull-shaped medical device used to grind up bodyparts to make all sorts of things."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "cranker"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	var/obj/item/bodypart/bp // bodypart to grind
	var/datum/reagent/chosen_potion = /datum/reagent/medicine/healthpot
	var/obj/item/reagent_containers/glass/bottle/rogue/pot // where to put the health potion

/obj/item/cranker/ShiftMiddleClick(mob/user, params)
	. = ..()
	// todo: tutorial for this bitch. doo the same thing with muskets to replace the HELP verb

/obj/item/cranker/MiddleClick(mob/user, params)
	. = ..()
	if(user.mind.get_skill_level(/datum/skill/misc/medicine) <= 1)
		to_chat(user, "<span class='warning'>I don't know how to use this.</span>")
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(pot)
		to_chat(user, "<span class='info'>I unscrew \the [pot] from the [src].</span>")
		playsound(get_turf(user), 'sound/foley/grab.ogg', 100, FALSE, -2)
		H.put_in_hands(pot)
		pot = null
		return

/obj/item/cranker/attack_right(mob/user)
	. = ..()
	var/chosen = input(user, "What are we cooking today?", "WARMONGERS") as null|anything in list("HEALTH","DUST OF MOON","OZ","LOVE")
	if(!chosen)
		return
	switch(chosen)
		if("HEALTH")
			chosen_potion = /datum/reagent/medicine/healthpot
			to_chat(user, "<span class='info'>People will love you, but they will all know you're just a little too boring.</span>")
		if("DUST OF MOON")
			chosen_potion = /datum/reagent/moondust
			to_chat(user, "<span class='info'>After all, you didn't want those bullets piercing your lungs anyway.</span>")
		if("OZ")
			chosen_potion = /datum/reagent/ozium
			to_chat(user, "<span class='info'>Everyone loves it, who doesn't? You'll be unbeatable.</span>")
		if("LOVE")
			chosen_potion = /datum/reagent/druqks
			to_chat(user, "<span class='info'>Love defeats all hardship.</span>")

/obj/item/cranker/attack_self(mob/living/carbon/human/user)
	. = ..()
	var/datum/game_mode/warfare/C = SSticker.mode
	if(user.mind.get_skill_level(/datum/skill/misc/medicine) <= 1)
		to_chat(user, "<span class='warning'>I don't know how to use this.</span>")
		return
	if(!bp)
		to_chat(user, "<span class='warning'>You can't crank the [src] if there's nothing in it. You wouldn't want to damage the gears, would you?</span>")
		return
	if(!pot)
		to_chat(user, "<span class='warning'>You're gonna need to attach a bottle, otherwise our divine gift will just go to waste.</span>")
		return
	playsound(get_turf(user), 'sound/neu/peppermill.ogg', 100, TRUE, -5)
	flick("cranker-cranking", src)
	QDEL_NULL(bp)
	sleep(10)
	playsound(get_turf(user), "wetbreak", 100, TRUE, -5)
	pot.reagents.add_reagent(chosen_potion, 15)
	to_chat(user, "<span class='info'>The product is ready.</span>")
	switch(user.warfare_faction)
		if(RED_WARTEAM)
			C.red_bonus++
		if(BLUE_WARTEAM)
			C.blu_bonus++
	
/obj/item/cranker/attackby(obj/item/I, mob/user, params)
	if(user.mind.get_skill_level(/datum/skill/misc/medicine) <= 1)
		to_chat(user, "<span class='warning'>I don't know how to use this.</span>")
		return ..()
	if(istype(I, /obj/item/bodypart))
		var/obj/item/bodypart/BI = I
		to_chat(user, "<span class='info'>I put \the [BI] into the [src].</span>")
		playsound(get_turf(user), 'sound/foley/struggle.ogg', 100, FALSE, -2)
		BI.forceMove(src)
		bp = BI
		return
	if(istype(I, /obj/item/reagent_containers/glass/bottle/rogue))
		var/obj/item/reagent_containers/glass/bottle/rogue/bootle = I
		to_chat(user, "<span class='info'>I attach \the [bootle] into the [src].</span>")
		playsound(get_turf(user), 'sound/foley/torchfixtureput.ogg', 100, FALSE, -2)
		bootle.forceMove(src)
		pot = bootle
		return