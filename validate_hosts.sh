#!/bin/bash

validate_ip() {
local host=$1
local ip=$2
local dns_server=$3

	if [[$ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
		resolved_ip=$(dig @$dns_server +short $host)
		if [[ $resolved_ip == $ip ]]; then
			echo "Valid association: $host -> $ip"
		else
			echo "Invalid association: $host -> $ip"
		fi
	else
		echo "Invalid IP: $ip"
	fi
}

while read -r line; do
	[[ $line =~ ^# ]] && continue

	ip =$(echo "$line" | awk '{print $1}')
	host=$(echo "$line" | awk '{print $2}')

	validate_ip "$host" "$ip" "8.8.8.8"
done < /etc/hosts
