#!/bin/bash

# ANSI codes for colors
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
CYAN="\033[36m"
BOLD="\033[1m"
END="\033[m"

# Directory containing all the test maps
TESTS_DIR="./tests"

# Binary of your program
BINARY="./convert"

# Counters
nb_passed=0
nb_tests=0

expected_output=expected_output
actual_output=actual_output

declare -A expected_type=( ["char"]=0 ["int"]=1 ["float"]=2 ["double"]=3 ["unknown"]=4 )

# Outer loop to iterate over test types (directories in $TESTS_DIR)
for test_type_dir in "$TESTS_DIR"/*; do

    # Check if it is a directory
    if [ -d "$test_type_dir" ]; then
        test_type=$(basename "$test_type_dir")
        echo -e "${BOLD}---- $test_type input tests ----\n${END}"

        # Inner loop: iterate over test files in each test_type directory
        for test_file in "$test_type_dir"/*; do
            echo -n "Testing: $test_file"
            ((nb_tests++))

            test_passed=true
            # Get argument
            arg=$(head -n 1 $test_file)

            # Run the program with the argument in the first line of test_file
            $BINARY "$arg" 2>/dev/null > $actual_output
            actual_type=$?

            tail -n 4 $test_file > $expected_output

            echo -en " - ${YELLOW}actual type${END}"
            # Check the actual_type and print the corresponding message
            if [ $actual_type -eq "${expected_type[$test_type]}" ] ; then
                echo -ne "${GREEN} OK${END}"
            else
                echo -ne "${RED} KO${END}"
                test_passed=false
            fi

            echo -en " - ${CYAN}conversion${END}"
            if diff "$expected_output" "$actual_output" > /dev/null; then
                echo -ne "${GREEN} OK${END}"
            else
                echo -ne "${RED} KO${END}"
                test_passed=false
            fi

            if [ $test_passed = true ]; then
                ((nb_passed++))
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

# Clean up
rm -f $actual_output
rm -f $expected_output
