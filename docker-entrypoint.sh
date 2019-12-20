#!/bin/bash
# Interpreter identifier

# Exit on fail
set -e

# Ensure all gems installed. Add binstubs to bin which has been added to PATH in Dockerfile.
if [[ -f Gemfile ]]; then
  bundle check || bundle install --binstubs="$BUNDLE_BIN"
fi

if [ $# -eq 0 ]; then
	exec /bin/bash
else
	echo "exec command => $@"
	exec "$@"
fi