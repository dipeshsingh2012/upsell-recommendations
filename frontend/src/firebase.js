import { initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyBcEW0KiLRKcRMOyRRu-qJ9XWMdWVo4_uI",
  authDomain: "upsell-recommendation.firebaseapp.com",
  projectId: "upsell-recommendation",
  storageBucket: "upsell-recommendation.firebasestorage.app",
  messagingSenderId: "149355857462",
  appId: "1:149355857462:web:de3e4b5c3f66a569c5ba97",
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const googleProvider = new GoogleAuthProvider();
