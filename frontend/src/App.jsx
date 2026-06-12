import { useState, useEffect } from "react";
import { onAuthStateChanged, signInWithPopup, signOut } from "firebase/auth";
import { auth, googleProvider } from "./firebase";
import UpsellWidget from "./UpsellWidget";

export default function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => onAuthStateChanged(auth, (u) => { setUser(u); setLoading(false); }), []);

  if (loading) return null;

  if (!user)
    return (
      <div className="flex items-center justify-center min-h-screen">
        <button
          onClick={() => signInWithPopup(auth, googleProvider)}
          className="bg-indigo-600 text-white px-6 py-3 rounded-lg text-lg font-medium hover:bg-indigo-700"
        >
          Sign in with Google
        </button>
      </div>
    );

  return (
    <div className="max-w-6xl mx-auto px-4 py-10">
      <div className="flex justify-between items-center mb-8">
        <p className="text-gray-600">Hey, {user.displayName}</p>
        <button
          onClick={() => signOut(auth)}
          className="text-sm text-gray-500 hover:text-gray-800"
        >
          Sign out
        </button>
      </div>
      <UpsellWidget userId={user.uid} />
    </div>
  );
}
