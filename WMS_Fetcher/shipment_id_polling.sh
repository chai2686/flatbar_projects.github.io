#!/bin/bash

# Define the input file containing the extracted data
INPUT_FILE="/tmp/shipment_id.txt"
COOKIE_FILE="/tmp/wms_cookiesK0.txt" # Where curl will store the session IDs

# --- PLACEHOLDER FUNCTION FOR LOGIN ---
# Define your login logic here so the script can recover when a session expires
do_login() {
    echo "Attempting to re-authenticate..."
    # Example: curl -s -c "$COOKIE_FILE" -d "username=X&password=Y" https://.../login
}

# 1. Define your custom function here
process_shipment() {
    local shipment_id="$1"
    local external_id="$2"

    echo "--------------------------------------------"
    echo "Processing Shipment ID : $shipment_id"
    echo "Associated External ID : $external_id"
    
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] Fetching data..."

    # Define the exact JSON payload matching your request
    TARGET_URL="https://docs.google.com/forms/d/e/1FAIpQLSc2iBPJXs8BxcD2uVVmNeNOMMyZRWQ141AieWt9QjL8CTlMcA/formResponse"
    DATA_BODY='{"shipmentId":'$shipment_id'}'
    
    TMPFILE=$(mktemp)

    # Execute request using the stored cookies (-b reads the cookies)
    HTTP_STATUS=$(curl -s -X POST "https://psychic-driveway-starboard.ngrok-free.dev/WMS/Center/GetExplainInfo" \
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
        -o "$TMPFILE")
	  
    # Check the initial server response
    if [ "$HTTP_STATUS" -eq 200 ]; then
        echo "[$TIMESTAMP] Successfully fetched API data. Injecting ExternalID..."
        
        # Safely pass external_id into jq using --arg. 
        # Handles both JSON arrays and single JSON objects natively.
        jq --arg ext "$external_id" 'if type == "array" then map(.ExternalID = $ext) else .ExternalID = $ext end' "$TMPFILE" > "${TMPFILE}.xxx" && mv "${TMPFILE}.xxx" "$TMPFILE"

        echo "[$TIMESTAMP] Submitting modified payload to Google Forms..."
        
        # FIXED: Removed trailing syntax error " -o "/dev/null)" \ "
        FORM_STATUS=$(curl -s -X POST "$TARGET_URL" \
            -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
            -H 'Accept-Language: en-US,en;q=0.9,th;q=0.8' \
            -H 'Connection: keep-alive' \
            -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0' \
            --data-urlencode "entry.1744730708=UPDATE_SHIPMENT" \
            --data-urlencode "entry.69501207@$TMPFILE" \
            --insecure \
            -w "%{http_code}" \
            -o /dev/null)
	
        if [ "$FORM_STATUS" -ge 200 ] && [ "$FORM_STATUS" -lt 300 ]; then
            echo "✅ Success! Google Form submitted. (HTTP Status: $FORM_STATUS)"
        else
            echo "❌ Submission Failed to Google Forms. (HTTP Status: $FORM_STATUS)"
        fi

    elif [ "$HTTP_STATUS" -eq 401 ] || [ "$HTTP_STATUS" -eq 403 ]; then
        echo "[$TIMESTAMP] Session expired (Status $HTTP_STATUS). Re-authenticating..."
        rm -f "$COOKIE_FILE"  # Clear old cookie file
        do_login
    else
        echo "[$TIMESTAMP] Server error or connection issue (Status Code: $HTTP_STATUS)"
    fi

    # Always clean up the temporary file at the end of the function loop
    rm -f "$TMPFILE" "${TMPFILE}.xxx"
}

# 2. Safety check: Verify the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: The file '$INPUT_FILE' does not exist."
    echo "Please run your extraction script first."
    exit 1
fi

echo "Starting batch processing..."

# 3. Read the file row-by-row
while read -r shipment_id external_id || [ -n "$shipment_id" ]; do
    
    # Skip empty lines if they exist in the file
    if [ -z "$shipment_id" ] || [ -z "$external_id" ]; then
        continue
    fi

    # 4. Trigger the function for each row
    process_shipment "$shipment_id" "$external_id"

done < "$INPUT_FILE"

echo "--------------------------------------------"
echo "All shipments have been processed successfully!"
