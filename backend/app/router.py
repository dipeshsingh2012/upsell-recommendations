"""API router orchestrating the recommendation request lifecycle."""

from fastapi import APIRouter, HTTPException

from .schemas import Recommendation, RecommendationResponse
from .vertex_service import generate_recommendations

router = APIRouter(prefix="/api/v1", tags=["recommendations"])


@router.get("/recommendations/{user_id}", response_model=RecommendationResponse)
async def get_recommendations(user_id: str, name: str = ""):
    """Orchestrate: receive request -> call Vertex AI -> validate -> respond."""
    try:
        raw = await generate_recommendations(user_id, name)
        recommendations = [Recommendation(**item) for item in raw]
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"AI service error: {str(e)}")

    return RecommendationResponse(user_id=user_id, recommendations=recommendations)


@router.get("/dummy/{user_id}", response_model=RecommendationResponse)
async def get_dummy_recommendations(user_id: str):
    """Return dummy recommendations for testing connectivity."""
    dummy = [
        {"id": 1, "title": "Wireless Earbuds Pro", "description": "Premium noise-cancelling earbuds", "price": 79.99, "matching_reason": "Based on your audio preferences"},
        {"id": 2, "title": "Laptop Stand", "description": "Ergonomic aluminum stand", "price": 45.00, "matching_reason": "Complements your recent laptop purchase"},
        {"id": 3, "title": "USB-C Hub", "description": "7-in-1 multiport adapter", "price": 34.99, "matching_reason": "Popular with similar buyers"},
        {"id": 4, "title": "Desk Lamp", "description": "LED lamp with adjustable brightness", "price": 29.99, "matching_reason": "Trending in your category"},
    ]
    recommendations = [Recommendation(**item) for item in dummy]
    return RecommendationResponse(user_id=user_id, recommendations=recommendations)
