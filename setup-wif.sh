#!/usr/bin/env bash
set -euo pipefail

# ==============================================================
# Setup Workload Identity Federation for GitHub Actions
# Run this once from a machine with gcloud authenticated as owner/admin
# ==============================================================

PROJECT_ID="upsell-recommendation"
GITHUB_ORG="YOUR_GITHUB_USERNAME_OR_ORG"  # <-- EDIT THIS
GITHUB_REPO="upsell-recommendations"      # <-- EDIT THIS
SA_NAME="github-deployer"
POOL_NAME="github"
PROVIDER_NAME="github-provider"

echo "==> Setting project..."
gcloud config set project $PROJECT_ID

echo "==> Enabling IAM APIs..."
gcloud services enable iamcredentials.googleapis.com

echo "==> Creating service account..."
gcloud iam service-accounts create $SA_NAME \
  --display-name="GitHub Actions Deployer" 2>/dev/null || echo "    (already exists)"

SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

echo "==> Granting roles to service account..."
for ROLE in roles/run.admin roles/cloudbuild.builds.editor roles/artifactregistry.writer roles/iam.serviceAccountUser; do
  gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:${SA_EMAIL}" \
    --role="$ROLE" \
    --quiet
done

echo "==> Creating workload identity pool..."
gcloud iam workload-identity-pools create $POOL_NAME \
  --location="global" \
  --display-name="GitHub Actions" 2>/dev/null || echo "    (already exists)"

echo "==> Creating OIDC provider..."
gcloud iam workload-identity-pools providers create-oidc $PROVIDER_NAME \
  --location="global" \
  --workload-identity-pool=$POOL_NAME \
  --display-name="GitHub" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com" 2>/dev/null || echo "    (already exists)"

echo "==> Binding service account to GitHub repo..."
gcloud iam service-accounts add-iam-policy-binding $SA_EMAIL \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')/locations/global/workloadIdentityPools/${POOL_NAME}/attribute.repository/${GITHUB_ORG}/${GITHUB_REPO}"

echo ""
echo "==> Done! Add these as GitHub repo secrets:"
echo ""
echo "WIF_PROVIDER:"
echo "  projects/$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')/locations/global/workloadIdentityPools/${POOL_NAME}/providers/${PROVIDER_NAME}"
echo ""
echo "WIF_SERVICE_ACCOUNT:"
echo "  ${SA_EMAIL}"
