#! /usr/bin/env dash

# ==============================================================================
# IMPORTANT: Test structure taken from tutorial
# test01.sh
# Test the pigs-add command.
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
# Test 'pigs-add a' - failure: no .pig

cat > "$expected_output" <<EOF
pigs-add: error: pigs repository directory .pig not found
EOF

pigs-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# Create pigs repository

cat > "$expected_output" <<EOF
Initialized empty pigs repository in .pig
EOF

pigs-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================
# Test 'pigs-add' - failure: usage

cat > "$expected_output" <<EOF
usage: pigs-add <filenames>
EOF

pigs-add > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# =============================================================
# Test 'pigs-add f' - failure: file doesnt exist

cat > "$expected_output" <<EOF
pigs-add: error: can not open 'f'
EOF

pigs-add f > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# =============================================================
# Test 'pigs-add a' - success: added to index

# Create a simple file.

echo "line 1" > a

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF

pigs-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
line 1
EOF

pigs-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

echo "Passed test"
exit 0
