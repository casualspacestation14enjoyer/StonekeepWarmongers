/datum/warshippable
	var/name = "shippable"
	var/list/items = list()
	var/reinforcement = 1 // on what wave this becomes available on

/datum/warshippable/smokebombs
	name = "FIVE SMOKE BOMBS"
	items = list(/obj/item/bomb/smoke,
			/obj/item/bomb/smoke,
			/obj/item/bomb/smoke,
			/obj/item/bomb/smoke,
			/obj/item/bomb/smoke
			)

/datum/warshippable/gasbombs
	name = "FOUR GAS BOMBS"
	items = list(/obj/item/bomb/poison,
			/obj/item/bomb/poison,
			/obj/item/bomb/poison,
			/obj/item/bomb/poison
			)

/datum/warshippable/bombs
	name = "FIVE BOMBS"
	items = list(/obj/item/bomb,
			/obj/item/bomb,
			/obj/item/bomb,
			/obj/item/bomb,
			/obj/item/bomb
			)

/datum/warshippable/crownpointer
	name = "CROWN POINTER"
	items = list(/obj/item/pinpointer/crown)

/datum/warshippable/firebombs
	name = "THREE FIRE BOMBS"
	items = list(/obj/item/bomb/fire,
			/obj/item/bomb/fire,
			/obj/item/bomb/fire
			)

/datum/warshippable/woodammo
	name = "WOODEN BALL POUCHES"
	items = list(/obj/item/quiver/woodbullets,
			/obj/item/quiver/woodbullets
			)

/datum/warshippable/normalammo
	name = "LEAD BALL POUCHES"
	items = list(/obj/item/quiver/bullets,
			/obj/item/quiver/bullets
			)

/datum/warshippable/cannonballs
	name = "LARGE LEAD BALLS"
	items = list(/obj/item/ammo_casing/caseless/rogue/cball,
			/obj/item/ammo_casing/caseless/rogue/cball,
			/obj/item/ammo_casing/caseless/rogue/cball,
			/obj/item/ammo_casing/caseless/rogue/cball
			)

/datum/warshippable/bombard
	name = "BOMBARDIER"
	items = list(/obj/structure/bombard)

/datum/warshippable/caltrops
	name = "TETSUBISHI CALTROPS"
	items = list(/obj/item/rogue/caltrop,
			/obj/item/rogue/caltrop,
			/obj/item/rogue/caltrop
			)

/datum/warshippable/explodabarrel
	name = "EXPLODABARRELS"
	items = list(/obj/structure/fluff/explodabarrel,
			/obj/structure/fluff/explodabarrel,
			/obj/structure/fluff/explodabarrel,
			/obj/structure/fluff/explodabarrel,
			/obj/structure/fluff/explodabarrel
			)