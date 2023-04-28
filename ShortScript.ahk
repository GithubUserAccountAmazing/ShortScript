; ShortScript
; A tool to optimize code for AI prompting.
; Author: github.com/originates
; Date: 4/28/2023
; Usage:	
;	Select a JavaScript code with your mouse or keyboard then
;	Press Win+C to copy a shortened version to your clipboard.
;	Paste the shortened code wherever you want.

#C::

; Add the selected text to the clipboard
Send ^c
ClipWait

; Assign clipboard content to a variable
clipboardText := Clipboard

; Iterate over each line of the variable
Loop, Parse, clipboardText, `n, `r
{
	; Remove any leading or trailing whitespace from the line
	currentLine := Trim(A_LoopField) 

	; If the line is empty skip it.
	If (currentLine = "")
        	continue

	; If the line is a comment skip it
    	If (SubStr(currentLine, 1, 2) = "//" or SubStr(currentLine, 1, 1) = "#")
        	continue

	; Split the line by //
    	StringSplit, lineParts, currentLine, //

	; Append the first part of the split to a new variable and trim any white space
	newText .= Trim(lineParts1) "`n"
}

; Replace the clipboard with the new variable
Clipboard := newText

; clear newText
newText =

return











