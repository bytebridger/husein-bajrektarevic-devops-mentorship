#!/bin/bash
# Test using at command
#
echo "This script ran at $(date +%B%d,%T)" > test13b.out
echo >> script.out
sleep 5
echo "This is the script's end..." >> script.out
#
# $
# $ at -M -f script.sh now
# job 8 at 2015-07-14 12:48
# $
# $ cat script.out
# This script ran at July14,12:48:18
# This is the script's end..."