#!/usr/bin/env bash
set -euo pipefail

# ==============================================================
# GCP Cloud Run Deployment Script
# ==============================================================

PROJECT_ID="upsell-recommendation"
REGION="us-central1"
REPO_NAME="upsell-api"
IMAGE_NAME="upsell-backend"
SERVICE_NAME="upsell-recommendations"
IMAGE_TAG="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:latest"

echo "==> Pulling latest code..."
git pull

echo "==> Setting project..."
gcloud config set project $PROJECT_ID

echo "==> Enabling APIs..."
gcloud services enable run.googleapis.com artifactregistry.googleapis.com aiplatform.googleapis.com cloudbuild.googleapis.com

echo "==> Creating Artifact Registry repo (if not exists)..."
gcloud artifacts repositories create $REPO_NAME \
  --repository-format=docker \
  --location=$REGION 2>/dev/null || echo "    (already exists)"

echo "==> Building & pushing image via Cloud Build..."
gcloud builds submit ./backend --tag $IMAGE_TAG

echo "==> Deploying to Cloud Run..."
gcloud run deploy $SERVICE_NAME \
  --image=$IMAGE_TAG \
  --region=$REGION \
  --platform=managed \
  --allow-unauthenticated \
  --set-env-vars="GCP_PROJECT_ID=${PROJECT_ID},GCP_LOCATION=${REGION},ALLOWED_ORIGINS=https://upsell-recommendations.vercel.app" \
  --memory=512Mi \
  --cpu=1 \
  --min-instances=0 \
  --max-instances=10

echo ""
echo "==> Deployed! Service URL:"
gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)"
