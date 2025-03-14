//Pinpointers are used to track atoms from a distance as long as they're on the same z-level. The captain and nuke ops have ones that track the nuclear authentication disk.
/obj/item/pinpointer
	name = "pinpointer"
	desc = ""
	icon = 'icons/obj/device.dmi'
	icon_state = "pinpointer"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	throw_speed = 1
	throw_range = 7
	custom_materials = list(/datum/material/iron = 500, /datum/material/glass = 250)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/active = FALSE
	var/atom/movable/target //The thing we're searching for
	var/minimum_range = 0 //at what range the pinpointer declares you to be at my destination
	var/ignore_suit_sensor_level = FALSE // Do we find people even if their suit sensors are turned off
	var/alert = FALSE // TRUE to display things more seriously
	var/process_scan = TRUE // some pinpointers change target every time they scan, which means we can't have it change very process but instead when it turns on.
	var/icon_suffix = "" // for special pinpointer icons

/obj/item/pinpointer/Initialize()
	. = ..()
	GLOB.pinpointer_list += src

/obj/item/pinpointer/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	GLOB.pinpointer_list -= src
	target = null
	return ..()

/obj/item/pinpointer/attack_self(mob/living/user)
	if(!process_scan) //since it's not scanning on process, it scans here.
		scan_for_target()
	toggle_on()
	user.visible_message("<span class='notice'>[user] [active ? "" : "de"]activates [user.p_their()] pinpointer.</span>", "<span class='notice'>I [active ? "" : "de"]activate my pinpointer.</span>")

/obj/item/pinpointer/proc/toggle_on()
	active = !active
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	if(active)
		START_PROCESSING(SSfastprocess, src)
	else
		target = null
		STOP_PROCESSING(SSfastprocess, src)
	update_icon()

/obj/item/pinpointer/process()
	if(!active)
		return PROCESS_KILL
	if(process_scan)
		scan_for_target()
	update_icon()

/obj/item/pinpointer/proc/scan_for_target()
	return

/obj/item/pinpointer/update_icon()
	cut_overlays()
	if(!active)
		return
	if(!target)
		add_overlay("pinon[alert ? "alert" : ""]null[icon_suffix]")
		return
	var/turf/here = get_turf(src)
	var/turf/there = get_turf(target)
	if(here.z != there.z)
		add_overlay("pinon[alert ? "alert" : ""]null[icon_suffix]")
		return
	if(get_dist_euclidian(here,there) <= minimum_range)
		add_overlay("pinon[alert ? "alert" : ""]direct[icon_suffix]")
	else
		setDir(get_dir(here, there))
		switch(get_dist(here, there))
			if(1 to 8)
				add_overlay("pinon[alert ? "alert" : "close"][icon_suffix]")
			if(9 to 16)
				add_overlay("pinon[alert ? "alert" : "medium"][icon_suffix]")
			if(16 to INFINITY)
				add_overlay("pinon[alert ? "alert" : "far"][icon_suffix]")

/obj/item/pinpointer/crew // A replacement for the old crew monitoring consoles
	name = "crew pinpointer"
	desc = ""
	icon_state = "pinpointer_crew"
	custom_price = 150
	var/has_owner = FALSE
	var/pinpointer_owner = null

/obj/item/pinpointer/crew/proc/trackable(mob/living/carbon/human/H)
	var/turf/here = get_turf(src)
	if((H.z == 0 || H.z == here.z) && istype(H.wear_pants, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = H.wear_pants

		// Suit sensors must be on maximum.
		if(!U.has_sensor || (U.sensor_mode < SENSOR_COORDS && !ignore_suit_sensor_level))
			return FALSE

		var/turf/there = get_turf(H)
		return (H.z != 0 || (there && there.z == here.z))

	return FALSE

/obj/item/pinpointer/crew/attack_self(mob/living/user)
	if(active)
		toggle_on()
		user.visible_message("<span class='notice'>[user] deactivates [user.p_their()] pinpointer.</span>", "<span class='notice'>I deactivate my pinpointer.</span>")
		return

	if (has_owner && !pinpointer_owner)
		pinpointer_owner = user

	if (pinpointer_owner && pinpointer_owner != user)
		to_chat(user, "<span class='notice'>The pinpointer doesn't respond. It seems to only recognise its owner.</span>")
		return

	var/list/name_counts = list()
	var/list/names = list()

	for(var/i in GLOB.human_list)
		var/mob/living/carbon/human/H = i
		if(!trackable(H))
			continue

		var/crewmember_name = "Unknown"
		if(H.wear_ring)
			var/obj/item/card/id/I = H.wear_ring.GetID()
			if(I && I.registered_name)
				crewmember_name = I.registered_name

		while(crewmember_name in name_counts)
			name_counts[crewmember_name]++
			crewmember_name = text("[] ([])", crewmember_name, name_counts[crewmember_name])
		names[crewmember_name] = H
		name_counts[crewmember_name] = 1

	if(!names.len)
		user.visible_message("<span class='notice'>[user]'s pinpointer fails to detect a signal.</span>", "<span class='notice'>My pinpointer fails to detect a signal.</span>")
		return

	var/A = input(user, "Person to track", "Pinpoint") in sortList(names)
	if(!A || QDELETED(src) || !user || !user.is_holding(src) || user.incapacitated())
		return

	target = names[A]
	toggle_on()
	user.visible_message("<span class='notice'>[user] activates [user.p_their()] pinpointer.</span>", "<span class='notice'>I activate my pinpointer.</span>")

/obj/item/pinpointer/crew/scan_for_target()
	if(target)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(!trackable(H))
				target = null
	if(!target) //target can be set to null from above code, or elsewhere
		active = FALSE


/obj/item/pinpointer/pair
	name = "pair pinpointer"
	desc = ""
	var/other_pair

/obj/item/pinpointer/pair/Destroy()
	other_pair = null
	. = ..()

/obj/item/pinpointer/pair/scan_for_target()
	target = other_pair

/obj/item/pinpointer/pair/examine(mob/user)
	. = ..()
	if(!active || !target)
		return
	var/mob/mob_holder = get(target, /mob)
	if(istype(mob_holder))
		. += "Its pair is being held by [mob_holder]."
		return

/obj/item/storage/box/pinpointer_pairs
	name = "pinpointer pair box"

/obj/item/storage/box/pinpointer_pairs/PopulateContents()
	var/obj/item/pinpointer/pair/A = new(src)
	var/obj/item/pinpointer/pair/B = new(src)

	A.other_pair = B
	B.other_pair = A

/obj/item/pinpointer/crown // todo: FIX (special todo tag: warmongers)
	name = "POINTER"
	desc = "Where do we go? Heed the call of war. It is foolish, it is only able to track the crown if it is on the same elevation."
	icon_state = "crownpointer"
	icon_suffix = "_hunter"
	dropshrink = 0.6
	var/team
	var/obj/crown

/obj/item/pinpointer/crown/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/clothing/head/roguetown/crownblu))
		team = BLUE_WARTEAM
		say("I HAVE ACQUIRED THE SMELL OF THE GRENZELHOFTS. TRACKING HEARTFELT SCUM'S CROWN!")
		crown = locate(/obj/item/clothing/head/roguetown/crownred)
		playsound(src, 'sound/misc/machinetalk.ogg', 50, TRUE)
	if(istype(I, /obj/item/clothing/head/roguetown/crownred))
		team = RED_WARTEAM
		say("I HAVE ACQUIRED THE SMELL OF THE HEARTFELTS. TRACKING GRENZELHOFT SCUM'S CROWN!")
		crown = locate(/obj/item/clothing/head/roguetown/crownblu)
		playsound(src, 'sound/misc/machinetalk.ogg', 50, TRUE)
	scan_for_target()

/obj/item/pinpointer/crown/scan_for_target()
	target = crown

/obj/item/pinpointer/crown/toggle_on()
	if(!team)
		playsound(src, 'sound/misc/machineno.ogg', 50, TRUE)
		say("THERE'S TWO SMELLS OF CROWNS! THIS IS CONFUSING, WHICH ONE DO I TRACK?!")
		return
	playsound(src, 'sound/misc/machinevomit.ogg', 50, TRUE)
	..()

/obj/item/pinpointer/shuttle
	name = "fugitive pinpointer"
	desc = ""
	icon_state = "pinpointer_hunter"
	icon_suffix = "_hunter"
	var/obj/shuttleport

/obj/item/pinpointer/shuttle/Initialize(mapload)
	. = ..()
	shuttleport = SSshuttle.getShuttle("huntership")

/obj/item/pinpointer/shuttle/scan_for_target()
	target = shuttleport

/obj/item/pinpointer/shuttle/Destroy()
	shuttleport = null
	. = ..()
