/obj/item/cranker
	name = "CRANKeR"
	desc = "A strange skull-shaped medical device used to grind up bodyparts to make a liquid capable of healing all sorts of injuries. Rumored to be enchanted by Pestra themselves."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "cranker"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	var/open = FALSE
	var/obj/item/bodypart/bp // bodypart to grind
	var/obj/item/reagent_containers/glass/bottle/rogue/pot // where to put the health potion

/obj/item/cranker/update_icon()
	. = ..()
	if(open)
		icon_state = "cranker-open"
	else
		icon_state = "cranker"

/obj/item/cranker/MiddleClick(mob/user, params)
	. = ..()
	if(user.mind.get_skill_level(/datum/skill/misc/medicine) <= 1)
		to_chat(user, "<span class='warning'>I don't know how to use this.</span>")
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(open && pot)
		to_chat(user, "<span class='info'>I unscrew \the [pot] from the [src].</span>")
		playsound(get_turf(user), 'sound/foley/grab.ogg', 100, FALSE, -2)
		H.put_in_hands(pot)
		pot = null
		return
	if(ishuman(user))
		open = !open
		update_icon()
		playsound(get_turf(user), 'sound/foley/struggle.ogg', 100, FALSE, -2)
		return

/obj/item/cranker/attack_right(mob/user)
	. = ..()
	if(user.mind.get_skill_level(/datum/skill/misc/medicine) <= 1)
		to_chat(user, "<span class='warning'>I don't know how to use this.</span>")
		return
	if(open)
		to_chat(user, "<span class='danger'>You can't crank the [src] if it's open, you'll spill everything.</span>")
		return
	if(!bp)
		to_chat(user, "<span class='danger'>You can't crank the [src] if there's nothing in it. You wouldn't want to damage the gears, do you?</span>")
		return
	if(!pot)
		to_chat(user, "<span class='danger'>Where's the product gonna go? On the floor? Are you insane wasting this divine gift?</span>")
		return
	playsound(get_turf(user), 'sound/neu/peppermill.ogg', 100, TRUE, -5)
	flick("cranker-cranking", src)
	QDEL_NULL(bp)
	sleep(10)
	playsound(get_turf(user), "wetbreak", 100, TRUE, -5)
	pot.reagents.add_reagent(/datum/reagent/medicine/healthpot, pot.reagents.maximum_volume)
	to_chat(user, "<span class='info'>The product is ready.</span>")
	
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
		playsound(get_turf(user), 'sound/foley/struggle.ogg', 100, FALSE, -2)
		bootle.forceMove(src)
		pot = bootle
		return