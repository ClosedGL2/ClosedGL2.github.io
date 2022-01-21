#!/bin/sh

# Prints out a random copypasta from r/copypasta on Reddit.
# Requires pup, a command line HTML parser.

if which pup >& /dev/null
then
	# scrape r/copypasta post links, pick random link
	wget https://old.reddit.com/r/copypasta/new -q -O /dev/stdout |
	pup 'a[data-event-action="comments"] attr{href}' |
	shuf -n 1 > /tmp/pastaurl
	
	# scrape pasta from post
	wget "$(cat /tmp/pastaurl)" -q -O /dev/stdout |
	pup 'div[id="siteTable"]' |
	pup 'div[class="md"]' |
	pup 'p text{}'

else
	# pup not found
	echo "randcopypasta: pup not found" >> /dev/stderr
	echo "Please install pup HTML parser to use randcopypasta" >> /dev/stderr
fi
