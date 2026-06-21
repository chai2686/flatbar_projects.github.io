#!/bin/bash

# --- Configuration ---
FILE_PATH="/tmp/preparing_data"$1".txt"  # Change this to the path of your actual text file
TARGET_URL="https://docs.google.com/forms/d/e/1FAIpQLSc2iBPJXs8BxcD2uVVmNeNOMMyZRWQ141AieWt9QjL8CTlMcA/formResponse"
RESPONSE_FILE="/tmp/execute_response.txt"

# --- 1. File Verification ---
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File '$FILE_PATH' does not exist."
    exit 1
fi

echo "Reading content from '$FILE_PATH' and submitting to Google Forms..."

# --- 2. Execute Request ---
# -s: Silent mode
# -w "%{http_code}": Outputs the HTTP status code
# -o "$RESPONSE_FILE": Saves the server's reply
# --data-urlencode "name@filename": Reads the file and safely URL-encodes the content

HTTP_STATUS=$(curl -s -X POST "$TARGET_URL" \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.9,th;q=0.8' \
    -H 'Connection: keep-alive' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0' \
    --data-urlencode "entry.1744730708=PREPARING_K8" \
    --data-urlencode "entry.69501207@$FILE_PATH" \
    --insecure \
    -w "%{http_code}" \
    -o "$RESPONSE_FILE")

# --- 3. Evaluate the Result ---
if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 300 ]; then
    echo "✅ Success! (HTTP Status: $HTTP_STATUS)"
    # Google Forms usually returns a large HTML success page, 
    # so we'll just show the status code instead of printing the whole HTML page.
else
    echo "❌ Submission Failed. (HTTP Status: $HTTP_STATUS)"
    echo "--- Server Response ---"
    cat "$RESPONSE_FILE"
    echo ""
fi

# Clean up the temporary response file
rm -f "$RESPONSE_FILE"
