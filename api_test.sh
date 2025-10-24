#!/bin/bash
# ======================================================
# Lucio API Automation Script
# Author: Sai Kumar Mojjada
# Description: Fully automated sequence for Lucio challenge
# ======================================================

set -e  # Exit on error
mkdir -p logs

NAME="Sai Kumar Mojjada"
EMAIL="saikumarmsk7799@gmail.com"
CLUB="lucio"
OUTPUT_FILE="logs/output.json"

echo "🔹 Starting Lucio API automation..."
echo "--------------------------------------"

# Step 1: Begin - Get token and timestamp
echo "🔹 Sending /begin request..."
RESPONSE=$(curl -s -X POST "https://workwithus.lucioai.com/begin" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$NAME\",\"email\":\"$EMAIL\"}")

TOKEN=$(echo "$RESPONSE" | jq -r '.token')
DATE=$(echo "$RESPONSE" | jq -r '.date')

if [[ "$TOKEN" == "null" || -z "$TOKEN" ]]; then
  echo "❌ Failed to get token. Response: $RESPONSE"
  exit 1
fi

echo "✅ Token saved successfully."
echo "$TOKEN" > token.txt
echo "📅 Using timestamp: $DATE"

# Step 2: Compute SHA256 hash
DATA="$NAME|$EMAIL|$DATE|$CLUB"
HASH_HEX=$(echo -n "$DATA" | sha256sum | awk '{print $1}')
HASH_B64=$(echo -n "$DATA" | sha256sum | xxd -r -p | base64 | tr '+/' '-_' | tr -d '=')

echo "🔹 Computing SHA256 hash..."
echo "   Input: $DATA"
echo "   Hex: $HASH_HEX"
echo "   Base64: $HASH_B64"

# Step 3: Send /get-carded request
echo "🔹 Sending /get-carded request..."
GET_CARDED=$(curl -s -X POST "https://workwithus.lucioai.com/get-carded" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-Stamp: $HASH_B64" \
  -H "X-Access-Code: $HASH_HEX" \
  -H "X-Email: $EMAIL" \
  -H "Content-Type: application/json" \
  -d "{\"stamp\":\"$HASH_B64\",\"access_code\":\"$HASH_HEX\"}")

echo "$GET_CARDED" | tee "$OUTPUT_FILE"

# Check if successful
if echo "$GET_CARDED" | grep -q "Hmmm"; then
  echo "⚠️ /get-carded failed. Check output.json for details."
  exit 1
fi

echo "✅ /get-carded successful!"

# Step 4: Find the bar
echo "🔹 Checking /find-the-bar..."
BAR_RESPONSE=$(curl -s -X GET "https://workwithus.lucioai.com/find-the-bar" \
  -H "Authorization: Bearer $TOKEN")

echo "$BAR_RESPONSE" | tee -a "$OUTPUT_FILE"

if echo "$BAR_RESPONSE" | grep -q "lost"; then
  echo "⚠️ /find-the-bar did not pass. Check output.json."
else
  echo "🎉 Congratulations! You completed the Lucio API challenge!"
fi

echo "✅ Logs saved to $OUTPUT_FILE"
echo "--------------------------------------"
echo "🎯 Script completed."

