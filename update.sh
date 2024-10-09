#!/bin/bash

# Update runs on the server to update to latest git main branch code.

# Set up env so we have Elixir commands like mix
. $HOME/.asdf/asdf.sh

# Get latest main from github
cd ~/Bad-Date
git pull

# Get new deps, run new migrations 
mix deps.get
mix ecto.migrate

# Restart the service
systemctl --user restart baddate


