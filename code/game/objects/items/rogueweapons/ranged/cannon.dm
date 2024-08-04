// immovable cannons. no hand cannons, sorry. (jk)

/obj/structure/cannon
	name = "barkstone"
	desc = "A large weapon mainly hoisted on warships."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "cannona"
	anchored = FALSE
	density = TRUE
	drag_slowdown = 2
	density = FALSE // a 2x2 tile hitbox would be hell
	w_class = WEIGHT_CLASS_GIGANTIC // INSTANTLY crushed
	var/obj/item/ammo_casing/caseless/rogue/cball/loaded

/obj/structure/cannon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_casing/caseless/rogue/cball))
		user.visible_message("<span class='notice'>\The [user] begins loading \the [I] into \the [src].</span>")
		if(!do_after(user, 5 SECONDS, TRUE, src))
			return
		I.forceMove(src)
		loaded = I
		user.visible_message("<span class='notice'>\The [user] loads \the [I] into \the [src].</span>")
	if(istype(I, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/LR = I
		if(!loaded)
			return
		if(LR.on)
			playsound(src.loc, 'sound/items/firelight.ogg', 100)
			user.visible_message("<span class='danger'>\The [user] lights \the [src]!</span>")
			fire(user)
	else
		return ..()

/obj/structure/cannon/proc/fire(var/mob/firer)
	for(var/mob/living/carbon/H in hearers(7, src))
		shake_camera(H, 6, 5)
		H.blur_eyes(4)
	for(var/mob/living/carbon/human/H in get_step(src, turn(dir, 180)))
		var/turf/turfa = get_ranged_target_turf(src, turn(dir, 180), 5)
		H.throw_at(turfa, 5, 1, null, FALSE)
		H.take_overall_damage(45)
		visible_message("<span class='danger'>\The [H] is thrown back from \the [src]'s recoil!</span>")
	flick("cannona_fire", src)
	loaded.fire_casing(get_step(src, dir), firer, null, null, null, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), 0,  src)
	loaded = null
	SSticker.musketsshot++ // ????
	playsound(src.loc, 'sound/misc/explode/explosion.ogg', 100, FALSE)
	sleep(2)
	new /obj/effect/particle_effect/smoke(get_turf(src))