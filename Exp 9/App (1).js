import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  TextInput,
  Button,
  FlatList,
  TouchableOpacity,
  StyleSheet,
  Alert,
} from 'react-native';
import db from './db';

export default function App() {
  const [task, setTask] = useState('');
  const [tasks, setTasks] = useState([]);

  // Load tasks from SQLite
  useEffect(() => {
    fetchTasks();
  }, []);

  const fetchTasks = () => {
    db.transaction(tx => {
      tx.executeSql(
        'SELECT * FROM tasks;',
        [],
        (_, { rows }) => {
          setTasks(rows._array);
        },
        (t, error) => {
          console.log('Error fetching tasks:', error);
        }
      );
    });
  };

  const addTask = () => {
    if (!task.trim()) return;

    db.transaction(tx => {
      tx.executeSql(
        'INSERT INTO tasks (task, status) VALUES (?, ?);',
        [task, 'pending'],
        () => {
          fetchTasks();
          setTask('');
        },
        (t, error) => {
          console.log('Error inserting task:', error);
        }
      );
    });
  };

  const toggleStatus = id => {
    db.transaction(tx => {
      tx.executeSql(
        'UPDATE tasks SET status = CASE WHEN status="pending" THEN "completed" ELSE "pending" END WHERE id=?;',
        [id],
        () => fetchTasks()
      );
    });
  };

  const deleteTask = id => {
    Alert.alert('Delete Task', 'Are you sure?', [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Delete',
        style: 'destructive',
        onPress: () => {
          db.transaction(tx => {
            tx.executeSql('DELETE FROM tasks WHERE id=?;', [id], () => fetchTasks());
          });
        },
      },
    ]);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.heading}>SQLite To-Do List</Text>

      <View style={styles.inputContainer}>
        <TextInput
          style={styles.input}
          placeholder="Enter a task"
          value={task}
          onChangeText={setTask}
        />
        <Button title="Add" onPress={addTask} />
      </View>

      <FlatList
        data={tasks}
        keyExtractor={item => item.id.toString()}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={styles.taskContainer}
            onPress={() => toggleStatus(item.id)}
            onLongPress={() => deleteTask(item.id)}
          >
            <Text style={[styles.taskText, item.status === 'completed' && styles.completed]}>
              {item.task} ({item.status})
            </Text>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 20, paddingTop: 50, backgroundColor: '#f2f2f2' },
  heading: { fontSize: 26, fontWeight: 'bold', marginBottom: 20, textAlign: 'center' },
  inputContainer: { flexDirection: 'row', marginBottom: 20 },
  input: {
    flex: 1,
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 5,
    padding: 10,
    marginRight: 10,
    backgroundColor: '#fff',
  },
  taskContainer: { backgroundColor: '#fff', padding: 10, borderRadius: 5, marginBottom: 10 },
  taskText: { fontSize: 18 },
  completed: { textDecorationLine: 'line-through', color: 'gray' },
});
