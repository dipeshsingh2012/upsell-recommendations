#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="upsell-recommendation"
REGION="us-central1"

echo "==> Listing available publisher models..."
curl -s -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  "https://${REGION}-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/${REGION}/publishers/google/models"
echo ""
