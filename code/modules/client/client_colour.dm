
/*
	Client Colour Priority System By RemieRichards
	A System that gives finer control over which client.colour value to display on screen
	so that the "highest priority" one is always displayed as opposed to the default of
	"whichever was set last is displayed"
*/



/*
	Define subtypes of this datum
*/
/datum/client_colour
	var/colour = "" //Any client.color-valid value
	var/priority = 1 //Since only one client.color can be rendered on screen, we take the one with the highest priority value:
	//eg: "Bloody screen" > "goggles colour" as the former is much more important


/*
	Adds an instance of colour_type to the mob's client_colours list
	colour_type - a typepath (subtyped from /datum/client_colour)
*/

/*
/mob/verb/test1()
	set category = "Options"

	add_client_colour(/datum/client_colour/sepia)

/mob/verb/test2()
	set category = "Options"

	add_client_colour(/datum/client_colour/inversed)

/mob/verb/test3()
	set category = "Options"

	add_client_colour(/datum/client_colour/monochrome)
*/

/mob/proc/add_client_colour(colour_type)
	if(!ispath(colour_type, /datum/client_colour))
		return

	var/datum/client_colour/CC = new colour_type()
	client_colours |= CC
	sortTim(client_colours, GLOBAL_PROC_REF(cmp_clientcolour_priority))
	update_client_colour()

/*
	Removes an instance of colour_type from the mob's client_colours list
	colour_type - a typepath (subtyped from /datum/client_colour)
*/
/mob/proc/remove_client_colour(colour_type)
	if(!ispath(colour_type, /datum/client_colour))
		return

	for(var/cc in client_colours)
		var/datum/client_colour/CC = cc
		if(CC.type == colour_type)
			client_colours -= CC
			qdel(CC)
			break
	update_client_colour()


/*
	Resets the mob's client.color to null, and then sets it to the highest priority
	client_colour datum, if one exists
*/
/mob/proc/update_client_colour()
	if(!client)
		return
	client.color = ""
	if(!client_colours?.len)
		return
	var/datum/client_colour/CC = client_colours[1]
	if(CC)
		client.color = CC.colour

/datum/client_colour/glass_colour
	priority = 0
	colour = "red"

/datum/client_colour/glass_colour/green
	colour = "#aaffaa"

/datum/client_colour/glass_colour/lightgreen
	colour = "#ccffcc"

/datum/client_colour/glass_colour/blue
	colour = "#aaaaff"

/datum/client_colour/glass_colour/lightblue
	colour = "#ccccff"

/datum/client_colour/glass_colour/yellow
	colour = "#ffff66"

/datum/client_colour/glass_colour/red
	colour = "#ffaaaa"

/datum/client_colour/glass_colour/darkred
	colour = "#bb5555"

/datum/client_colour/glass_colour/orange
	colour = "#ffbb99"

/datum/client_colour/glass_colour/lightorange
	colour = "#ffddaa"

/datum/client_colour/glass_colour/purple
	colour = "#ff99ff"

/datum/client_colour/glass_colour/gray
	colour = "#cccccc"

/datum/client_colour/monochrome
	colour = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	priority = INFINITY //we can't see colors anyway!

/datum/client_colour/sepia
	colour = list(0.393,0.349,0.272,0, 0.769,0.686,0.534,0, 0.189,0.168,0.131,0, 0,0,0,1, 0,0,0,0)

/datum/client_colour/inversed
	colour = list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0)
	priority = INFINITY

/datum/client_colour/test1
	colour = list(1,1,1,0.5, 1,1,1,0.5, 1,1,1,0.5)
	priority = 1

/datum/client_colour/test2
	colour = list(0.8,0.2,0.2, 0.2,0.8,0.3, 0.2,0.3,0.8)
	priority = 1

/datum/client_colour/test3
	colour = list(1,1,1, 1,1,1, 1,1,1)
	priority = 1


/datum/client_colour/monochrome/trance
	priority = 1

/datum/client_colour/monochrome/blind
	priority = 1
