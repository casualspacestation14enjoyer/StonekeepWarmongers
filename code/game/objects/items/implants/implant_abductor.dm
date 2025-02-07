/obj/item/implant/abductor
	name = "recall implant"
	desc = ""
	icon = 'icons/obj/abductor.dmi'
	icon_state = "implant"
	activated = 1
	var/obj/machinery/abductor/pad/home
	var/cooldown = 1 SECONDS
	var/on_cooldown

/obj/item/implant/abductor/activate()
	. = ..()
	if(on_cooldown)
		to_chat(imp_in, "<span class='warning'>I must wait [timeleft(on_cooldown)*0.1] seconds to use [src] again!</span>")
		return
	/*
	home.Retrieve(imp_in,1)
	on_cooldown = addtimer(VARSET_CALLBACK(src, on_cooldown, null), cooldown)
	*/

	new /obj/effect/temp_visual/dir_setting/ninja(get_turf(imp_in), imp_in.dir)
	for(var/obj/effect/landmark/abductor/LM in GLOB.landmarks_list)
		imp_in.forceMove(LM.loc)
		if(imp_in.pulling)
			new /obj/effect/temp_visual/dir_setting/ninja(get_turf(imp_in.pulling), imp_in.pulling.dir)
			imp_in.pulling.forceMove(LM.loc)
		break

/obj/item/implant/abductor/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	if(..())
		var/obj/machinery/abductor/console/console
		if(ishuman(target))
			var/datum/antagonist/abductor/A = target.mind.has_antag_datum(/datum/antagonist/abductor)
			if(A)
				console = get_abductor_console(A.team.team_number)
				home = console.pad

		if(!home)
			var/list/consoles = list()
			for(var/obj/machinery/abductor/console/C in GLOB.machines)
				consoles += C
			console = pick(consoles)
			home = console.pad
		return TRUE
