#!/bin/bash
# tmux session script for bsp-dev project
# Creates a multi-window, multi-pane development environment

set -e

SESSION_NAME="bsp-dev"

# Check if session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Attaching..."
    tmux attach-session -t "$SESSION_NAME"
    exit 0
fi

echo "Creating tmux session: $SESSION_NAME"

# Create new session with first window (detached)
tmux new-session -d -s "$SESSION_NAME" -n "doc-servers"

# Window A: Main development window
# Start with the initial pane (A[0].B[0])
tmux send-keys -t "$SESSION_NAME:doc-servers.0" "cd /Users/dcvezzani/projects/bsp-dev-tools" C-m
tmux send-keys -t "$SESSION_NAME:doc-servers.0" "NODE_ENV=local yarn dev" C-m

# Split horizontally to create A[1] (right pane) - 50% width each
tmux split-window -h -p 50 -t "$SESSION_NAME:doc-servers.0" -c "/Users/dcvezzani/projects/markdown-renderer"

# Now split the left pane (A[0]) vertically to create B[1] - 66% goes to new pane
tmux split-window -v -p 66 -t "$SESSION_NAME:doc-servers.0" -c "/Users/dcvezzani/projects/markdown-renderer"
tmux send-keys -t "$SESSION_NAME:doc-servers.1" "nvm use 22 > /dev/null 2>&1; nvm use 22; NODE_ENV=local yarn dev" C-m

# Split the second pane (now at position 1) vertically again to create B[2] - 50% splits evenly
tmux split-window -v -p 50 -t "$SESSION_NAME:doc-servers.1" -c "/Users/dcvezzani/projects/markdown-renderer/shared/api"
tmux send-keys -t "$SESSION_NAME:doc-servers.2" "yarn dev" C-m

# Now split the right pane (A[1], currently at position 3) vertically to create C[1]
tmux split-window -v -t "$SESSION_NAME:doc-servers.3" -c "/Users/dcvezzani/projects/markdown-renderer/markdown"
tmux send-keys -t "$SESSION_NAME:doc-servers.4" "ls -latr" C-m

# Window D: Journal API window
tmux new-window -t "$SESSION_NAME" -n "journal-api" -c "/Users/dcvezzani/Library/CloudStorage/OneDrive-ChurchofJesusChrist/Documents/journal/current/20250206-dcvezzani-home/api"
tmux send-keys -t "$SESSION_NAME:journal-api.0" "yarn dev" C-m

# Split vertically to create second pane in journal-api window
tmux split-window -v -t "$SESSION_NAME:journal-api.0" -c "/Users/dcvezzani/Library/CloudStorage/OneDrive-ChurchofJesusChrist/Documents/journal/current/20250206-dcvezzani-home/api"

# Select the first window (doc-servers) as the starting window
tmux select-window -t "$SESSION_NAME:doc-servers"

# Attach to the session
echo "Attaching to session: $SESSION_NAME"
tmux attach-session -t "$SESSION_NAME"
