import React, { useState } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  ActivityIndicator,
  Alert,
} from "react-native";
import { LinearGradient } from "expo-linear-gradient";
import { useAuth } from "./AuthService";
import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
} from "firebase/auth";

export default function App() {
  const { user, auth, promptAsync } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSignIn = async () => {
    try {
      setLoading(true);
      await signInWithEmailAndPassword(auth, email, password);
    } catch (error) {
      Alert.alert("Login Error", error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleSignUp = async () => {
    try {
      setLoading(true);
      await createUserWithEmailAndPassword(auth, email, password);
    } catch (error) {
      Alert.alert("Signup Error", error.message);
    } finally {
      setLoading(false);
    }
  };

  if (user) {
    return (
      <LinearGradient colors={["#667eea", "#764ba2"]} style={styles.container}>
        <Text style={styles.welcome}>Welcome, {user.email}</Text>
        <TouchableOpacity
          style={styles.button}
          onPress={() => signOut(auth)}
        >
          <Text style={styles.buttonText}>Sign Out</Text>
        </TouchableOpacity>
      </LinearGradient>
    );
  }

  return (
    <LinearGradient colors={["#667eea", "#764ba2"]} style={styles.container}>
      <Text style={styles.title}>SIMPLE AUTHENTICATION APP</Text>

      <View style={styles.inputContainer}>
        <TextInput
          placeholder="Email"
          placeholderTextColor="#ccc"
          style={styles.input}
          value={email}
          onChangeText={setEmail}
        />
        <TextInput
          placeholder="Password"
          placeholderTextColor="#ccc"
          style={styles.input}
          secureTextEntry
          value={password}
          onChangeText={setPassword}
        />
      </View>

      {loading ? (
        <ActivityIndicator color="#fff" size="large" style={{ margin: 10 }} />
      ) : (
        <>
          <TouchableOpacity style={styles.button} onPress={handleSignIn}>
            <Text style={styles.buttonText}>LogIn</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={[styles.button, { backgroundColor: "#4CAF50" }]}
            onPress={handleSignUp}
          >
            <Text style={styles.buttonText}>Sign Up</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={[styles.button, { backgroundColor: "#DB4437" }]}
            onPress={() => promptAsync()}
          >
            <Text style={styles.buttonText}>Sign in with Google</Text>
          </TouchableOpacity>
        </>
      )}
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    paddingHorizontal: 25,
  },
  title: {
    fontSize: 28,
    color: "#fff",
    fontWeight: "bold",
    marginBottom: 30,
  },
  inputContainer: {
    width: "100%",
  },
  input: {
    backgroundColor: "rgba(255,255,255,0.2)",
    color: "#fff",
    padding: 12,
    borderRadius: 10,
    marginVertical: 8,
    fontSize: 16,
  },
  button: {
    width: "100%",
    backgroundColor: "#5a67d8",
    padding: 14,
    borderRadius: 12,
    marginTop: 15,
    alignItems: "center",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 4,
    elevation: 4,
  },
  buttonText: {
    color: "#fff",
    fontSize: 17,
    fontWeight: "bold",
  },
  welcome: {
    fontSize: 22,
    color: "#fff",
    fontWeight: "bold",
    marginBottom: 15,
  },
});
