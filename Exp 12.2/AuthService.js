import app from "./firebaseConfig";
import {
  getAuth,
  onAuthStateChanged,
  signInWithCredential,
  GoogleAuthProvider,
} from "firebase/auth";
import { useState, useEffect } from "react";
import { useAuthRequest } from "expo-auth-session/providers/google";
import * as WebBrowser from "expo-web-browser";

WebBrowser.maybeCompleteAuthSession();

const auth = getAuth(app);

export function useAuth() {
  const [user, setUser] = useState(null);

  const [request, response, promptAsync] = useAuthRequest({
    expoClientId: "772024985095-88bnr6te23b0ctff9e2o9l9frnehpqii.apps.googleusercontent.com",
    androidClientId: "772024985095-ko598atogo9j2a9anp64gq3svaiseii3.apps.googleusercontent.com",
    scopes: ["profile", "email"],
  });

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, setUser);
    return unsub;
  }, []);

  useEffect(() => {
    if (response?.type === "success") {
      const { id_token } = response.params;
      const credential = GoogleAuthProvider.credential(id_token);
      signInWithCredential(auth, credential);
    }
  }, [response]);

  return { user, auth, promptAsync, request };
}
