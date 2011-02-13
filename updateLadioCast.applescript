set songLine to ""
set lastSongLine to ""
on getSongLine()
	set lastline to do shell script "tail -n1 ~/.spobbilog"
	set AppleScript's text item delimiters to ";"
	set delimiter to " "
	set lastline_split to text items of lastline
	set title to item 2 of lastline_split
	set artist to item 3 of lastline_split
	set album to item 4 of lastline_split
	set songLine to "'" & title & "' by " & artist & " on '" & album & "'"
	return songLine
end getSongLine

repeat
	set songLine to getSongLine()
	
	if songLine is not lastSongLine then
		set lastSongLine to songLine
		
		tell application "LadioCast"
			set metadata song to songLine
		end tell
	end if
	
	delay 15
end repeat