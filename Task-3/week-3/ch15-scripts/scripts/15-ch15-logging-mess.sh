#!/bin/bash
# using the tee command for logging
tempfile=test22file
echo "This is the start of the test" | tee $tempfile
echo "This is the second line of the test" | tee -a $tempfile
echo "This is the end of the test" | tee -a $tempfile

# $ ./test22
# This is the start of the test
# This is the second line of the test
# This is the end of the test
# $ cat test22file
# This is the start of the test
# This is the second line of the test
# This is the end of the test