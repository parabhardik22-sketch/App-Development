import React, { useState, useEffect } from "react";
import { View, Text, TextInput, Button, FlatList } from "react-native";
import { db } from "./firebaseConfig";

export default function App() {
  const [task, setTask] = useState("");
  const [tasks, setTasks] = useState([]);

  // Real-time listener
  useEffect(() => {
    const unsubscribe = db.collection("tasks").onSnapshot((snapshot) => {
      const tasksArray = snapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      setTasks(tasksArray);
    });

    return () => unsubscribe();
  }, []);

  // Add task
  const addTask = async () => {
    if (task.trim() === "") return;
    await db.collection("tasks").add({ name: task });
    setTask("");
  };

  // Delete task
  const deleteTask = async (id) => {
    await db.collection("tasks").doc(id).delete();
  };

  return (
    <View style={{ padding: 20, marginTop: 50 }}>
      <Text style={{ fontSize: 24, fontWeight: "bold" }}>To-Do List</Text>

      <TextInput
        value={task}
        onChangeText={setTask}
        placeholder="Enter a task"
        style={{
          borderWidth: 1,
          borderColor: "#ccc",
          padding: 10,
          marginVertical: 10,
          borderRadius: 5,
        }}
      />

      <Button title="Add Task" onPress={addTask} />

      <FlatList
        style={{ marginTop: 20 }}
        data={tasks}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View
            style={{
              flexDirection: "row",
              justifyContent: "space-between",
              padding: 10,
              borderBottomWidth: 1,
              borderColor: "#eee",
              alignItems: "center",
            }}
          >
            <Text>{item.name}</Text>
            <Button
              title="Delete"
              color="red"
              onPress={() => deleteTask(item.id)}
            />
          </View>
        )}
      />
    </View>
  );
}
