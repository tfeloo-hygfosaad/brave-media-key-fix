#!/usr/bin/env bash
# File: ~/.local/bin/media-broadcast.sh

# List of main players you want to control
# Haruna is fixed; Brave is dynamic
MAIN_PLAYERS=("haruna", "strawberry")

# Infinite loop to listen for Play/Pause key via playerctl
while true; do
    # Wait for any Play/Pause press (blocks)
    playerctl metadata --follow &>/dev/null

    # Build full player list including all Brave instances
    BRAVE_PLAYERS=$(playerctl -l | grep '^brave')
    PLAYERS=("${MAIN_PLAYERS[@]}" $BRAVE_PLAYERS)

    # Toggle Play/Pause for each player
    for p in "${PLAYERS[@]}"; do
        playerctl -p "$p" play-pause &>/dev/null
    done
done
