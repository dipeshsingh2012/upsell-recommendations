# Upsell & Recommendations Dashboard

Real-time AI-powered e-commerce recommendation engine using FastAPI + Vertex AI Gemini + React.

## Architecture

```
[React/Vite Frontend] --HTTPS--> [FastAPI on Cloud Run] --gRPC--> [Vertex AI Gemini]
     (Vercel)                        (Docker Container)            (Model Garden)
```

## Quick Start (Local Development)

### Backend

```bash
cd backend
copy .env.example .env        # Edit with your GCP project details
uv sync
uv run uvicorn app.main:app --reload --port 8000
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

Frontend: http://localhost:5173 | Backend: http://localhost:8000/docs

## Deployment

See `deploy.sh` for the full GCP Cloud Run deployment checklist.

## Tech Stack

- **Backend**: Python 3.11, FastAPI, Pydantic v2, Vertex AI SDK
- **Frontend**: React 18, Vite, Tailwind CSS
- **Infrastructure**: Docker, GCP Cloud Run, Artifact Registry
- **AI**: Gemini 1.5 Flash via Vertex AI Model Garden
