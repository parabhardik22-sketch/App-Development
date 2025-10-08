import React, { useState } from 'react';
import { StyleSheet, Text, View, TextInput, Button, FlatList } from 'react-native';

export default function App() {
  const [task, setTask] = useState('');
  const [tasks, setTasks] = useState([]);

  // Add new task
  const addTask = () => {
    if (task.trim() === '') return;
    setTasks([...tasks, task]); // add task to list
    setTask(''); // clear input
  };

  return (
    <View style={styles.container}>
      <Text style={styles.heading}>To-Do List</Text>

      <TextInput
        style={styles.input}
        placeholder="Enter your task"
        value={task}
        onChangeText={(text) => setTask(text)}
      />

      <Button title="Add more" onPress={addTask} />

      {/* Show tasks */}
      <FlatList
        data={tasks}
        keyExtractor={(item, index) => index.toString()}
        renderItem={({ item }) => <Text style={styles.task}>{item}</Text>}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 60,
    paddingHorizontal: 20,
    backgroundColor: '#f3ffaeff',
  },
  heading: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20,
    textAlign: 'center',
  },
  input: {
    borderWidth: 1,
    borderColor: '#aaa',
    borderRadius: 6,
    padding: 10,
    marginBottom: 10,
  },
  task: {
    fontSize: 18,
    padding: 8,
    marginVertical: 4,
    backgroundColor: '#f2f2f2',
    borderRadius: 6,
  },
});
