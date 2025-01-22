#!/bin/bash

# ANSI codes for colors
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
CYAN="\033[36m"
BOLD="\033[1m"
END="\033[m"

# Tests folder and binary
TESTS_DIR="../tests/ex00"
BINARY="./$1"

# Counters
nb_tot_passed=0
nb_tot_tests=0



# ------ Main ------
