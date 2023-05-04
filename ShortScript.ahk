; ShortScript
; A tool to optimize code for AI prompting.
; Author: github.com/richkmls
; Date: 4/28/2023, updated 5/4/2023
; Usage: 
;	1. Select a JavaScript/Python code that you want to shorten.
;	2. Press Win+C to copy a markdown codeblock with the shortened code.
;	3. Paste the codeblock wherever you want.

#C::

; Add the selected text to the clipboard
Send ^c
ClipWait

; Assign clipboard content to a variable
clipboardText := Clipboard

; Iterate over each line of the variable
Loop, Parse, clipboardText, `n, `r
{
	; Remove any leading or trailing whitespace and tabs from the line
	currentLine := Trim(A_LoopField, " `t")

	; If the line is empty skip it.
	If (currentLine = "")
        	continue

	; If the line is a comment skip it
    	If (SubStr(currentLine, 1, 1) = "#" or SubStr(currentLine, 1, 2) = "//")
        	continue

	; Find the position of "//" in the current line
	pos := InStr(currentLine, "//")

	; If "//" is found in the current line and it's not part of a URL
	If (pos > 0 and SubStr(currentLine, pos - 1, 1) != ":")
	{
		; Get the part of the current line before "//"
		currentLine := SubStr(currentLine, 1, pos - 1)
	}

	; Find the position of "#" in the current line
	pos := InStr(currentLine, "#")

	; If "#" is found in the current line
	If (pos > 0)
	{
		; Get the part of the current line before "#"
		currentLine := SubStr(currentLine, 1, pos - 1)
	}

	; Append the current line to a new variable and trim any white space
	newText .= Trim(currentLine) "`n"
}

; Add "```" and a newline at the beginning of the string
newText := "``````" . "`n" . newText

; Add a "```" at the ends of the string
newText := newText . "``````" . "`n"

; Replace the clipboard with the new variable
Clipboard := newText

; clear newText
newText =

return
