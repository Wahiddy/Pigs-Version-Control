#! /usr/bin/env dash

# ==============================================================================
# IMPORTANT: Test structure taken from tutorial
# test04.sh
# Test the pigs-show command.
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
# Test 'pigs-show' - failure: no .pig

cat > "$expected_output" <<EOF
pigs-show: error: pigs repository directory .pig not found
EOF

pigs-show 0:a > "$actual_output" 2>&1

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

# =============================================================
# Test 'pigs-show' - usage

cat > "$expected_output" <<EOF
usage: pigs-show <commit>:<filename>
EOF

pigs-show a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# =============================================================
# Test 'pigs-show a: :' - usage

cat > "$expected_output" <<EOF
usage: pigs-show <commit>:<filename>
EOF

pigs-show a: : > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# =============================================================
# Test 'pigs-show :a' - no commit

cat > "$expected_output" <<EOF
line 1
EOF

pigs-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# =============================================================
# Test 'pigs-show 0:a' - no commit

cat > "$expected_output" <<EOF
pigs-show: error: unknown commit '0'
EOF

pigs-show 0:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# =============================================================
# Test 'pigs-show a:'

cat > "$expected_output" <<EOF
pigs-show: error: unknown commit 'a'
EOF

pigs-show a: > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# commit the file to the repository history

cat > "$expected_output" <<EOF
Committed as commit 0
EOF

pigs-commit -m 'first commit' > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================
# Test 'pigs-show 0:a'

cat > "$expected_output" <<EOF
line 1
EOF

pigs-show 0:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# =============================================================
# Test 'pigs-show 0:f'

cat > "$expected_output" <<EOF
pigs-show: error: 'f' not found in commit 0
EOF

pigs-show 0:f > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# =============================================================
# Test 'pigs-show :f'

cat > "$expected_output" <<EOF
pigs-show: error: 'f' not found in index
EOF

pigs-show :f > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

# Update the file.

echo "line 2" >> a

# update the file in the repository staging area

cat > "$expected_output" <<EOF
EOF

pigs-add a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Update the file.

echo "line 3" >> a

# Check that the file that has been commited hasn't been updated

# =============================================================
# Test 'pigs-show 0:a' 

cat > "$expected_output" <<EOF
line 1
EOF

pigs-show 0:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# =============================================================

echo "Passed test"
exit 0
