"""API router orchestrating the recommendation request lifecycle."""

from fastapi import APIRouter, HTTPException

from .schemas import Recommendation, RecommendationResponse
from .vertex_service import generate_recommendations

router = APIRouter(prefix="/api/v1", tags=["recommendations"])


@router.get("/recommendations/{user_id}", response_model=RecommendationResponse)
async def get_recommendations(user_id: str):
    """Orchestrate: receive request -> call Vertex AI -> validate -> respond."""
    try:
        raw = await generate_recommendations(user_id)
        # Validate each item against Pydantic schema before returning
        recommendations = [Recommendation(**item) for item in raw]
    except Exception as e:
        raise HTTPException(status_code=502, detail=f"AI service error: {str(e)}")

    return RecommendationResponse(user_id=user_id, recommendations=recommendations)
