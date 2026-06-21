#!/bin/bash

# --- Version 2.4
# --- Configuration ---
  OUTPUT_FILE="/tmp/k8_preparing_data.txt"
  COOKIE_FILE="/tmp/wms_cookies.txt" # Where curl will store the session IDs

  DATA_URL="http://192.168.2.22/wms/api/PrepareTaskUser/QueryUnclaimPreparedTrans"

  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
	DATA_DATE=$(date '+%Y-%m-%d')
	GATE_ID=$1
    echo "[$TIMESTAMP] Fetching data..."

    # Define the exact JSON payload matching your PowerShell request
    DATA_BODY='{"deliveryDate":"'$DATA_DATE'T09:50:58.371Z","doItemDesc":"","companyName":"","materialCode":"","materialName":"","batch":"","storageSAP":"","workStyle":"","gateId":"'$GATE_ID'","loadOptions":{"sort":null,"group":null,"requireTotalCount":true,"searchOperation":"contains","searchValue":null,"skip":0,"take":20,"userData":{}}}'

    # Execute request using the stored cookies (-b reads the cookies)
    # -w "%{http_code}" captures the HTTP status code at the end
    # -o captures the JSON payload output into a temporary file
    HTTP_STATUS=$(curl -s -X POST "$DATA_URL" \
        -b "$COOKIE_FILE" \
        -c "$COOKIE_FILE" \
        -H 'Accept: application/json, text/plain, */*' \
  		-H 'Accept-Language: en-US,en;q=0.9,th;q=0.8' \
  		-H 'Connection: keep-alive' \
  		-H 'Content-Type: application/json' \
  		-H 'Origin: http://192.168.2.22' \
  		-H 'Referer: http://192.168.2.22/wms/Mobile/Preparing' \
  		-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0' \
        --data-raw "$DATA_BODY" \
		--insecure \
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
