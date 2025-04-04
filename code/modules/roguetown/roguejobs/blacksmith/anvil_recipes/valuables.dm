/datum/anvil_recipe/valuables
	appro_skill = /datum/skill/craft/blacksmithing

/datum/anvil_recipe/valuables/mintgold
	name = "mint gold coins (10)"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/roguecoin/gold/ten
	
/datum/anvil_recipe/valuables/mintiron
	name = "mint iron coins (10)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/roguecoin/silver/ten

/datum/anvil_recipe/valuables/mintcopper
	name = "mint copper coins (10)"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/roguecoin/copper/ten

/datum/anvil_recipe/valuables/gold
	name = "gold statue"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/roguestatue/gold

/datum/anvil_recipe/valuables/silver
	name = "silver statue"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/roguestatue/silver

/datum/anvil_recipe/valuables/iron
	name = "iron statue"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/roguestatue/iron

/datum/anvil_recipe/valuables/steel
	name = "steel statue"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/roguestatue/steel

/*
/datum/anvil_recipe/valuables/eargol
	name = "gold earrings"
	req_bar = /obj/item/ingot/gold
	created_item = list(/obj/item/rogueacc/eargold,
						/obj/item/rogueacc/eargold,
						/obj/item/rogueacc/eargold)

/datum/anvil_recipe/valuables/earsil
	name = "silver earrings"
	req_bar = /obj/item/ingot/silver
	created_item = list(/obj/item/rogueacc/earsilver,
						/obj/item/rogueacc/earsilver,
						/obj/item/rogueacc/earsilver)*/

/datum/anvil_recipe/valuables/ringg
	name = "gold rings"
	req_bar = /obj/item/ingot/gold
	created_item = list(/obj/item/clothing/ring/gold,
						/obj/item/clothing/ring/gold,
						/obj/item/clothing/ring/gold)

/datum/anvil_recipe/valuables/rings
	name = "silver rings"
	req_bar = /obj/item/ingot/silver
	created_item = list(/obj/item/clothing/ring/silver,
						/obj/item/clothing/ring/silver,
						/obj/item/clothing/ring/silver)
