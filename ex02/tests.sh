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


tests_file="$TESTS_DIR/tests"

# ---- Functions ----

test() {
    local test_file="$1"
    local expected_output

    if [[ "$test_file" == *error* ]]; then
        echo -e "${BOLD}---- Error tests ----${END}"
        expected_output="1"
    else
        echo -e "${BOLD}---- Basic tests ----${END}"
        expected_output="0"
    fi

    local nb_passed=0
    local nb_tests=0

    while IFS= read -r line; do
        if [[ "$line" =~ ^# ]]; then
            test_name="${line:2}"

            read -r arg

            echo -ne "Test: $test_name: ${YELLOW}$arg${END}"

            ((nb_tests++))

            # Run program
            $BINARY $arg 2> /dev/null > /dev/null
            local actual_output=$?

            # Check if the output matches the expected result
            if [[ $expected_output -eq $actual_output ]]; then
                echo -ne "${GREEN} OK${END}"
                ((nb_passed++))
            else
                echo -ne "${RED} KO${END}"
            fi

            echo ""
        fi
    done < "$TESTS_DIR/$test_file"

    # Display results for the current test file
    if [ $nb_passed -eq $nb_tests ]; then
        echo -e "${GREEN}${nb_passed}/${nb_tests} tests passed${END}"
    else
        echo -e "${RED}${nb_passed}/${nb_tests} tests passed${END}"
    fi

    ((nb_tot_passed+=nb_passed))
    ((nb_tot_tests+=nb_tests))

    echo ""
}

randomized_tests () {
    local nb_numbers=$1
    local nb_tests=$2

    echo -e "${BOLD}---- Randomized tests with $nb_numbers different numbers ----${END}"

    local nb_passed=0

    echo -ne "Tests:"
    for i in $(seq 1 $nb_tests); do
        local numbers=$(shuf -i 1-100000 -n $nb_numbers | tr '\n' ' ')

        echo -ne " $i."

        # Run program
        $BINARY $numbers 2> /dev/null > /dev/null
        local actual_output=$?

        # Check if the output matches the expected result
        if [[ "$actual_output" == 0 ]]; then
            echo -ne "${GREEN} OK${END}"
            ((nb_passed++))
        else
            echo -ne "${RED} KO${END}"
        fi

    done

    echo ""

    # Display results for the current test file
    if [ $nb_passed -eq $nb_tests ]; then
        echo -e "${GREEN}${nb_passed}/${nb_tests} tests passed${END}"
    else
        echo -e "${RED}${nb_passed}/${nb_tests} tests passed${END}"
    fi

    ((nb_tot_passed+=nb_passed))
    ((nb_tot_tests+=nb_tests))

    echo ""
}

# ---- Main ----

# Basic valid tests
test "basic_tests"

# Error tests
test "error_tests"

# 100 different numbers tests
randomized_tests 100 $NB_RANDOM_TESTS

# 1000 different numbers tests
randomized_tests 1000 $NB_RANDOM_TESTS

# 3000 different numbers tests
randomized_tests 3000 $NB_RANDOM_TESTS

# 5000 different numbers tests
randomized_tests 5000 $NB_RANDOM_TESTS

# 10000 different numbers tests
randomized_tests 10000 $NB_RANDOM_TESTS


# Display general results

echo ""
echo "------------------- General results -------------------"
echo ""

if [ $nb_tot_passed -eq $nb_tot_tests ]; then
    echo -e "${GREEN}${nb_tot_passed}/${nb_tot_tests} tests passed${END}"
else
    echo -e "${RED}${nb_tot_passed}/${nb_tot_tests} tests passed${END}"
fi

