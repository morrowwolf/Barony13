/client/proc/check_alts()
	set category = "Admin"
	set name = "Check Alternate Accounts"
	if(!check_rights(R_ADMIN))
		return

	var/list/dat = list()

	for(var/mob/player in GLOB.player_list)
		if(player.client)
			var/list/related_accounts = list()
			if(!cmptext(player.client.related_accounts_cid, ""))
				var/list/potential_related_accounts = splittext(player.client.related_accounts_cid, ", ")
				for(var/i = 1, i <= potential_related_accounts.len, i++)
					if(related_accounts.Find(potential_related_accounts[i]))
						continue
					related_accounts += potential_related_accounts[i]
			if(!cmptext(player.client.related_accounts_ip, ""))
				var/list/potential_related_accounts = splittext(player.client.related_accounts_ip, ", ")
				for(var/i = 1, i <= potential_related_accounts.len, i++)
					if(related_accounts.Find(potential_related_accounts[i]))
						continue
					related_accounts += potential_related_accounts[i]
			if(!related_accounts.len)
				continue
			var/formatted_related_accounts = ""
			for(var/text in related_accounts)
				if(cmptext(text, related_accounts[related_accounts.len]))
					formatted_related_accounts += "[text]."
				else
					formatted_related_accounts += "[text], "
			dat += "[ADMIN_FLW(player)][player.client.key] is related to the following accounts: [formatted_related_accounts]"

	if(!dat.len)
		to_chat(src, "There were no related accounts on any client in player_list found.")
		return

	for(var/text in dat)
		to_chat(src, text)