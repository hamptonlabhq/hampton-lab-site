#!/bin/bash

# Start Rails server in the background
echo "Starting Rails server..."
bin/rails server &

# Capture the process ID (PID) of the server
RAILS_PID=$!

# Wait a moment for the server to start
echo "Waiting for server to start (PID: $RAILS_PID)..."
sleep 5

# Check if server is running
echo "Checking if server is running..."
curl -I http://127.0.0.1:3000/

# Mirror the site
echo "Starting wget mirror..."
wget --convert-links --mirror --adjust-extension http://127.0.0.1:3000/

# Copy CNAME file to the mirrored directory
echo "Copying CNAME file..."
cp CNAME 127.0.0.1:3000/

# Kill the Rails server after wget is done
echo "Shutting down server..."
kill $RAILS_PID
sleep 5
echo "Done!"
