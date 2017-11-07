#!/bin/bash
#
# This script replaces the text pattern PATTERN by the text REPLACEMENT in all
# files from the passed file list.
#
# Note that each entry of the file list consists of
# <input_file> : <output_file>
#
#
# @author   Ikaros Kappler
# @date     2016-07-22
# @version  1.0.0


_RED='\033[0;31m'
_GREEN='\033[0;32m'
_PURPLE='\033[0;35m'
_NC='\033[0m'

echo -e "${_PURPLE}This script replaces PATTERN by REPLACEMENT (strings) in all files from your passed file list.${_NC}"
if [ $# -lt 3 ]; then
    echo -e "[${_RED}Error${_NC}] Please pass: <pattern> <replacement> <filelist>";
    echo -e "        Example: ${_GREEN}${0##*/} \"foo\" \"bar\" filelist.txt${_NC}"
    echo -e "                 (replaces each 'foo' by 'bar')"
    echo -e "        Please note that each file list entry (line) must consists of: "
	echo -e "                 <input_file> : <output_file>"
    exit 1;
fi

pattern=$1
replacement=$2
filelist=$3
if [ ! -f "$filelist" ]; then
	echo "Filelist '$filelist' not found."
	exit 1
fi

line_no=1
entry_no=1
while read line
do
    # Trim line:
    var="${line#"${line%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${line%"${line##*[![:space:]]}"}"   # remove trailing whitespace characters

    # Check if line is not empty
    if [ ! -z "$line" -a "$line"!=" " ]; then
		# Check if line is no comment (beginning with ';').
		if [[ ${line:0:1} != ';' ]]; then	    	
	    	# Split line into two party, separated by ':'.
	    	entry=(${line//:/ })
	    	infile=${entry[0]};
	    	outfile=${entry[1]};
	    	# echo "infile=$infile"; 
	    	# echo "outfile=$outfile"; 	    	
	    	if [ ! -f $infile ]; then
	    		echo "Error: file '$infile' not found."
	    		exit 1;
	    	fi
	    	# Escape the replacement string for SED.
	    	replacement=$(echo $replacement | sed -e 's/[\/&]/\\&/g')
	    	echo "[$entry_no] Running 'sed \"s/$pattern/$replacement/g\" $infile > $outfile'"
	    	# Run the command.
	    	result=$(sed "s/$pattern/$replacement/g" $infile > $outfile)
			ec="$?"
			if [ "$ec" -ne "0" ]; then
			    echo -e "[${_RED}Error${_NC}] Failed at line $line_no. Exit code $ec"
			    exit 1
			fi

	    	entry_no=`expr $entry_no + 1`;
		fi
	
    fi
    line_no=`expr $line_no + 1`;
done < $filelist


