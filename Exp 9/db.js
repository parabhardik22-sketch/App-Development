// db.js
import SQLite from 'react-native-sqlite-2';

// Open or create the database
const db = SQLite.openDatabase('todo.db', '1.0', 'Todo Database', 200000);

// Initialize the table
db.transaction(tx => {
  tx.executeSql(
    'CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, status TEXT);'
  );
});

export default db;
