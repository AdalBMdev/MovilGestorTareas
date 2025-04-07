const sqlite3 = require('sqlite3').verbose();

const db = new sqlite3.Database('./database.db', (err) => {
  if (err) return console.error(err.message);
  console.log('🟢 Conectado a SQLite');
});

// Crear tablas
db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT UNIQUE,
      password TEXT
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      deadline TEXT,
      assigned_to INTEGER,
      completed INTEGER DEFAULT 0,
      FOREIGN KEY(assigned_to) REFERENCES users(id)
    )
  `);
});

module.exports = db;
