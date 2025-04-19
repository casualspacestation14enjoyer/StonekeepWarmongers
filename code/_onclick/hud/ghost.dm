/atom/movable/screen/ghost
	icon = 'icons/mob/screen_ghost.dmi'

/atom/movable/screen/ghost/MouseEntered()
//	flick(icon_state + "_anim", src)
	..()

/atom/movable/screen/ghost/jumptomob
	name = "Jump to mob"
	icon_state = "jumptomob"

/atom/movable/screen/ghost/jumptomob/Click()
	var/mob/dead/observer/G = usr
	G.jumptomob()

/atom/movable/screen/ghost/orbit
	name = "Orbit"
	icon_state = "orbit"

/atom/movable/screen/ghost/orbit/Click()
	var/mob/dead/observer/G = usr
	G.follow()
	
//skull
/atom/movable/screen/ghost/orbit/rogue
	name = "AFTER LIFE"
	icon = 'icons/mob/ghostspin.dmi'
	icon_state = ""
	screen_loc = "WEST-4,SOUTH+6"
	nomouseover = FALSE

/atom/movable/screen/ghost/orbit/rogue/Click(location, control, params)
	var/mob/dead/observer/G = usr
	var/paramslist = params2list(params)
	if(paramslist["right"]) // screen objects don't do the normal Click() stuff so we'll cheat
		if(G.client?.holder)
			G.follow()
	else
		if(G.isinhell)
			return
		if(G.client)
			G.playsound_local(get_turf(G), 'sound/magic/holyshield.ogg', 35)
			animate(src, transform = matrix()*1.5, alpha = 0, time = 5) // looks cool
			var/ttime = 10
			if(aspect_chosen(/datum/round_aspect/drafted))
				to_chat(G, "You will return to combat in 20 seconds.")
				ttime = 20 SECONDS
			spawn(ttime)
				G.returntolobby()

/atom/movable/screen/ghost/reenter_corpse
	name = "Reenter corpse"
	icon_state = "reenter_corpse"

/atom/movable/screen/ghost/reenter_corpse/Click()
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/ghost/teleport
	name = "Teleport"
	icon_state = "teleport"

/atom/movable/screen/ghost/teleport/Click()
	var/mob/dead/observer/G = usr
	G.dead_tele()

/atom/movable/screen/ghost/pai
	name = "pAI Candidate"
	icon_state = "pai"

/atom/movable/screen/ghost/pai/Click()
	var/mob/dead/observer/G = usr
	G.register_pai()

/datum/hud/ghost/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using =  new /atom/movable/screen/backhudl/ghost()
	using.hud = src
	static_inventory += using

	scannies = new /atom/movable/screen/scannies
	scannies.hud = src
	static_inventory += scannies
	scannies.alpha = 130

	using = new /atom/movable/screen/ghost/orbit/rogue()
	using.hud = src
	static_inventory += using

/datum/hud/ghost/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else
		screenmob.client.screen += static_inventory

/datum/hud/eye/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using =  new /atom/movable/screen/backhudl/ghost()
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/grain
	using.hud = src
	static_inventory += using

	scannies = new /atom/movable/screen/scannies
	scannies.hud = src
	static_inventory += scannies
	scannies.alpha = 130

/datum/hud/eye/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client.prefs.ghost_hud)
		screenmob.client.screen -= static_inventory
	else
		screenmob.client.screen += static_inventory

/datum/hud/obs/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using =  new /atom/movable/screen/backhudl/obs()
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/grain
	using.hud = src
	static_inventory += using

	scannies = new /atom/movable/screen/scannies
	scannies.hud = src
	static_inventory += scannies
	scannies.alpha = 130
