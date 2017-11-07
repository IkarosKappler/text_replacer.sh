#!/bin/bash
#
# This script reads from stdin and inserts its data in the passed file where the 
# This script expecst three parameters: input_file pattern 
#
# THIS IS JUST A TEST AN WORKS ONLY WITH FULL LINE PATTERNS!
# 
# Inspired by
#    http://unix.stackexchange.com/questions/32908/how-to-insert-the-content-of-a-file-into-another-file-before-a-pattern-marker


_RED='\033[0;31m'
_GREEN='\033[0;32m'
_PURPLE='\033[0;35m'
_NC='\033[0m'

if [ $# -lt 2 ]; then
    echo -e "[${_RED}Error${_NC}] Please pass: input_file pattern [insert_file|stdin]";
    echo -e "        Example 1: ${_GREEN}${0##*/} "my_input.js" \"bar\" insert_data.txt${_NC}"
    echo -e "        Example 2: ${_GREEN}${0##*/} "my_input.js" \"bar\" << insert_data.txt${_NC}"
    echo -e "        "
    exit 1;
fi

# If the file argument is the third argument to your script, test that 
# there is an argument ($3) and that it is a file. Else read input from stdin -
[ $# -ge 3 -a -f "$3" ] && input="$3" || input="-"
insert_data=$(cat $input)


input_file=$1
pattern=$2


#input=$(cat /dev/stdin)
echo $insert_data

while IFS= read -r line
do
    #if [[ "$line" =~ ^Pointer.*$ ]]
    if [[ "$line" =~ $pattern ]]
    then
        cat file1
    fi
    echo "$line"
done < input_file
