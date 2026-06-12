# Upsell & Recommendations Dashboard

Real-time AI-powered e-commerce recommendation engine using FastAPI + Vertex AI Gemini + React MFE.

## Architecture

```
[Host App (Vercel)] --Module Federation--> [Remote MFE (Vercel)] --HTTPS--> [FastAPI (Cloud Run)] --gRPC--> [Vertex AI Gemini]
```

## Quick Start (Local Development)

### Backend

```bash
cd backend
copy .env.example .env        # Edit with your GCP project details
uv sync
uv run uvicorn app.main:app --reload --port 8000
```

### Frontend (Remote MFE)

```bash
cd frontend
npm install
npm run build
npm run preview               # http://localhost:4173
```

### Host App

```bash
cd host
npm install
npm run build
npm run preview               # http://localhost:4174
```

## Deployment

- **Backend**: Auto-deploys to Cloud Run on push to `main` (via GitHub Actions)
- **Frontend (Remote)**: Vercel (root: `frontend`)
- **Host**: Vercel (root: `host`, set `VITE_REMOTE_URL` env var to remote's URL)

## Tech Stack

- **Backend**: Python 3.11, FastAPI, Pydantic v2, Vertex AI SDK, uv
- **Frontend**: React 18, Vite, Tailwind CSS, Module Federation
- **Infrastructure**: Docker, GCP Cloud Run, Vercel, GitHub Actions
- **AI**: Gemini 1.5 Flash via Vertex AI Model Garden
