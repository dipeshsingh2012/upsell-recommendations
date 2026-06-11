"""FastAPI application entry point with CORS security configuration."""

import os

from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .router import router

load_dotenv()

app = FastAPI(
    title="Upsell & Recommendations API",
    version="1.0.0",
    description="Real-time AI-powered product recommendation engine",
)

# Security: Explicit CORS allowlist for Vercel frontend <-> Cloud Run backend
allowed_origins = os.getenv("ALLOWED_ORIGINS", "http://localhost:5173").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["GET", "OPTIONS"],
    allow_headers=["*"],
)

app.include_router(router)


@app.get("/health")
async def health():
    return {"status": "healthy"}
