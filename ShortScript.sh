#!/bin/bash
# A tool to optimize code for AI prompting.
# Author: github.com/richkmls
# Date: 5/3/2023
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

# Loop through each line of the clipboard text
while read -r line; do

	# Remove any leading or trailing whitespace and tabs from the line
	line=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//')

	# If the line is empty or a comment, skip it
	if [[ -z "$line" || "$line" =~ ^(#|//) ]]; then
		continue
	fi

	# Split the line by // and # and keep everything before it
	# Use awk to match the pattern and print the first field
	linePart=$(echo "$line" | awk -F "//" '{print $1}' | awk -F "#" '{print $1}')

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

