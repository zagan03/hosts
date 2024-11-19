
#!/bin/bash
 
# Funcție pentru verificarea unei asocieri IP-host folosind un server DNS
validate_ip() {
    local host=$1
    local ip=$2
    local dns_server=$3
 
    # Verifică dacă adresa este IPv4
    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        # Rezolvă numele hostului folosind serverul DNS
        resolved_ip=$(dig @$dns_server +short $host)
        if [[ $resolved_ip == $ip ]]; then
            echo "Valid association: $host -> $ip"
        else
            echo "Invalid association: $host -> $ip"
        fi
    else
        echo "Ignoring invalid or IPv6 address: $ip"
    fi
}
 
# Verifică asocierile din /etc/hosts
while read -r line; do
    [[ $line =~ ^# ]] && continue  # Ignoră liniile comentate
 
    # Extrage adresa IP și numele hostului (doar primele două coloane)
    ip=$(echo "$line" | awk '{print $1}')
    host=$(echo "$line" | awk '{print $2}')
 
    # Verifică dacă există ambele coloane
    if [[ -n $ip && -n $host ]]; then
        # Verifică asocierea folosind un server DNS (ex: 8.8.8.8 - serverul Google)
        validate_ip "$host" "$ip" "8.8.8.8"
    fi
done < /etc/hosts
