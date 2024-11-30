#!/bin/bash

# day variable has no leading 0 and must be between 1 and 25
day=${1##+(0)}
if ((day < 1 || day > 25)); then
    echo "Invalid day input: $1. Must be between 1 and 25."
    return
fi
# project vartiable is "dayXX" where XX is the day variable
project=$(printf "day%02d" $1)

# year variable is the current year
year=9999

# get session cookie from file if .session exists
if [[ -f ".session" ]]; then
  AOC_SESSION=$(<".session")
fi

# validate session cookie
if [ -z "$AOC_SESSION" ]; then
    echo "AOC_SESSION isn't set. Cannot continue."
    return
fi
VALIDSESSION=$(curl -s "https://adventofcode.com/${year}/day/1/input" --cookie "session=${AOC_SESSION}")
if [[ $VALIDSESSION =~ "Puzzle inputs differ by user." ]] || [[ $VALIDSESSION =~ "500 Internal Server" ]]; then
    echo "Invalid AOC_SESSION. Cannot continue."
    return
fi

if [[ -d "${project}" ]]; then
        cd $project
        return
    fi

mkdir ${project}

cd ${project}

curl -s "https://adventofcode.com/${year}/day/${day}/input" --cookie "session=${AOC_SESSION}" -o input.txt
# Remove the trailing blank line
truncate -s -1 input.txt

# start python project if second argument is py
if [ "$2" = "py" ]; then
    # solution stub
    echo -n "def part1(input):
    return 0

def part2(input):
    return 0

def main():
    input = open(\"input.txt\", \"r\").read().splitlines()
    part1_ans = part1(input)
    part2_ans = part2(input)
    print(f\"Part 1: {part1_ans}\")
    print(f\"Part 2: {part2_ans}\")

if __name__ == \"__main__\":
    main()" > AOC.py

    # testing stub
    echo -n "import pytest
from AOC import *

@pytest.mark.skip(reason=\"Not implemented\")
@pytest.mark.parametrize(\"puzzle_input,expected\",
    [
        (\"\", \"\"),
        (\"\", \"\"),
        (\"\", \"\")
    ])
def test_part1(puzzle_input, expected):
    \"\"\"Test part 1 on example input.\"\"\"
    assert part1(puzzle_input) == expected

@pytest.mark.skip(reason=\"Not implemented\")
@pytest.mark.parametrize(\"puzzle_input,expected\",
    [
        (\"\", \"\"),
        (\"\", \"\"),
        (\"\", \"\")
    ])
def test_part2(puzzle_input, expected):
    \"\"\"Test part 2 on example input.\"\"\"
    assert part2(puzzle_input) == expected
" > test.py

# Go directory structure
else

    # solution stub
    echo -n "package main

import (
	\"fmt\"
	\"os\"
	\"strings\"
)

func part1(input []string) int {
	return 0
}

func part2(input []string) int {
	return 0
}

func main() {
	input, err := os.ReadFile(\"input.txt\")
	if err != nil {
		fmt.Print(\"Error reading file\\n\")
		panic(err)
	}

	lines := strings.Split(string(input), \"\n\")
    part1_ans := part1(lines)
	fmt.Printf(\"Part 1: %d\\n\", part1_ans)

	part2_ans := part2(lines)
	fmt.Printf(\"Part 2: %d\\n\", part2_ans)
}" > AOC.go

    # testing stub
    echo -n "package main

import (
	\"testing\"
)

func TestPart1(t *testing.T) {
	tests := []struct {
		input    []string
		expected int
	}{}

	if len(tests) == 0 {
		t.Log(\"Not implemented\")
		t.Fail() // Fail instead of skip so that the test is run every time
		return
	}

	for _, test := range tests {
		actual := part1(test.input)
		if actual != test.expected {
			t.Errorf(\"%s = %d, expected %d\", test.input, actual, test.expected)
		}
	}
}

func TestPart2(t *testing.T) {
	tests := []struct {
		input    []string
		expected int
	}{}

	if len(tests) == 0 {
		t.Log(\"Not implemented\")
		t.Fail() // Fail instead of skip so that the test is run every time
		return
	}

	for _, test := range tests {
		actual := part2(test.input)
		if actual != test.expected {
			t.Errorf(\"%s = %d, expected %d\", test.input, actual, test.expected)
		}
	}
}
" > AOC_test.go

go mod init ${project}
cd ../
go work use ./${project}
cd ${project}
fi