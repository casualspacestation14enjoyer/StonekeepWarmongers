// immovable cannons. no hand cannons, sorry. (jk)

/obj/structure/cannon // cannon
	name = "barkstone"
	desc = "A large weapon mainly hoisted on warships."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "cannona"
	anchored = FALSE
	density = TRUE
	max_integrity = 9999
	drag_slowdown = 1 // If it took so long it would be not really fun.
	w_class = WEIGHT_CLASS_GIGANTIC // INSTANTLY crushed
	var/obj/item/ammo_casing/caseless/rogue/cball/loaded

/obj/structure/cannon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_casing/caseless/rogue/cball))
		if(loaded)
			return
		user.visible_message("<span class='notice'>\The [user] begins loading \the [I] into \the [src].</span>")
		playsound(src, 'sound/combat/cannon_loading.ogg', 35)
		if(!do_after(user, 5 SECONDS, TRUE, src))
			return
		I.forceMove(src)
		loaded = I
		user.visible_message("<span class='notice'>\The [user] loads \the [I] into \the [src].</span>")
		playsound(src, 'sound/foley/trap_arm.ogg', 65)
	if(istype(I, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/LR = I
		if(!loaded)
			return
		if(LR.on)
			playsound(src.loc, 'sound/items/firelight.ogg', 100)
			user.visible_message("<span class='danger'>\The [user] lights \the [src]!</span>")
			fire()
	else
		return ..()

/obj/structure/cannon/fire_act(added, maxstacks)
	if(!loaded)
		return
	playsound(src.loc, 'sound/items/firelight.ogg', 100)
	fire()

/obj/structure/cannon/spark_act()
	if(!loaded)
		return
	playsound(src.loc, 'sound/items/firelight.ogg', 100)
	fire()

/obj/structure/cannon/proc/fire()
	for(var/mob/living/carbon/H in hearers(7, src))
		shake_camera(H, 6, 5)
		H.blur_eyes(4)
		if(prob(30))
			H.playsound_local(get_turf(H), 'sound/foley/tinnitus.ogg', 45, FALSE)
	for(var/mob/living/carbon/human/H in get_step(src, turn(dir, 180)))
		var/turf/turfa = get_ranged_target_turf(src, turn(dir, 180), 2)
		H.throw_at(turfa, 4, 1, null, FALSE)
		H.take_overall_damage(45)
		visible_message("<span class='danger'>\The [H] is thrown back from \the [src]'s recoil!</span>")
	flick("cannona_fire", src)
	if(!loaded)
		return
	var/obj/projectile/fired_projectile = new loaded.projectile_type(get_turf(src))
	fired_projectile.firer = src
	fired_projectile.fired_from = src
	fired_projectile.fire(dir2angle(dir))
	QDEL_NULL(loaded)
	SSticker.musketsshot++ // ????
	playsound(src.loc, 'sound/misc/explode/explosion.ogg', 100, FALSE)
	sleep(4)
	new /obj/effect/particle_effect/smoke(get_turf(src))

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/handcannon // for the memes
	name = "hand barkstone"
	desc = "HOLY FUCK!"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "cannona"
	fire_sound = 'sound/misc/explode/explosion.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/shot/musk/cannona
	dropshrink = 0.5

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/handcannon/update_icon()
	icon_state = "cannona"

/obj/item/ammo_box/magazine/internal/shot/musk/cannona
	ammo_type = /obj/item/ammo_casing/caseless/rogue/cball
	caliber = "cannoball"
	max_ammo = 1
	start_empty = TRUE

// artillery (fucking OP)

/obj/structure/bombard
	name = "bombardier"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "cannona" // placeholder
	anchored = FALSE
	density = TRUE
	max_integrity = 9999
	drag_slowdown = 1 // If it took so long it would be not really fun.
	w_class = WEIGHT_CLASS_GIGANTIC // INSTANTLY crushed
	var/plusy = 0
	var/obj/item/ammo_casing/caseless/rogue/cball/loaded

/obj/structure/bombard/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_casing/caseless/rogue/cball))
		if(loaded)
			return
		user.visible_message("<span class='notice'>\The [user] begins loading \the [I] into \the [src].</span>")
		playsound(src, 'sound/combat/cannon_loading.ogg', 35)
		if(!do_after(user, 5 SECONDS, TRUE, src))
			return
		I.forceMove(src)
		loaded = I
		user.visible_message("<span class='notice'>\The [user] loads \the [I] into \the [src].</span>")
		playsound(src, 'sound/foley/trap_arm.ogg', 65)
	if(istype(I, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/LR = I
		if(!loaded)
			return
		if(LR.on)
			playsound(src.loc, 'sound/items/firelight.ogg', 100)
			user.visible_message("<span class='danger'>\The [user] lights \the [src]!</span>")
			fire()
	else
		return ..()

/obj/structure/bombard/proc/fire()
	for(var/mob/living/carbon/H in hearers(7, src))
		shake_camera(H, 6, 5)
		H.blur_eyes(4)
		if(prob(30))
			H.playsound_local(get_turf(H), 'sound/foley/tinnitus.ogg', 45, FALSE)
	for(var/mob/living/carbon/human/H in get_step(src, turn(dir, 180)))
		var/turf/turfa = get_ranged_target_turf(src, turn(dir, 180), 2)
		H.throw_at(turfa, 3, 1, null, FALSE)
		H.take_overall_damage(45)
		visible_message("<span class='danger'>\The [H] is thrown back from \the [src]'s recoil!</span>")
	flick("cannona_fire", src)
	if(!loaded)
		return
	QDEL_NULL(loaded)
	SSticker.musketsshot++ // ????

	var/oldy = y
	var/newy = oldy + plusy

	var/turf/epicenter = locate(x,newy,z)
	var/obj/effect/warning/G = new(epicenter)

	spawn(5 SECONDS)
		qdel(G)
		explosion(epicenter, heavy_impact_range = 2, light_impact_range = 4, smoke = TRUE, soundin = pick('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg'))

	playsound(src.loc, 'sound/misc/explode/explosion.ogg', 100, FALSE)
	sleep(4)
	new /obj/effect/particle_effect/smoke(get_turf(src))