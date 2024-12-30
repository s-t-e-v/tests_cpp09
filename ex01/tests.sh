#!/bin/bash

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
BINARY="./$1"

# Counters
nb_passed=0
nb_tests=0

tests_file="$TESTS_DIR/tests"

while IFS= read -r line; do
    if [[ "$line" =~ ^# ]]; then
        test_name="${line:2}"

        read -r arg
        read -r expected_output

        echo -ne "Test: $test_name: ${YELLOW}$arg${END} -> "
        echo -ne "${CYAN}$expected_output${END}"

        ((nb_tests++))

        # Run the RPN program and capture its output
        actual_output=$($BINARY "$arg" 2> /dev/null)

        # Boolean checks
        is_expected_error=$([[ "$expected_output" == "Error" && \
                               "$actual_output" == Error* ]])
        is_exact_match=$([[ "$expected_output" != "Error" && \
                            "$actual_output" == "$expected_output" ]])

        # Evaluate result
        if $is_expected_error || $is_exact_match; then
            echo -ne "${GREEN} OK${END}"
            ((nb_passed++))
        else
            echo -ne "${RED} KO${END}"
        fi

        echo ""
    fi
done < "$tests_file"

echo ""

# Display general results
if [ $nb_passed -eq $nb_tests ]; then
    echo -e "${GREEN}${nb_passed}/${nb_tests} tests passed${END}"
else
    echo -e "${RED}${nb_passed}/${nb_tests} tests passed${END}"
fi
