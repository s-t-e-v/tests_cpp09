#!/bin/bash

prog_name=$1

# ANSI codes for colors
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
CYAN="\033[36m"
BOLD="\033[1m"
END="\033[m"

# Directory containing all the test maps
TESTS_DIR="../tests/ex01"

# Binary of your program
BINARY=$prog_name

# Counters
nb_passed=0
nb_tests=0


# Outer loop to iterate over test types (directories in $TESTS_DIR)
for test_type_dir in "$TESTS_DIR"/*; do

    # Check if it is a directory
    if [ -d "$test_type_dir" ]; then
        test_name=$(basename "$test_type_dir")
        echo -e "${BOLD}---- $test_name input tests ----\n${END}"

        # Inner loop: iterate over test files in each test_name directory
        for test_file in "$test_type_dir"/*; do
            echo -n "Testing: $test_file"
            ((nb_tests++))

            test_passed=true
            # Get argument
            arg=$(head -n 1 $test_file)

            expected_output=expected_output
            actual_output=actual_output
            # Run the program with the argument in the first line of test_file
            $BINARY "$arg" 2>/dev/null > $actual_output
            actual_type=$?

            tail -n 4 $test_file > $expected_output

            # Check the actual_type and print the corresponding message
            if [ $actual_type -eq "${expected_type[$test_name]}" ] ; then
                echo -ne "${GREEN} OK${END}"
            else
                echo -ne "${RED} KO${END}"
                test_passed=false
            fi

            echo ""
        done

        echo ""
    fi
done

echo ""

# Display general results
if [ $nb_passed -eq $nb_tests ]; then
    echo -e "${GREEN}${nb_passed}/${nb_tests} tests passed${END}"
else
    echo -e "${RED}${nb_passed}/${nb_tests} tests passed${END}"
fi

