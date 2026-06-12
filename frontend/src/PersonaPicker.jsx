const PERSONAS = [
  { id: "small_business", label: "Small Business Owner", icon: "🏪" },
  { id: "marketing", label: "Marketing Professional", icon: "📈" },
  { id: "event_planner", label: "Event Planner", icon: "🎉" },
  { id: "personal", label: "Individual / Personal Use", icon: "🙋" },
];

export default function PersonaPicker({ onSelect }) {
  return (
    <div className="flex flex-col items-center justify-center min-h-[60vh]">
      <h2 className="text-2xl font-bold text-gray-900 mb-2">What best describes you?</h2>
      <p className="text-gray-500 mb-8">We'll personalize your recommendations</p>
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 w-full max-w-lg">
        {PERSONAS.map((p) => (
          <button
            key={p.id}
            onClick={() => onSelect(p.id)}
            className="flex items-center gap-3 p-4 rounded-xl border-2 border-gray-200 hover:border-indigo-500 hover:bg-indigo-50 transition-all text-left"
          >
            <span className="text-3xl">{p.icon}</span>
            <span className="font-medium text-gray-800">{p.label}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
