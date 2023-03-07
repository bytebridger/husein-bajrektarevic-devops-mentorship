#!/bin/bash

# Find all scripts inside this directory.

find . -type f -name '*.sh' -exec chmod +x {} \;

# This script will search all .sh extension files 
# inside of the working directory where it runs
# and it will use -exec to execute another command
# in this case it's chmod +x to make all files with .sh
# extension executable.
# {} is a special character that represents files 
# that are returned by find command
# \; EOL marker that tells find command that
# the command it is executing has ended.
