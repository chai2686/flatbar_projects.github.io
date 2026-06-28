#!/bin/bash

FILE_PATH="preparing_data_test.txt"
RESPONSE_FILE="execute_response_test.txt"

TARGET_URL="https://script.google.com/macros/s/AKfycbzW6tBfvo3qPaLPDMgl4FBWJyrZO170hZbdmQpqlO69VLSJueCaHJb5GwLfPYAXd7Px6Q/exec"

curl -s -X POST "$TARGET_URL" \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.9,th;q=0.8' \
    -H 'Connection: keep-alive' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0' \
    --data-urlencode "action=apiprocess&api=PREPARING_K8&apicontent=$FILE_PATH" \
    --insecure \
    -w "%{http_code}" \
    -o "$RESPONSE_FILE" \
