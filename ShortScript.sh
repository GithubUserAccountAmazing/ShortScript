#!/bin/bash
# A tool to optimize code for AI prompting.
# Author: github.com/richkmls
# Last Updated: 5/6/2023
# Usage:
#	0. In ubuntu, add the path to this script as a custom key binding
# 	1. Select a JavaScript/Python code that you want to shorten.
# 	2. Press Win+C to copy a markdown codeblock with the shortened code.
# 	3. Paste the codeblock wherever you want.

xclip -selection primary -o | xclip -selection clipboard -i

# Read the clipboard content into a variable
clipboardText=$(xclip -selection clipboard -o)

# Initialize an empty string for the new text
newText=""

# Initialize a variable to keep track of whether we are in a multi-line comment
inComment=false

# Loop through each line of the clipboard text
while read -r line; do

	# Remove any leading or trailing whitespace and tabs from the line
	line=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//')

	# If the line is empty or a comment, skip it
	if [[ -z "$line" || "$line" =~ ^(#|//) ]]; then
		continue
	fi

    # Check if we are in a multi-line comment
    if [[ $inComment == true ]]; then
        # If we are in a multi-line comment, check if this line ends it
        if [[ $line =~ .*\"\"\".* ]]; then
            inComment=false
        fi

        # Skip this line since it is part of a multi-line comment
        continue
    else
        # If we are not in a multi-line comment, check if this line starts one
        if [[ $line =~ .*\"\"\".* ]]; then
            inComment=true

            # Skip this line since it is part of a multi-line comment
            continue
        fi
    fi

	# Split the line by // and # and keep everything before it
	# Use awk to match the pattern and print the first field
	# ignore instances of "//" that are a part of a URL
	linePart=$(echo "$line" | awk '{sub(/[^:]\/\//,""); sub(/#.*/,"")}1')

    # Check if line is within quotes and if so, do not split it
    if [[ $line =~ ^\".*\"$ || $line =~ ^\'.*\'$ ]]; then
        linePart=$line
    fi

	# Append the line part to the new text and trim any white space at both ends
	newText+=$(echo "$linePart" | sed 's/^[ \t]*//;s/[ \t]*$//')
	newText+=$'\n'

done <<< "$clipboardText"

# Add "\`\`\`" and a newline at the beginning of the string
newText="\`\`\`"$'\n'"$newText"

# Add a "\`\`\`" at the end of the string
newText+=$"\`\`\`"

# Replace the clipboard with the new text
echo "$newText" | xclip -selection clipboard
