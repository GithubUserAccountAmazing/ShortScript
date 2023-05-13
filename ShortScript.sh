#!/bin/bash
# A tool to optimize code for AI prompting.
# Author: github.com/richkmls
# Date: 5/12/2023
# Usage:
#	0. In ubuntu, add the path to this script as a custom key binding
# 	1. Select a JavaScript/Python code that you want to shorten.
# 	2. Press Win+C to copy a markdown codeblock with the shortened code.
# 	3. Paste the codeblock wherever you want.

# Copy the primary selection to the clipboard
xclip -selection primary -o | xclip -selection clipboard -i

# Read the clipboard content into a variable
clipboardText=$(xclip -selection clipboard -o)

# Initialize an empty string for the new text
newText=""

# Initialize a variable to keep track of whether we are in a multi-line comment
inComment=false

while read -r line; do

    # Remove any leading or trailing whitespace and tabs from the line
    line=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//')

    # If the line is empty or a comment, skip it
    if [[ -z "$line" || "$line" =~ ^(#|//) ]]; then
        continue
    fi

    # Check if we are currently inside a multi-line comment
    if [[ $inComment == true ]]; then
        # Check if the line contains the end of the multi-line comment
        if [[ $line =~ .*\"\"\".* || $line =~ .*\*\/.* ]]; then
            inComment=false
        fi
        continue
    fi

    # Check if the line contains triple quotes or /* indicating a multi-line comment
    if [[ $line =~ .*\"\"\".* || $line =~ .*/\*.* ]]; then
        # Check if there is another set of triple quotes or */ on the same line
        if [[ $line =~ .*\"\"\".*\"\"\".* || $line =~ .*/\*.*\*/.* ]]; then
            # This is a single line comment using triple quotes or /* */ syntax
            continue
        else
            # Set inComment to true and skip this line since it is part of a multi-line comment
            inComment=true 
            continue
        fi
    fi

    # Use sed to match and remove any characters after # or // that are not within single or double quotation marks
    linePart=$(echo "$line" | sed -E 's/("[^"]*")|('\''[^'\'']*'\'')|(#.*)|(\/\/.*)/\1\2/g')

    # Append the line part to the new text and trim any white space at both ends using sed command 
    newText+=$(echo "$linePart" | sed 's/^[ \t]*//;s/[ \t]*$//')
    newText+=$'\n'

done <<< "$clipboardText"

# Add "\`\`\`" and a newline at the beginning of the string
newText="\`\`\`"$'\n'"$newText"

# Add a "\`\`\`" at the end of the string
newText+=$"\`\`\`"

# Replace the clipboard with the new text using xclip command 
echo "$newText" | xclip -selection clipboard
