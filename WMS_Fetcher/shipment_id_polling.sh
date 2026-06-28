#!/bin/bash

# Define the input file containing the extracted data
INPUT_FILE="/tmp/shipment_id.txt"
COOKIE_FILE="/tmp/wms_cookiesK0.txt" # Where curl will store the session IDs

# 1. Define your custom function here
process_shipment() {
    local shipment_id="$1"
    local external_id="$2"

    echo "--------------------------------------------"
    echo "Processing Shipment ID : $shipment_id"
    echo "Associated External ID : $external_id"
    
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
  DATA_DATE=$(date '+%Y-%m-%d')
  echo "[$TIMESTAMP] Fetching data..."

  # Define the exact JSON payload matching your PowerShell request
  TARGET_URL="https://docs.google.com/forms/d/e/1FAIpQLSc2iBPJXs8BxcD2uVVmNeNOMMyZRWQ141AieWt9QjL8CTlMcA/formResponse"
  DATA_BODY='{"shipmentId":'$shipment_id'}'
  
  TMPFILE=$(mktemp)
  # Execute request using the stored cookies (-b reads the cookies)
  # -w "%{http_code}" captures the HTTP status code at the end
  # -o captures the JSON payload output into a temporary file
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
      -o "$TMPFILE") \
	  
  NEW_KEY="External ID"
  NEW_VAL="$external_id"
  
  jq 'map(.ExternalID = "'$NEW_VAL'")' $TMPFILE > $TMPFILE".xxx" && mv $TMPFILE".xxx" $TMPFILE

  # Check the result
  if [ "$HTTP_STATUS" -eq 200 ]; then
      echo "[$TIMESTAMP] Successfully saved to $OUTPUT_FILE"
	  HTTP_STATUS=$(curl -s -X POST "$TARGET_URL" \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.9,th;q=0.8' \
    -H 'Connection: keep-alive' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0' \
    --data-urlencode "entry.1744730708=UPDATE_SHIPMENT" \
    --data-urlencode "entry.69501207@$TMPFILE" \
    --insecure \
    -w "%{http_code}" \
    -o "/dev/null)" \
	
	if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ]; then
    echo "✅ Success! (HTTP Status: $HTTP_STATUS)"
	rm -f $TMPFILE
    # Google Forms usually returns a large HTML success page, 
    # so we'll just show the status code instead of printing the whole HTML page.
else
    echo "❌ Submission Failed. (HTTP Status: $HTTP_STATUS)"
    echo "--- Server Response ---"
    echo ""
fi
  elif [ "$HTTP_STATUS" -eq 401 ] || [ "$HTTP_STATUS" -eq 403 ]; then
      echo "[$TIMESTAMP] Session expired (Status $HTTP_STATUS). Re-authenticating..."
      rm -f "$COOKIE_FILE"  # Clear old cookie file
      do_login
  else
      echo "[$TIMESTAMP] Server error or connection issue (Status Code: $HTTP_STATUS)"
      rm -f "$OUTPUT_FILE.tmp"
  fi
}

# 2. Safety check: Verify the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: The file '$INPUT_FILE' does not exist."
    echo "Please run your extraction script first."
    exit 1
fi

echo "Starting batch processing..."

# 3. Read the file row-by-row
# Bash natively splits space-separated or tab-separated tokens into the variables provided
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
