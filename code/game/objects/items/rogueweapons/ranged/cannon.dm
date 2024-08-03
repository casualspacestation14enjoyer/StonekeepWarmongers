// immovable cannons. no hand cannons, sorry. (jk)

/obj/structure/cannon
	name = "barkstone"
	desc = "A large weapon mainly hoisted on warships."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "cannon"
	anchored = FALSE
	density = FALSE // a 2x2 tile hitbox would be hell
	w_class = WEIGHT_CLASS_GIGANTIC // INSTANTLY crushed
	var/obj/item/ammo_casing/caseless/rogue/cball/loaded
	var/firing = FALSE

/obj/structure/cannon/attackby(obj/item/I, mob/user, params)
	if(firing)
		return ..()
	if(istype(I, /obj/item/ammo_casing/caseless/rogue/cball))
		if(!do_after(user, 5 SECONDS, TRUE, src))
			return
		I.forceMove(src)
		loaded = I
		user.visible_message("<span class='notice'>\The [user] loads \the [I] into \the [src].</span>")
	if(istype(I, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/LR = I
		if(LR.on)
			playsound(src.loc, 'sound/items/firelight.ogg', 100)
			user.visible_message("<span class='danger'>\The [user] lights \the [src]!</span>")
			fire()
	else
		return ..()

/obj/structure/cannon/proc/fire()
	firing = TRUE
	loaded.fire_casing(get_step(src, dir), src, null, null, null, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), 0,  src)
	loaded = null
	new /obj/effect/particle_effect/smoke(get_turf(src))
	SSticker.musketsshot++ // ????
	playsound(src.loc, 'sound/misc/explode/explosion.ogg', 100, FALSE)
	firing = FALSE