#!/bin/bash

# Prompt the user for the day number
read -p "Enter the day number for Advent of Code: " DAY_NUM

# get current year
# todo: let user set year
YEAR=$(date +%Y)

# obtain cookie
if [ -z "$COOKIE" ]; then
	echo "No COOKIE environment variable found, creating empty input file"
	input=""
else
	# fetch input
	input=$(curl -H "Cookie: session=$COOKIE" "https://adventofcode.com/${YEAR}/day/${DAY_NUM}/input")
fi

# Create the necessary files and directories
DAY_FILE="src/days/day${DAY_NUM}.rs"
INPUT_FILE="src/inputs/day${DAY_NUM}-input.txt"
MOD_FILE="src/days/mod.rs"
MAIN_FILE="src/main.rs"
TEMPLATE_FILE="template.rs"

# Create day file
mkdir -p src/days
mkdir -p src/inputs

# Create day file from template
if [ ! -f "$TEMPLATE_FILE" ]; then
	echo "Error: Template file '$TEMPLATE_FILE' not found."
	exit 1
fi

sed "s/{{PLACEHOLDER}}/${DAY_NUM}/g" "$TEMPLATE_FILE" >"$DAY_FILE"

# Create input file
echo "$input" >"$INPUT_FILE"

# Modify mod.rs
if ! grep -q "pub mod day${DAY_NUM};" "$MOD_FILE"; then
	# This is for MacOS because they use BSD-based sed which works differently from GNU sed, you'll see more of this down the file too
	if [[ "$OSTYPE" == "darwin"* ]]; then
		sed -i "" "1i\\
        pub mod day${DAY_NUM};" "$MOD_FILE"

	# This is for GNU/Linux
	elif [[ "$OSTYPE" == "linux-gnu" ]]; then
		sed -i "1i\\pub mod day${DAY_NUM};" "$MOD_FILE"
	fi
fi

# Modify main.rs
MATCH_CASE="            ${DAY_NUM} => day${DAY_NUM}::day${DAY_NUM}.run(part),"
if ! grep -q "${MATCH_CASE}" "$MAIN_FILE"; then
	if [[ "$OSTYPE" == "darwin"* ]]; then
		sed -i "" "/match day {/a \\
        ${MATCH_CASE}" "$MAIN_FILE"

	elif [[ "$OSTYPE" == "linux-gnu" ]]; then
		sed -i "/match day {/a\\${MATCH_CASE}" "$MAIN_FILE"
	fi
fi

# Run rustfmt on the changed files
rustfmt "$DAY_FILE" "$MOD_FILE" "$MAIN_FILE"

echo "Setup for day ${DAY_NUM} is complete, Happy Coding!"
