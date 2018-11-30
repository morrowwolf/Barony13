/datum/admins/proc/togglelooc()
	set category = "Server"
	set desc = "Toggles LOOC for all players."
	set name = "Toggle LOOC"

	toggle_looc()
	log_admin("[key_name(usr)] toggled LOOC.")
	message_admins("[key_name_admin(usr)] toggled LOOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle LOOC", "[GLOB.looc_allowed ? "Enabled" : "Disabled"]"))

/datum/admins/proc/toggleloocdead()
	set category = "Server"
	set desc = "Toggles LOOC for dead players."
	set name = "Toggle Dead LOOC"

	toggle_dlooc()
	log_admin("[key_name(usr)] toggled Dead LOOC.")
	message_admins("[key_name_admin(usr)] toggled Dead LOOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Dead LOOC", "[GLOB.dlooc_allowed ? "Enabled" : "Disabled"]"))