#!/bin/bash

# ANSI codes for colors
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
CYAN="\033[36m"
BOLD="\033[1m"
END="\033[m"

# Tests folder and binary
TESTS_DIR="../tests/ex02"
BINARY="./$1"

# Counters
nb_tot_passed=0
nb_tot_tests=0

# Other parameters
NB_RANDOM_TESTS=20
# TODO: Maybe add timeout for each test


# ---- Functions ----


# ---- Main ----


tests_file="$TESTS_DIR/tests"


# Basic valid tests

# Error tests

# 100 different numbers tests

# 1000 different numbers tests

# 3000 different numbers tests

# 5000 different numbers tests

# 10000 different numbers tests

# 5000 numbers with duplicates tests

while IFS= read -r line; do
    if [[ "$line" =~ ^# ]]; then
        test_name="${line:2}"

        read -r arg
        read -r expected_output

        echo -ne "Test: $test_name: ${YELLOW}$arg${END} -> "
        echo -ne "${CYAN}$expected_output${END}"

        ((nb_tests++))

        # Run the RPN program and capture its output
        actual_output=$($BINARY "$arg" 2>&1)

        # Check if the output matches the expected result
        if { [[ "$expected_output" == "Error" && "$actual_output" == Error* ]]; } || \
           { [[ "$expected_output" != "Error" && "$actual_output" == "$expected_output" ]]; }; then
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
if [ $nb_tot_passed -eq $nb_tot_tests ]; then
    echo -e "${GREEN}${nb_tot_passed}/${nb_tot_tests} tests passed${END}"
else
    echo -e "${RED}${nb_tot_passed}/${nb_tot_tests} tests passed${END}"
fi
