#!/bin/bash

while read -r line; do
	[[ $line =~ ^# ]] && continue

	ip=$(echo "$line" | awk '{print $1}')

	if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
		echo "Valid IP: $ip"
	else
		echo "Invalid IP: $ip"
	fi
done< /etc/hosts

