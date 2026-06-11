#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="upsell-recommendation"
REGION="us-central1"
MODEL="gemini-1.5-flash"

echo "==> Testing models..."
for m in "gemini-1.5-flash" "gemini-1.5-pro" "gemini-1.0-pro"; do
  echo -n "$m: "
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    "https://${REGION}-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/${REGION}/publishers/google/models/${m}:generateContent" \
    -H "Content-Type: application/json" \
    -d '{"contents":[{"parts":[{"text":"Say hello"}]}]}')
  echo "$STATUS"
done
exit 0


