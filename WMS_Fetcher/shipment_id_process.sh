#!/bin/bash
# --- Version 2.6
# --- Configuration ---

set -euo pipefail # ช่วยหยุดทำงานทันทีหากเกิดข้อผิดพลาด

INPUT_FILE="/tmp/shipment_id.json"
OUTPUT_FILE="/tmp/shipment_id.txt"

# 1. ตรวจสอบว่ามีไฟล์ Input อยู่จริงไหม
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: ไม่พบไฟล์อินพุต $INPUT_FILE" >&2
    exit 1
fi

# 2. ตรวจสอบว่าเครื่องมี jq หรือไม่
if ! command -v jq &> /dev/null; then
    echo "Error: กรุณาติดตั้ง 'jq' ก่อนใช้งาน (คำสั่ง: sudo apt install jq)" >&2
    exit 1
fi

# 3. ดึงข้อมูลและแปลงเป็น Tab-Separated Values (TSV) ในคำสั่งเดียว
# คีย์ไหนไม่มีจะใส่ค่าว่างให้อัตโนมัติ ข้อมูลไม่เยื้องแน่นอน
jq -r '.[] | [.ShipmentID, .ExternalID, .WorkTypeDesc] | @tsv' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Extraction complete! Output saved to $OUTPUT_FILE"
