#! /usr/bin/env dash

# ==============================================================================
# IMPORTANT: Test structure taken from tutorial
# test05.sh
# Test the pigs-commit -a command.
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

# Create pigs repository

cat > "$expected_output" <<EOF
Initialized empty pigs repository in .pig
EOF

pigs-init > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Create a simple file.

echo "hello" > a
echo "this is not b" > b

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF


pigs-add a b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# track files

cat > "$expected_output" <<EOF
Committed as commit 0
EOF

pigs-commit -m "first commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =================================================================
# Test 'pigs-commit -a': nothing to commit

cat > "$expected_output" <<EOF
nothing to commit
EOF

pigs-commit -a -m "first commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =================================================================

echo "line 1" > a
echo "line 1" > b

# =================================================================
# Test 'pigs-commit -a': success

cat > "$expected_output" <<EOF
Committed as commit 1
EOF

pigs-commit -a -m "second commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =================================================================

cat > "$expected_output" <<EOF
hello
EOF

pigs-show 0:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
line 1
EOF

pigs-show 1:a > "$actual_output" 2>&1

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

echo "Passed test"
exit 0
