; ShortScript
; A tool to optimize code for AI prompting.
; Author: github.com/richkmls
; Date: 5/25/2023
; Usage: 
;	1. Select a JavaScript/Python code that you want to shorten.
;	2. Press Win+C to copy a markdown codeblock with the shortened code.
;	3. Paste the codeblock wherever you want.
;	 - Win+` will send 3 backticks followed by a newline.
; Known Issue: Does not remove docstrings from python code

#C::

; Copies the selected text to the clipboard
Send ^c

; Waits for the clipboard to contain data
ClipWait

; Stores the clipboard text in a variable
clipboardText := Clipboard
; Initializes a variable to store the new text
newText := ""

; Initializes a variable to track if the script is currently inside a comment block
inComment := false

; Splits the clipboard text into an array of lines
lines := StrSplit(clipboardText, "`n", "`r")

; Loops through each line of text
for index, line in lines {

    ; Trims any leading or trailing whitespace from the line
    line := Trim(line)
    
    ; Skips empty lines, lines starting with "#" and lines starting with "//"
    if (line = "" || SubStr(line, 1, 1) = "#" || SubStr(line, 1, 2) = "//") {
        continue
    }	
    ; If currently inside a comment block
    if (inComment) {
    
        ; Checks if the line contains the end of a comment block "*/"
        if (InStr(line, "*/")) { 
	
            ; Sets inComment to false to indicate that the script is no longer inside a comment block
            inComment := false 
        } 
        ; Skips to the next iteration of the loop
        continue 
    } 
    ; Checks if the line contains the start of a comment block "/*"
    if (InStr(line, "/*")) { 
    
        ; Checks if the line also contains the end of a comment block "*/"
        if (InStr(line, "/*") && InStr(line, "*/", InStr(line, "/*") + 2)) { 
	
            ; Skips to the next iteration of the loop
            continue 
	    
        } else { 
	
            ; Sets inComment to true to indicate that the script is now inside a comment block
            inComment := true 
	    
            ; Skips to the next iteration of the loop
            continue 
        } 
    }
    ; Checks if the line contains an inline comment "#"
    pos := InStr(line, "#")
    
    if (pos) {
    
        ; Initializes a variable to track if the script is currently inside a string
        inString := false
	
        ; Loops through each character in the line
        for i, char in StrSplit(line) {
	
            ; Checks if the character is a double quote that is not escaped by another double quote
            if (char = """" && (i = 1 || SubStr(line, i - 1, 1) != "\")) {
	    
                ; Toggles the inString variable to indicate if the script is currently inside or outside a string
                inString := !inString
            }
            ; If not currently inside a string and the character is "#"
            if (!inString && char = "#") {
	    
                ; Removes everything after "#" from the line
                line := SubStr(line, 1, i - 1)
                break
            }
        }
    }
    
    ; Checks if the line contains an inline comment "//"
    pos := InStr(line, "//")
    if (pos) {
    
        ; Initializes a variable to track if the script is currently inside a string
        inString := false
	
        ; Loops through each character in the line
        for i, char in StrSplit(line) {
	
            ; Checks if the character is a double quote that is not escaped by another double quote
            if (char = """" && (i = 1 || SubStr(line, i - 1, 1) != "\")) {
	    
                ; Toggles the inString variable to indicate if the script is currently inside 
		; or outside a string
                inString := !inString
		
            }
            ; If not currently inside a string and there are two consecutive forward slashes "//"
            if (!inString && SubStr(line,i ,2) = "//") {
	    
                ; Removes everything after "//" from the line
                line := SubStr(line, 1, i - 1)
                break
            }
        }
    }
    ; Appends the modified line to newText followed by a newline character "`n"
    newText .= Trim(line) . "`n"
}
; Wraps newText with triple backticks and assigns it to Clipboard variable.
newText := "```````" . "`n" . newText . "```````"  . "`n"
Clipboard := newText

; clear newText
newText =

return

#`:: ; key command Windows key + backtick
Send `````` ; sends 3 backticks (each backtick is escaped with a backtick)
Send +{Enter} ; sends Shift+Enter
return
