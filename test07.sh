#! /usr/bin/env dash

# ==============================================================================
# IMPORTANT: Test structure taken from tutorial
# test07.sh
# Test the pigs-status command. No removal
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

# Create a simple file.

echo "hello from a" > a

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF

pigs-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =========================================================
# Test 'pigs-status': added to index 
cat > "$expected_output" <<EOF
a - added to index
EOF

pigs-status > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

echo hi > a

# =========================================================
# Test 'pigs-status': changed and not added
cat > "$expected_output" <<EOF
a - added to index, file changed
EOF

pigs-status > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

pigs-commit -m "0" > '/dev/null'

# =========================================================
# Test 'pigs-status': file committed
cat > "$expected_output" <<EOF
a - file changed, changes not staged for commit
EOF

pigs-status > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

pigs-add a

# =========================================================
# Test 'pigs-status': file added
cat > "$expected_output" <<EOF
a - file changed, changes staged for commit
EOF

pigs-status > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

pigs-commit -m "0" > '/dev/null'

# =========================================================
# Test 'pigs-status': file committed and same 
cat > "$expected_output" <<EOF
a - same as repo
EOF

pigs-status > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# =========================================================

echo "Passed test"
exit 0
