#define MUSIC_TAV list("Memory Of Eora" = 'sound/music/jukeboxes/eora.ogg',"March Of Freemen" = 'sound/music/jukeboxes/marche.ogg',"Capital Of The World" = 'sound/music/jukeboxes/capital.ogg')

/datum/looping_sound/musloop
	mid_sounds = list()
	mid_length = 99999
	volume = 50
	extra_range = 5
	persistent_loop = TRUE
	var/stress2give = /datum/stressevent/music

/datum/looping_sound/musloop/on_hear_sound(mob/M)
	. = ..()
	if(stress2give)
		if(isliving(M))
			var/mob/living/carbon/L = M
			L.add_stress(stress2give)

/client/AllowUpload(filename, filelength)
	if(filelength >= 6485760)
		src << "[filename] TOO BIG. 6 MEGS OR LESS!"
		return 0
	return 1

/obj/structure/roguemachine/musicbox
	name = "music device"
	desc = "A device more advanced due to the strides in technology. No longer made from wax and now uses ceramic disks with indents to make sound. This one is specially supplied to armies to listen to music to feel better about themselves."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "music0"
	density = TRUE
	max_integrity = 0
	anchored = FALSE
	var/datum/looping_sound/musloop/soundloop
	var/curfile
	var/playing = FALSE
	var/curvol = 70
	var/list/music_tracks

/obj/structure/roguemachine/musicbox/Initialize()
	soundloop = new(list(src), FALSE)
	music_tracks = MUSIC_TAV
	. = ..()

/obj/structure/roguemachine/musicbox/update_icon()
	icon_state = "music[playing]"

/obj/structure/roguemachine/musicbox/attack_right(mob/user)
	. = ..()
	if(.)
		return
	if(!user.ckey)
		return
	if(playing)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/selection = input(user, "Select a song.", "Music Device") as null|anything in music_tracks
	if(!selection)
		return
	if(!Adjacent(user))
		return
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	playing = FALSE
	soundloop.stop()
	curfile = music_tracks[selection]
	update_icon()


/obj/structure/roguemachine/musicbox/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(!playing)
		if(curfile)
			playing = TRUE
			soundloop.mid_sounds = list(curfile)
			soundloop.cursound = null
			soundloop.volume = curvol
			soundloop.start()
	else
		playing = FALSE
		soundloop.stop()
	update_icon()
