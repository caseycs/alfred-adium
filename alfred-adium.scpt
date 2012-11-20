on alfred_script(q)
  set theString to "" & q
  set theMessage to theString
  
  #get the name portion of the string
  set AppleScript's text item delimiters to {":"}
  set chatParts to (every text item in theString) as list
  set theName to item 1 of chatParts
  
  #get the message portion of the string
  -- 0 = beginning, 1 = end, 2 = both
  set AppleScript's text item delimiters to {""}
  set x to the length of the (theName & ":")
  -- TRIM BEGINNING
  repeat while theMessage begins with the (theName & ":")
    try
      set theMessage to characters (x + 1) thru -1 of theMessage as string
    on error
      -- the text contains nothing but the trim characters
      return ""
    end try
  end repeat
  #end of get the message portion of the string
  
  tell application "System Events"
    set theCount to count (every process whose name contains "Adium")
  end tell
  
  if theCount = 0 then
    tell application "Adium"
      activate
    end tell
    delay 5
  end if
  
  tell application "Adium"
    try
      set theContact to get name of first contact whose display name contains theName
      if length of theContact > 0 then
        tell application "Adium" to set theAccount to the account of the contact theContact
        
        try
          set existing_chat to get first chat
          tell theAccount to set newChat to make new chat with contacts {contact theContact} at after existing_chat
        on error
          tell theAccount to set newChat to make new chat with contacts {contact theContact} with new chat window
        end try
        
        tell (newChat) to become active
        
        if length of theMessage is greater than 0 and theName is not equal to theMessage then
          tell application "Adium" to send newChat message theMessage
        end if
        
        tell application "Adium" to activate
      end if
    on error
      -- display dialog "Sorry. I was unable to find the Adium contact with '" & theName & "' in it's display name and launch the chat."
    end try
  end tell
  
end alfred_script