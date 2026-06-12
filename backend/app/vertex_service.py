"""Async service for Vertex AI Gemini API calls with guaranteed JSON output."""

import json
import os
import re

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


PERSONA_CONTEXT = {
    "small_business": "a small business owner who needs branding and marketing materials",
    "marketing": "a marketing professional running campaigns and promotions",
    "event_planner": "an event planner organizing weddings, parties, and corporate events",
    "personal": "an individual looking for personal projects like gifts and custom items",
}


async def generate_recommendations(user_id: str, name: str = "", persona: str = "") -> list[dict]:
    """Call Gemini to produce contextual upsell recommendations as structured JSON."""
    _ensure_init()

    model = GenerativeModel("gemini-2.5-flash")

    user_context = f"named '{name}' " if name else ""
    persona_context = PERSONA_CONTEXT.get(persona, "a general customer")
    prompt = (
        f"You are a product recommendation engine for a print & design e-commerce store "
        f"(similar to Vistaprint). Generate exactly 4 product upsell recommendations "
        f"for user {user_context}who is {persona_context}. "
        f"Products should be from categories like: business cards, flyers, banners, "
        f"t-shirts, mugs, stickers, postcards, invitations, signage, labels, letterheads, envelopes. "
        f"Each item MUST have these fields: "
        f"id (int), title (string), description (string), price (float > 0), "
        f"matching_reason (string explaining why this product suits the user). "
        f"Return ONLY a JSON array of objects."
    )

    generation_config = GenerationConfig(
        response_mime_type="application/json",
        temperature=0.7,
        max_output_tokens=4096,
    )

    # Vertex AI SDK's generate_content_async provides true async I/O
    response = await model.generate_content_async(
        prompt,
        generation_config=generation_config,
    )

    text = response.text.strip()
    # Strip markdown code fences if present
    text = re.sub(r"^```json\s*", "", text)
    text = re.sub(r"\s*```$", "", text)
    # Fix trailing commas before ] or }
    text = re.sub(r",\s*([\]}])", r"\1", text)
    return json.loads(text)
