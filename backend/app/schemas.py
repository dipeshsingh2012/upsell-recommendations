"""Pydantic v2 schemas enforcing strict data contracts for recommendation payloads."""

from pydantic import BaseModel, Field


class Recommendation(BaseModel):
    id: int = Field(..., description="Unique product identifier")
    title: str = Field(..., min_length=1, max_length=200)
    description: str = Field(..., min_length=1, max_length=500)
    price: float = Field(..., gt=0)
    matching_reason: str = Field(..., min_length=1, max_length=300)


class RecommendationResponse(BaseModel):
    user_id: str
    recommendations: list[Recommendation]
