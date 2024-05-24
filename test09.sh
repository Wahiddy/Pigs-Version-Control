#! /usr/bin/env dash

# ==============================================================================
# IMPORTANT: Test structure taken from tutorial
# test09.sh
# Test the pigs-branch command.
#
# Written by: Wahid Hasan
# Date: 8/07/2023
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

# Create pigs repository

cat > "$expected_output" <<EOF
Initialized empty pigs repository in .pig
EOF

pigs-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =========================================================
# Test 'pigs-branch': failure: need a commit
cat > "$expected_output" <<EOF
pigs-branch: error: this command can not be run until after the first commit
EOF

pigs-branch > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

# Create a simple file.
echo "hello from a" > a
pigs-add a
pigs-commit -m "hi" > '/dev/null'

# =========================================================
# Test 'pigs-branch': failure: master exists
cat > "$expected_output" <<EOF
pigs-branch: error: branch 'master' already exists
EOF

pigs-branch master > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

# =========================================================
# Test 'pigs-branch': failure: cannot delete master 
cat > "$expected_output" <<EOF
pigs-branch: error: can not delete branch 'master': default branch
EOF

pigs-branch -d master > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

# =========================================================
# Test 'pigs-branch': failure: non existant branch
cat > "$expected_output" <<EOF
pigs-branch: error: branch 'm' doesn't exist
EOF

pigs-branch -d m > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

pigs-branch m

# =========================================================
# Test 'pigs-branch': deleted branch m
cat > "$expected_output" <<EOF
Deleted branch 'm'
EOF

pigs-branch -d m > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

# =========================================================
# Test 'pigs-branch': list
cat > "$expected_output" <<EOF
master
EOF

pigs-branch > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

echo "Passed test"
exit 0
