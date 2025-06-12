#!/bin/bash

# Function to get metadata using playerctl
get_metadata() {
	key=$1
	playerctl metadata --format "{{ $key }}" 2>/dev/null
}

# Check for arguments

# Function to determine the source and return an icon and text
get_source_info() {
	trackid=$(get_metadata "mpris:trackid")
	if [[ "$trackid" == *"firefox"* ]]; then
		echo -e "󰈹 "
	elif [[ "$trackid" == *"spotify"* ]]; then
		echo -e " "
	elif [[ "$trackid" == *"chromium"* ]]; then
		echo -e " "
	else
		echo ""
	fi
}

#!/bin/bash

title=$(playerctl metadata --format '{{title}}')
artist=$(playerctl metadata --format '{{artist}}')
source=$(get_source_info)

# Clip title to 20 characters
short_title="${title:0:25}"

# Combine the pieces
song_info="$short_title $source $artist"

echo "$song_info" 