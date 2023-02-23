## Level 0

- Commands used:

    - `ssh bandit0@bandit.labs.overthewire.org -p 2220` 

    - ![level-0](.//img-level/level0.png)

## Level 0 - Level 1

- Commands used:
    - `ls`
    - `cat` - to view the content of `readme` file
    - `exit` - had to exit this SSH session because connecting from localhost is blocked to conserve resources.
    - `ssh bandit1@bandit.labs.overthewire.org -p 2220`

    - ![level-1](.//img-level/level1.png)

## Level 1 - Level 2

- Commands used:
    - `ls -lah` - to list all files including hidden ones.
    - `cat ./-` - to display contents in `-` file.
    - `exit` - to exit current SSH session.

- Note:
    - Running `cat -` to display file content did not work because `cat` command interprets `-` as a `redirection from / to stdin or stdout`.

    - ![level-2](.//img-level/level2.png)

## Level 2 - Level 3

- Commands used:
    - `ssh bandit2@bandit.labs.overthewire.org -p 2220`
    - `cat "spaces in this filename"` - 
    
- Note:
    - used quotation marks because of spaces inside of file name, better practice would be to name it `spaces-in-this-filename`.

    - ![level-3](.//img-level/level3.png) 

## Level 3 - Level 4

- Commands used:
    - `ssh bandit3@bandit.labs.overthewire.org -p 2220`
    - `ls -lah` - list all hidden files and directories.
    - `cat .hidden` - view content of .hidden file.

    - ![level-4](.//img-level/level4.png) 

## Level 4 - Level 5

- Commands used:
    - `ssh bandit4@bandit.labs.overthewire.org -p 2220`
    - `file ./*` - use file command to check which file content is in Human Readable format.
    - `cat ./-file07` - a file with ASCII text (Human Readable)

    - ![level-5](.//img-level/level5.png)

## Level 5 - Level 6

- Commands used:
    - `ssh bandit5@bandit.labs.overthewire.org -p 2220`
    - `ls`
    - `find /home/bandit5/inhere -type f -readable -size 1033c ! -executable`
    - `ls -lah` - to view hidden files
    - `cat .file2`

    - ![level-6](.//img-level/level6.png)

- Note:

    - `-type f` indicates our interest in files.
    - `-readable` indicates that file must be human-readable.
    - `-size 1033c` indicates that file must be 1033 kb in size.
    - `!-executable` indicates that file must not be executable.

## Level 6 - 7

- Commands used:
    - `ssh bandit6@bandit.labs.overthewire.org -p 2220`
    - `find / -type f -user bandit7 -group bandit6 -size 33c 2>/dev/null`

    - ![level-7](.//img-level/level7.png)

- Note:

    - `find /` - search the entire filesystem.
    - `-type f -user bandit7 -group bandit6` - for a file owned by user bandit7 and group bandit6.
    - `33c` - file must be 33 bytes in size. 
    - `2>/dev/null` - added to redirect error messages to `/dev/null` so that we only see the output of the command.

## Level 7 - 8

- Commands used:
    - `ssh bandit7@bandit.labs.overthewire.org -p 2220`
    - `ls` - to view files.
    - `cat data.txt`- it was a mistake because of output, used `Ctrl+C` to interrupt process.
    - `grep milionth data.txt` - no output.
    - `grep -w milionth data.txt` - still no output.
    - `awk '/millionth/ {print $NF}' data.txt` provided output.
    - When we run this command `awk` tool will search through the content of data.txt for lines that contain the word `milionth` and print the last field of the line which should be the output we are looking for.

    - ![level-8](.//img-level/level8.png)

- Note:

    - `awk` - text processing tool. 
        - [How to use awk](https://www.howtogeek.com/562941/how-to-use-the-awk-command-on-linux/)
    - `/milionth/` - expression that instructs `awk` to search for lines that could contain the phrase `milionth`.
    - `{print $NF}` - prints the last field of any line that matches the search expression.
    - `data.txt` - the name of the file that `awk` should process.

## Level 8 - 9

- Commands used:
    - `ssh bandit8@bandit.labs.overthewire.org -p 2220`
    - `ls`
    - `sort data.txt | uniq -u` - for the unique output.

    - ![level-9](.//img-level/level9.png)

- Note:

    - `sort` command sorts the lines in a text file in alphabetical order [A - Z].
    - `uniq` command filters out duplicate lines in a text file and outputs unique lines, with `-u` it will output those lines that occur EXACTLY once.

## Level 9 - 10

- Commands used:

    - `ssh bandit9@bandit.labs.overthewire.org -p 2220`
    - `ls`
    - `grep "==*" data.txt -o` - to grep for strings containing one or more equal signs, but it doesn't work.
    - `cat data.txt | strings -e s | grep ==`

    - ![level-10](.//img-level/level10.png)

- Note:

    - `cat data.txt` - outputs the content of data.txt.
    - `|` - pipe output from cat data.txt to strings -e s.
    - `strings -e s` - extracts printable strings from the input, `-e s` tells `strings` to look for 4 charaters long strings.
    - `|` - another pipe to grep ...
    `grep ==` - this command searches for lines in data.txt that contain the `==` in the input.

## Level 10 - 11

- Commands used:

    - `ssh bandit10@bandit.labs.overthewire.org -p 2220`
    - `ls`
    - `base64 -d data.txt` - to decode the base64 data in the file. 

    - ![level-10-11](.//img-level/bandit10.png)

