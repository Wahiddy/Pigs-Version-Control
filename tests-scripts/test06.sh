#! /usr/bin/env dash

# ==============================================================================
# IMPORTANT: Test structure taken from tutorial
# test06.sh
# Test the pigs-rm command.
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

# ==========================================================
# Test 'pigs-rm': failure - .pig doesnt exist
cat > "$expected_output" <<EOF
pigs-rm: error: pigs repository directory .pig not found
EOF

pigs-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

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
echo "hello from b" > b

# ==========================================================
# Test 'pigs-rm' - failure: file not in repo
cat > "$expected_output" <<EOF
pigs-rm: error: 'a' is not in the pigs repository
EOF

pigs-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
pigs-rm: error: 'a' is not in the pigs repository
EOF

pigs-rm --cached a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
pigs-rm: error: 'a' is not in the pigs repository
EOF

pigs-rm --force a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

# add a file to the repository staging area

cat > "$expected_output" <<EOF
EOF

pigs-add a b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# ==========================================================
# Test 'pigs-rm' - failure: has staged changes
cat > "$expected_output" <<EOF
pigs-rm: error: 'a' has staged changes in the index
EOF

pigs-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

# ==========================================================
# Test 'pigs-rm' - failure: usage
cat > "$expected_output" <<EOF
usage: pigs-rm [--force] [--cached] <filenames>
EOF

pigs-rm --forced a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

# ==========================================================
# Test 'pigs-rm' - success: removal from index and dir
cat > "$expected_output" <<EOF
EOF

pigs-rm --force a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

# ==========================================================
# Test 'pigs-rm' - success: removal a success
cat > "$expected_output" <<EOF
pigs-show: error: 'a' not found in index
EOF

pigs-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
hello from b
EOF

pigs-show :b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

# ==========================================================
# Test 'pigs-rm': failure - b has staged changes
cat > "$expected_output" <<EOF
pigs-rm: error: 'b' has staged changes in the index
EOF

pigs-rm b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

# track files

cat > "$expected_output" <<EOF
Committed as commit 0
EOF

pigs-commit -m "first commit" > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# ==========================================================
# Test 'pigs-rm': success 
cat > "$expected_output" <<EOF
EOF

pigs-rm b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
pigs-show: error: 'b' not found in index
EOF

pigs-show :b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
hello from b
EOF

pigs-show 0:b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
pigs-show: error: 'a' not found in commit 0
EOF

pigs-show 0:a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

# ==========================================================
# Test 'pigs-rm': success
echo hello from a > a
echo hello from b > b

pigs-add a b
pigs-commit -m "second commit" > '/dev/null'

echo not b > b
pigs-add b

cat > "$expected_output" <<EOF
EOF

pigs-rm a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

# ==========================================================
# Test 'pigs-rm': success - force

cat > "$expected_output" <<EOF
pigs-rm: error: 'b' has staged changes in the index
EOF

pigs-rm b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
EOF

pigs-rm --force b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

cat > "$expected_output" <<EOF
pigs-show: error: 'b' not found in index
EOF

pigs-show :b > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

# ==========================================================
# Test 'pigs-rm': success - cached
echo hello from a > a

pigs-add a

cat > "$expected_output" <<EOF
EOF

pigs-rm --cached a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Should be in dir however

cat > "$expected_output" <<EOF
pigs-show: error: 'a' not found in index
EOF

pigs-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

pigs-add a

cat > "$expected_output" <<EOF
EOF

pigs-rm --force --cached a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi

# Should be in dir however

cat > "$expected_output" <<EOF
pigs-show: error: 'a' not found in index
EOF

pigs-show :a > "$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test"
    exit 1
fi
# ==========================================================

echo "Passed test"
exit 0
