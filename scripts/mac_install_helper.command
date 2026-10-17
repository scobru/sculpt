#!/bin/bash
# Sculpt - Legacy helper redirecting to root install.command
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -f "$SCRIPT_DIR/../install.command" ]; then
    exec bash "$SCRIPT_DIR/../install.command"
elif [ -f "$SCRIPT_DIR/install.command" ]; then
    exec bash "$SCRIPT_DIR/install.command"
else
    echo "❌ install.command not found"
    exit 1
fi