#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="upsell-recommendation"
REGION="us-central1"
MODEL="gemini-2.0-flash-lite"

echo "==> Testing Gemini model access..."
curl -s -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  "https://${REGION}-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/${REGION}/publishers/google/models/${MODEL}:generateContent" \
  -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"Say hello"}]}'
echo ""
