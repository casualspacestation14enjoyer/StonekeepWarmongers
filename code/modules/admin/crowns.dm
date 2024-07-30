#define CROWNFILE "[global.config.directory]/crownwearers.txt"
#define BYPASSFILE "[global.config.directory]/factionbypass.txt"

GLOBAL_LIST(crownwearers)
GLOBAL_PROTECT(crownwearers)

GLOBAL_LIST(factionbypassers)
GLOBAL_PROTECT(factionbypassers)

/proc/load_bypasslist() // Not to be mistaken by load_bypassage()
	GLOB.factionbypassers = list()
	for(var/line in world.file2list(BYPASSFILE))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.factionbypassers += ckey(line)

	if(!GLOB.factionbypassers.len)
		GLOB.factionbypassers = null

/proc/check_bypasslist(ckey)
	if(!GLOB.factionbypassers)
		return FALSE
	. = (ckey in GLOB.factionbypassers)

/proc/load_crownlist()
	GLOB.crownwearers = list()
	for(var/line in world.file2list(CROWNFILE))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.crownwearers += ckey(line)

	if(!GLOB.crownwearers.len)
		GLOB.crownwearers = null

/proc/check_crownlist(ckey)
	if(!GLOB.crownwearers)
		return FALSE
	. = (ckey in GLOB.crownwearers)

#undef CROWNFILE
#undef BYPASSFILE