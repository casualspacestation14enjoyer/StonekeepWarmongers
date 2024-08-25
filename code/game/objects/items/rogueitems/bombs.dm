
/obj/item/bomb
	name = "bottle bomb"
	desc = "Dangerous explosion, in a bottle."
	icon_state = "bbomb"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	//dropshrink = 0
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	var/light_impact = 4
	var/flame_impact = 1
	var/fuze = 50
	var/lit = FALSE
	var/prob2fail = 5

/obj/item/bomb/smoke
	name = "smoke bomb"
	desc = "Smoke, in a sphere. You're not quite sure how this one works."
	icon_state = "smoke_bomb"
	fuze = 25
	light_impact = 0
	flame_impact = 0

/obj/item/bomb/smoke/process()
	. = ..()
	STOP_PROCESSING(SSfastprocess, src)
	return

/obj/item/bomb/smoke/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		var/datum/effect_system/smoke_spread/smoke = new
		smoke.set_up(4, src)
		smoke.start()
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		qdel(smoke)
	qdel(src)

/*
/obj/item/bomb/dropped(mob/user, silent)
	. = ..()
	if(lit)
		explode() 
*/

/obj/item/bomb/fire
	name = "fire bomb"
	desc = "Dangerous fire in a ceramic coating."
	icon_state = "firebomb"
	light_impact = 2
	flame_impact = 4

/obj/item/bomb/fire/weak
	name = "cheap fire bomb"
	flame_impact = 3

/obj/item/bomb/homemade
	prob2fail = 30

/obj/item/bomb/homemade/Initialize()
	. = ..()
	fuze = rand(20, 50)

/obj/item/bomb/spark_act()
	light()

/obj/item/bomb/fire_act()
	light()

/obj/item/bomb/ex_act()
	if(!QDELETED(src))
		lit = TRUE
		explode(TRUE)

/obj/item/bomb/proc/light()
	if(!lit)
		START_PROCESSING(SSfastprocess, src)
		icon_state = "bbomb-lit"
		lit = TRUE
		playsound(src.loc, 'sound/items/firelight.ogg', 100)
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/bomb/extinguish()
	snuff()

/obj/item/bomb/proc/snuff()
	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSfastprocess, src)
		playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
		icon_state = "bbomb"
		if(ismob(loc))
			var/mob/M = loc
			M.update_inv_hands()

/obj/item/bomb/proc/explode(skipprob)
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		if(lit)
			if(!skipprob && prob(prob2fail))
				snuff()
			else
				explosion(T, light_impact_range = light_impact, flame_range = flame_impact, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
		else
			if(prob(prob2fail))
				snuff()
			else
				playsound(T, 'sound/items/firesnuff.ogg', 100)
				new /obj/item/shard (T)
	qdel(src)

/obj/item/bomb/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	explode()

/obj/item/bomb/process()
	fuze--
	if(fuze <= 0)
		explode(TRUE)