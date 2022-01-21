#!/bin/sh

# Uses regex substitution to translate text into furry text.

# read from input file if specified
if [ $# -gt 0 ]
then
	# read from specified file into pipeline
	sed -r 's/[rl]/w/g' < $1 |
	sed -r 's/[RL]/W/g'
else
	# read from stdin into pipeline
	sed -r 's/[rl]/w/g' |
	sed -r 's/[RL]/W/g'
fi
