/proc/chatter(message, phomeme, atom/A)
	// We want to transform any message into a list of numbers, stored in $letter_count.
	// For example:
	// "Hi." -> [2]
	// "HALP GEROGE MELLONS, that swine, is GRIFFIN ME!"
	// -> [4, 6, 7, 4, 5, '2', 7, 2]
	// "fuck,thissentenceissquashed" -> [4, 21]

	// Original regex text:  / ([a-z\d]+)([\.\?\!\'\-;,])? /gi
	// You can test it here: https://regex101.com/r/qeiVs2/3/
	var/regex/R = regex("(\[a-z\\d]+)(\[\\.\\?\\!\\'\\-;,])?", "gi")
	var/list/letter_count = list()
	var/list/puncts = list() // A list storing, for each word, what punctuation thing comes after that word. If no such thing exists, the value is FALSE.

	while(R.Find(message) != 0) // As long as we keep finding words
		letter_count += length(R.group[1])
		if(R.group[2])
			puncts += R.group[2]
		else
			puncts += FALSE

	spawn(0)
		for(var/i in 1 to letter_count.len)
			var/word = letter_count[i]
			var/wordlength = min(word, 10)
			chatter_speak_word(A.loc, phomeme, wordlength)
			
			if(puncts[i]) // If this word had a punctuation thing after it
				var/punc = puncts[i]
				if (punc in list(",", ":",";"))
					sleep(3)
				else if (punc in list("!", "?", "."))
					sleep(6)
				else
					sleep(1)
			else
				sleep(1)
/proc/chatter_speak_word(loc, phomeme, length)
	var/path = "sound/chatter/[phomeme]_[length].ogg"

	playsound(loc, path,
		vol = 40, vary = 0, extrarange = 3, falloff = FALSE)

	sleep((length + 1) * chatter_get_sleep_multiplier(phomeme))

/proc/chatter_get_sleep_multiplier(phomeme)
	// By the way dude, these values are tenths of seconds, so 0.5 == 0.05seconds
	switch(phomeme)
		if("papyrus")
			return 0.5
		if("griffin")
			return 0.5
		if("sans")
			return 0.7
		if("owl")
			return 0.7
		else
			return 1
