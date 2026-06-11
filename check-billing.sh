#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="upsell-recommendation"

echo "==> Billing accounts:"
gcloud billing accounts list

echo ""
echo "==> Project billing info:"
gcloud billing projects describe $PROJECT_ID
