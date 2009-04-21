#!/bin/bash

/path/to/viz -CommandLineInvocation YES "$@"

echo "Finish writing this script!"
# get the path to viz:
#   if we know it, use it
#   otherwise guess and check using /Applications, ~/Applications
#   if still nothing, complain

# viz [options] [files]
# if options
#	new instance
# otherwise
#	open -a viz [files]
