//Fluff structures serve no purpose and exist only for enriching the environment. They can be destroyed with a wrench.

/obj/structure/well
	name = "well"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "well"
	anchored = TRUE
	density = TRUE
	opacity = 0
	climb_time = 40
	climbable = TRUE
	layer = 2.91
	damage_deflection = 30

/obj/structure/well/fountain
	name = "water fountain"
	desc = ""
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "fountain"
	bound_width = 64
	layer = ABOVE_MOB_LAYER
	plane = -1 // so people are actually BEHIND the fucking fountain because if we dont have this theyre drawn on top

/obj/structure/well/fountain/bloody
	name = "blood fountain"
	icon_state = "fountain-b"

/obj/structure/well/fountain/bloody/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bucket/wooden))
		var/obj/item/reagent_containers/glass/bucket/wooden/W = I
		if(W.reagents.holder_full())
			to_chat(user, "<span class='warning'>[W] is full.</span>")
			return
		if(do_after(user, 60, target = src))
			var/list/waterl = list(/datum/reagent/blood = 100)
			W.reagents.add_reagent_list(waterl)
			to_chat(user, "<span class='notice'>I fill [W] from [src].</span>")
			return
	else ..()

/obj/structure/well/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bucket/wooden))
		var/obj/item/reagent_containers/glass/bucket/wooden/W = I
		if(W.reagents.holder_full())
			to_chat(user, "<span class='warning'>[W] is full.</span>")
			return
		if(do_after(user, 60, target = src))
			var/list/waterl = list(/datum/reagent/water = 100)
			W.reagents.add_reagent_list(waterl)
			to_chat(user, "<span class='notice'>I fill [W] from [src].</span>")
			return
	else ..()