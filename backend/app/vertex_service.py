"""Async service for Vertex AI Gemini API calls with guaranteed JSON output."""

import json
import os

from vertexai.generative_models import GenerativeModel, GenerationConfig
import vertexai


_initialized = False


def _ensure_init():
    """Lazy-initialize Vertex AI SDK once."""
    global _initialized
    if not _initialized:
        vertexai.init(
            project=os.getenv("GCP_PROJECT_ID"),
            location=os.getenv("GCP_LOCATION", "us-central1"),
        )
        _initialized = True


async def generate_recommendations(user_id: str) -> list[dict]:
    """Call Gemini to produce contextual upsell recommendations as structured JSON.

    Uses response_mime_type to guarantee valid JSON output from the model,
    eliminating the need for fragile regex parsing.
    """
    _ensure_init()

    model = GenerativeModel("gemini-2.0-flash-lite")

    prompt = (
        f"You are a retail personalization engine. Generate exactly 4 product upsell "
        f"recommendations for user '{user_id}'. Each item MUST have these fields: "
        f"id (int), title (string), description (string), price (float > 0), "
        f"matching_reason (string explaining why this product suits the user). "
        f"Return ONLY a JSON array of objects."
    )

    generation_config = GenerationConfig(
        response_mime_type="application/json",
        temperature=0.7,
        max_output_tokens=1024,
    )

    # Vertex AI SDK's generate_content_async provides true async I/O
    response = await model.generate_content_async(
        prompt,
        generation_config=generation_config,
    )

    return json.loads(response.text)
