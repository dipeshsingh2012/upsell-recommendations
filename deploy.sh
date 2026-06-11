#!/usr/bin/env bash
# ==============================================================
# GCP Cloud Run Deployment Commands
# ==============================================================

# --- Configuration (edit these) ---
PROJECT_ID="upsell-recommendation"
REGION="us-central1"
REPO_NAME="upsell-api"
IMAGE_NAME="upsell-backend"
SERVICE_NAME="upsell-recommendations"

# --- Step 1: Authenticate & set project ---
gcloud auth login
gcloud config set project $PROJECT_ID

# --- Step 2: Enable required APIs ---
gcloud services enable \
  run.googleapis.com \
  artifactregistry.googleapis.com \
  aiplatform.googleapis.com

# --- Step 3: Create Artifact Registry repository (one-time) ---
gcloud artifacts repositories create $REPO_NAME \
  --repository-format=docker \
  --location=$REGION

# --- Step 4: Configure Docker authentication ---
gcloud auth configure-docker ${REGION}-docker.pkg.dev

# --- Step 5: Build & push container image ---
cd backend

docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:latest .

docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:latest

# --- Step 6: Deploy to Cloud Run ---
gcloud run deploy $SERVICE_NAME \
  --image=${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${IMAGE_NAME}:latest \
  --region=$REGION \
  --platform=managed \
  --allow-unauthenticated \
  --set-env-vars="GCP_PROJECT_ID=${PROJECT_ID},GCP_LOCATION=${REGION},ALLOWED_ORIGINS=https://your-app.vercel.app" \
  --memory=512Mi \
  --cpu=1 \
  --min-instances=0 \
  --max-instances=10

# --- Step 7: Get the deployed URL ---
gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)"
