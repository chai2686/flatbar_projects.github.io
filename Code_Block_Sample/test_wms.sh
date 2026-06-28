#!/bin/bash

FILE_PATH="/tmp/preparing_data.txt"
RESPONSE_FILE="/tmp/execute_response_test.txt"
TARGET_URL="https://script.google.com/macros/s/AKfycbyHukT2sYQ5XRrOf7DgJ0YaaA5O0dIsebw4i-OgCcRTvCQHkwAvNiNWAM0sY9ephlfZJQ/exec"

# Safety check: Ensure the source data file actually exists before sending
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: Source file $FILE_PATH does not exist."
    exit 1
fi

# Execute curl request
# -L: Follows Google's 302 redirects (Required)
# -o: Directs the response text body into your RESPONSE_FILE
# -w: Ensures ONLY the 3-digit HTTP code is caught by the HTTP_STATUS variable
HTTP_STATUS=$(curl -s -L -X POST "$TARGET_URL" \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.9,th;q=0.8' \
    -H 'Connection: keep-alive' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0' \
    --data-urlencode "action=apiprocess" \
    --data-urlencode "api=PREPARING_K8" \
    --data-urlencode "apicontent=$(<"$FILE_PATH")" \
    --insecure \
    -o "$RESPONSE_FILE" \
    -w "%{http_code}" \
)

# Output results to terminal
echo "HTTP Status Code: $HTTP_STATUS"
echo "Response Body saved to: $RESPONSE_FILE"
echo "Actual Response: $(cat "$RESPONSE_FILE")"
