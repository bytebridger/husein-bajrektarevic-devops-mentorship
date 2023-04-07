#!/bin/bash
# testing input/output file descriptor
exec 3<> testfile
read line <&3
echo "Read: $line"
echo "This is a test line" >&3

# $ cat testfile
# This is the first line.
# This is the second line.
# This is the third line.

# $ ./test16
# Read: This is the first line.
# $ cat testfile
# This is the first line.
# This is a test line
# ine.
# This is the third line.