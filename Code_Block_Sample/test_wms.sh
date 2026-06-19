#!/bin/bash

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
    
    # Construct the JSON payload for login
    LOGIN_BODY="{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}"

    # -c saves the cookies returned by the server into our cookie file
    RESPONSE=$(curl -s -X POST "$LOGIN_URL" \
        -H "Content-Type: application/json" \
        -d "$LOGIN_BODY" \
        -c "$COOKIE_FILE" \
        -w "%{http_code}" \
        -o /dev/null)

    if [ "$RESPONSE" -eq 200 ] || [ "$RESPONSE" -eq 201 ]; then
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
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] Fetching data..."

    # Define the exact JSON payload matching your PowerShell request
    DATA_BODY='{"deliveryDate":"2026-06-13T15:51:02.158Z","doItemDesc":"","companyName":"","materialCode":"","materialName":"","batch":"","storageSAP":"","workStyle":"","loadOptions":{"requireTotalCount":true,"searchOperation":"contains","searchValue":null,"skip":0,"take":20,"userData":{},"sort":null,"group":null}}'

    # Execute request using the stored cookies (-b reads the cookies)
    # -w "%{http_code}" captures the HTTP status code at the end
    # -o captures the JSON payload output into a temporary file
    HTTP_STATUS=$(curl -s -X POST "$DATA_URL" \
        -b "$COOKIE_FILE" \
        -c "$COOKIE_FILE" \
        -H "Accept: application/json, text/plain, */*" \
        -H "Accept-Encoding: gzip, deflate" \
        -H "Accept-Language: en-US,en;q=0.9,th;q=0.8" \
        -H "Origin: http://192.168.2.22" \
        -H "Referer: http://192.168.2.22/wms/Mobile/Preparing" \
        -H "Content-Type: application/json" \
        -d "$DATA_BODY" \
        -w "%{http_code}" \
        -o "$OUTPUT_FILE.tmp")

    # Check the result
    if [ "$HTTP_STATUS" -eq 200 ]; then
        # Move temporary file to final output location (overwriting old data)
        mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"
        echo "[$TIMESTAMP] Successfully saved to $OUTPUT_FILE"
    elif [ "$HTTP_STATUS" -eq 401 ] || [ "$HTTP_STATUS" -eq 403 ]; then
        echo "[$TIMESTAMP] Session expired (Status $HTTP_STATUS). Re-authenticating..."
        rm -f "$COOKIE_FILE"  # Clear old cookie file
        do_login
    else
        echo "[$TIMESTAMP] Server error or connection issue (Status Code: $HTTP_STATUS)"
        rm -f "$OUTPUT_FILE.tmp"
    fi

    # Wait for 60 seconds
    sleep 60
done
