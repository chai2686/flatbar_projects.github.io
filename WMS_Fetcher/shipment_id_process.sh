#!/bin/bash

INPUT_FILE="/tmp/shipment_id.json"
OUTPUT_FILE="/tmp/shipment_id.txt"

# Extract all ShipmentIDs
grep -o '"ShipmentID":[0-9]*' "$INPUT_FILE" | cut -d: -f2 > /tmp/ids.txt

# Extract all ExternalIDs and remove quotes
grep -o '"ExternalID":"[^"]*"' "$INPUT_FILE" | cut -d: -f2 | tr -d '"' > /tmp/ext_ids.txt

# Combine them row by row (separated by a tab)
paste /tmp/ids.txt /tmp/ext_ids.txt > "$OUTPUT_FILE"

# Clean up temporary files
rm /tmp/ids.txt /tmp/ext_ids.txt

echo "Extraction complete! Output saved to $OUTPUT_FILE"
