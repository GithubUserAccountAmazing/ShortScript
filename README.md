<h1 align="center">ShortScript:sparkles:</h1>

#### <p align="center">A tool to optimize code snippets for AI prompting.</p><br>

ShortScript is a simple and handy tool that helps you copy and paste code for using it within AI prompts.

- It minifies your selected code by removing comments, blank lines, and spaces. This reduces the size of your code and makes it easier to copy and paste into AI applications like ChatGPT or Bing AI.
- It wraps your selected code with codeblock syntax (triple backticks) to help make your prompt clearer and easier for the AI to understand.

For example, this is how ShortScript transforms a basic JavaScript code that uses comments, blank lines, and good formatting:

<p align="center">
<img src="https://user-images.githubusercontent.com/105183376/235229706-9de3705f-ba5a-4d35-8626-2312593540dc.png" />
</p>

## Why Use This?

AI apps need prompts to generate output. Prompts have a character limit based on the app and the language model. For example, ChatGPT can process up to 500 words or 4,000 characters. If you go over the limit, the app may stop working or show an error. ShortScript can help you optimize your code for AI prompting by making it shorter and clearer. This can prevent character limit issues and improve AI output.

## How to Set Up

Windows -> AHK:
- Install AutoHotkey on your system.
- Run the script by double-clicking or right-clicking on the .ahk file.

Linux -> Bash:
- Install dependency xclip with "sudo apt-get install xclip"
- Add the path to ShortScript.sh as a custom key binding


## How to Use

- Select a JavaScript/Python code with your mouse or keyboard and press Win+C to copy a shortened and wrapped version to your clipboard.
- Paste the shortened and wrapped code wherever you want.


## Features and Limitations

- There seems to be an issue with using the bash script to extract text from CodeMirror editors.
- The script is optimized for JavaScript, Python which use "//" and "#" as comment symbols.
- Subtle differences in functionality may emerge between the AHK and Bash versions as the project progresses.

If you encounter any issues or have suggestions for enhancements, please feel free to submit an issue or pull request.

## Disclaimer

This script is provided "as is" without any warranty. The author is not responsible for any damage or loss caused by using this script. See License for more info.

