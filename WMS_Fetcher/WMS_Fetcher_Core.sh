#!/bin/bash

# --- Version 2.4
# --- Configuration ---
OUTPUT_FILE="/tmp/WMS_Response.txt"
COOKIE_FILE="/tmp/wms_cookies.txt" # Where curl will store the session IDs

USERNAME="51021430"
PASSWORD="51021430"

LOGIN_URL="http://192.168.2.22/wms/user/login"
DATA_URL="http://192.168.2.22/wms/api/PrepareTaskUser/QueryUnclaimPreparedTrans"

# --- Function to Handle Login ---
do_login() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') Attempting to log in and capture session..."

    # -c saves the cookies returned by the server into our cookie file
    RESPONSE=$(curl -s -X POST "$LOGIN_URL" \
		-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7'\
		-H 'Accept-Language: en-US,en;q=0.9,th;q=0.8'\
		-H 'Cache-Control: max-age=0'\
		-H 'connection: keep-alive'\
		-H 'Content-Type: application/x-www-form-urlencoded'\
		-H 'Origin: http://192.168.2.22'\
		-H 'Referer: http://192.168.2.22/wms/user/login'\
		-H 'Upgrade-Insecure-Requests: 1'\
		-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 edg/137.0.0.0'\
        --data-raw "txtUserName=$USERNAME&txtPassword=$PASSWORD"\
        --insecure \
        -c "$COOKIE_FILE" \
        -w "%{http_code}" \
        -o /dev/null)

    if [ "$RESPONSE" -eq 200 ] || [ "$RESPONSE" -eq 201 ] || [ "$RESPONSE" -eq 302 ]; then
        echo "Login successful! Cookies saved to $COOKIE_FILE"
        return 0
    else
        echo "Login failed with status code: $RESPONSE"
        return 1
    fi
}

# --- Main Automation Loop ---

# Perform initial login
do_login
if [ $? -ne 0 ]; then
    echo "Initial login failed. Script will attempt to retry on next cycle."
fi

echo "Starting API polling. Press Ctrl+C to stop."

while true; do
    ./k8_preparing_fetch.sh
    # Wait for 60 seconds
    sleep 60
done
