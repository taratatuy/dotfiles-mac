set folderPaths to {¬
	{"Inbox", "CloudBSS Deployer"}, ¬
	{"Inbox", "Corporate Communication Group"}, ¬
	{"Inbox", "Meetings (Accepted or Canceled)"}, ¬
	{"Inbox", "MR comments"}, ¬
	{"Inbox", "Other"}, ¬
	{"Inbox", "X_GitToJira"}, ¬
	{"Inbox", "e&", "Atp2Notifications"}, ¬
	{"Inbox", "e&", "CI Beauty"}, ¬
	{"Inbox", "e&", "DMP Jenkins (Descriptors)"}, ¬
	{"Inbox", "e&", "HealthCheck on SIT"}, ¬
	{"Inbox", "e&", "Jenkins"}, ¬
	{"Inbox", "e&", "TMS Filters sub"} ¬
}

set twoWeeksAgo to (current date) - (14 * days)

tell application "Microsoft Outlook"
	set deletedFolder to folder "Deleted Items" of default account

	repeat with pathList in folderPaths
		try
			-- Build folder reference from path
			set folderRef to default account
			repeat with fname in pathList
				set folderRef to folder fname of folderRef
			end repeat

			-- Process messages in that folder
			set msgList to messages of folderRef
			repeat with aMsg in msgList
				try
					if time received of aMsg < twoWeeksAgo then
						move aMsg to deletedFolder
					end if
				end try
			end repeat

		on error errMsg
			log "Error processing folder path " & pathList & ": " & errMsg
		end try
	end repeat
end tell
