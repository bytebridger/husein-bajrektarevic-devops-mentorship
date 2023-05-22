#!/bin/bash
# testing parameters before use
#
if [ -n "$1" ]
then
echo Hello $1, glad to meet you.
else
echo "Sorry, you did not identify yourself. "
fi

# $ ./test7.sh Rich
# $ ./test7.sh
# Sorry, you did not identify yourself.