#!/bin/bash

# Prompt the user for the day number
read -p "Enter the day number for Advent of Code: " DAY_NUM

# get current year
# todo: let user set year
YEAR=$(date +%Y)

# obtain cookie
if [ -z "$COOKIE" ]; then
	echo "Please set the COOKIE environment variable to your Advent of Code cookie"
	exit 1
fi
# fetch input
input=$(curl -H "Cookie: session=$COOKIE" "https://adventofcode.com/${YEAR}/day/${DAY_NUM}/input")

# Create the necessary files and directories
DAY_FILE="src/days/day${DAY_NUM}.rs"
INPUT_FILE="src/inputs/day${DAY_NUM}-input.txt"
MOD_FILE="src/days/mod.rs"
MAIN_FILE="src/main.rs"

# Create day file
mkdir -p src/days
mkdir -p src/inputs

cat >"$DAY_FILE" <<EOF
use crate::days::Day;
use std::fs;

static DAY_NUM: i32 = ${DAY_NUM};

#[allow(non_camel_case_types)]
pub struct day${DAY_NUM};

impl Day for day${DAY_NUM} {
    fn part1(&self) {
        let file_path = format!("src/inputs/day{}-input.txt", DAY_NUM);
        let contents = fs::read_to_string(file_path).unwrap();

    }

    fn part2(&self) {
        let file_path = format!("src/inputs/day{}-input.txt", DAY_NUM);
        let contents = fs::read_to_string(file_path).unwrap();

    }
}
EOF

# Create input file
echo "$input" >"$INPUT_FILE"

# Modify mod.rs
if ! grep -q "pub mod day${DAY_NUM};" "$MOD_FILE"; then
	if [[ "$OSTYPE" == "darwin"* ]]; then
		sed -i "" "1i\\
        pub mod day${DAY_NUM};" "$MOD_FILE"
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
