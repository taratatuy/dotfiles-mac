tell application "Microsoft Outlook"
    set targetFolder to folder "TMS Filters sub" of folder "e&" of inbox
    set allMessages to messages of targetFolder

    set unreadCount to 0
    repeat with m in allMessages
        if is read of m is false then
            set unreadCount to unreadCount + 1
        end if
    end repeat

    if unreadCount is not 0 then
        display notification "TMS Filters:\nUnread messages: " & unreadCount sound name "Submarine"
    end if
end tell
