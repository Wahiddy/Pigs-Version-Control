#! /usr/bin/env dash

# ==============================================================================
# IMPORTANT: Test structure taken from tutorial
# test00.sh
# Test the pigs-init command.
#
# Written by: Wahid Hasan
# Date: 6/07/2023
# For COMP2041/9044 Assignment 1
# ==============================================================================

# add the current directory to the PATH so scripts
# can still be executed from it after we cd

PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

# =============================================================
# Test 'pigs-init' - success

cat > "$expected_output" <<EOF
Initialized empty pigs repository in .pig
EOF

pigs-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# =============================================================
# Test 'pigs-init' - failure: already exists

cat > "$expected_output" <<EOF
pigs-init: error: .pig already exists
EOF

pigs-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# =============================================================
# Test 'pigs-init' - failure: usage

cat > "$expected_output" <<EOF
usage: pigs-init
EOF

pigs-init hi > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

echo "Passed test"
exit 0
