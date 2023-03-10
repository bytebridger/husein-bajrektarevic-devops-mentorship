#!/bin/bash
# iterating through multiple directories
for file in /home/husein/Desktop/shell-scripting.pdf* /home/husein/Desktop/badtest
    do
        if [ -d "$file" ]
        then
        echo "$file is a directory"
    elif [ -f "$file" ]
        then
        echo "$file is a file"
    else
        echo "$file doesn't exist"
    fi
done