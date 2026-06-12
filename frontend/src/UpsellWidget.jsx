import { useState, useEffect } from "react";

const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";

export default function UpsellWidget({ userId = "demo-user-42" }) {
  const [recommendations, setRecommendations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(`${API_URL}/api/v1/dummy/${userId}`)
      .then((res) => {
        if (!res.ok) throw new Error(`API error: ${res.status}`);
        return res.json();
      })
      .then((data) => setRecommendations(data.recommendations))
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, [userId]);

  if (loading)
    return (
      <div className="flex items-center justify-center py-10">
        <div className="animate-spin h-10 w-10 border-4 border-indigo-500 border-t-transparent rounded-full" />
      </div>
    );

  if (error)
    return <p className="text-red-600 text-lg font-medium">Error: {error}</p>;

  return (
    <div>
      <h2 className="text-3xl font-bold text-gray-900 mb-2">
        Personalized Recommendations
      </h2>
      <p className="text-gray-500 mb-8">
        AI-powered upsell suggestions tailored to your profile
      </p>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {recommendations.map((item) => (
          <div
            key={item.id}
            className="bg-white rounded-2xl shadow-md hover:shadow-xl transition-shadow p-6 flex flex-col"
          >
            <h2 className="text-lg font-semibold text-gray-800 mb-2">
              {item.title}
            </h2>
            <p className="text-gray-600 text-sm flex-1 mb-4">
              {item.description}
            </p>
            <div className="flex items-center justify-between mb-3">
              <span className="text-2xl font-bold text-indigo-600">
                ${item.price.toFixed(2)}
              </span>
            </div>
            <div className="bg-indigo-50 rounded-lg px-3 py-2">
              <p className="text-xs text-indigo-700 font-medium">
                💡 {item.matching_reason}
              </p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
