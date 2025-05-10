tell application "Microsoft Outlook"
	set targetFolder to mail folder "Meetings (Accepted or Canceled)" of inbox
	set sentMessages to messages of sent items

	repeat with msg in sentMessages
		set theSubject to subject of msg
		if theSubject contains "Accepted:" or theSubject contains "Canceled:" or theSubject contains "Declined:" then
			move msg to targetFolder
		end if
	end repeat
end tell
