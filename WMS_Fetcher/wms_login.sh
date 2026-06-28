#!/bin/bash

# --- Version 3.0 (Optimized)
# --- Configuration ---

COOKIE_FILE="/tmp/wms_cookies" # Base path for cookie files
LOGIN_URL="http://psychic-driveway-starboard.ngrok-free.dev/wms/user/login"

# Define credentials using an associative array (Key -> Username:Password)
declare -A ACCOUNTS=(
    ["K0"]="51021430:51021430"
    ["K2"]="51021430:51021430"
    ["K4"]="51021430:51021430"
    ["K6"]="51021430:51021430"
    ["K8"]="51021430:51021430"
)

# --- Dynamic Login Function ---
do_login() {
    local key="$1"
    # Split the credentials by the colon delimiter
    local username="${ACCOUNTS[$key]%%:*}"
    local password="${ACCOUNTS[$key]#*:}"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') Attempting to log in for $key and capture session..."

    # Execution of curl request using variables
    RESPONSE=$(curl -s -X POST "$LOGIN_URL" \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
        -H 'Accept-Language: en-US,en;q=0.9,th;q=0.8' \
        -H 'Cache-Control: max-age=0' \
        -H 'connection: keep-alive' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'Origin: http://psychic-driveway-starboard.ngrok-free.dev' \
        -H 'Referer: http://psychic-driveway-starboard.ngrok-free.dev/wms/user/login' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 edg/137.0.0.0' \
        --data-raw "txtUserName=$username&txtPassword=$password" \
        --insecure \
        -c "${COOKIE_FILE}${key}.txt" \
        -w "%{http_code}" \
        -o /dev/null)

    if [ "$RESPONSE" -eq 200 ] || [ "$RESPONSE" -eq 201 ] || [ "$RESPONSE" -eq 302 ]; then
        echo "$key Login successful! Cookies saved to ${COOKIE_FILE}${key}.txt"
        return 0
    else
        echo "$key Login failed with status code: $RESPONSE"
        return 1
    fi
}

# --- Main Automation Loop ---
# Loops through the keys in a predictable order
for key in K0 K2 K4 K6 K8; do
    do_login "$key"
    if [ $? -ne 0 ]; then
        echo "Initial login for $key failed."
    fi
done
