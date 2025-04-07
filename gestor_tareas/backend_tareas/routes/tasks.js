const express = require('express');
const router = express.Router();
const db = require('../db');
const auth = require('../middleware/auth');

router.get('/', auth, (req, res) => {
  const query = `
    SELECT 
      tasks.id, 
      tasks.title, 
      tasks.description, 
      tasks.deadline, 
      tasks.completed,
      users.name AS assigned_name
    FROM tasks
    LEFT JOIN users ON users.id = tasks.assigned_to
  `;

  db.all(query, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});


router.post('/', auth, (req, res) => {
  const { title, description, deadline, assigned_to } = req.body;

  db.run(
    `INSERT INTO tasks (title, description, deadline, assigned_to) VALUES (?, ?, ?, ?)`,
    [title, description, deadline, assigned_to],
    function (err) {
      if (err) return res.status(400).json({ error: err.message });
      res.json({ id: this.lastID, ...req.body });
    }
  );
});

router.put('/:id', auth, (req, res) => {
  const { completed } = req.body;
  db.run(
    `UPDATE tasks SET completed = ? WHERE id = ?`,
    [completed ? 1 : 0, req.params.id],
    function (err) {
      if (err) return res.status(400).json({ error: err.message });
      res.json({ success: true });
    }
  );
});

router.delete('/:id', auth, (req, res) => {
  const taskId = req.params.id;

  db.run(`DELETE FROM tasks WHERE id = ?`, [taskId], function (err) {
    if (err) return res.status(500).json({ error: err.message });

    if (this.changes === 0) {
      return res.status(404).json({ error: 'Tarea no encontrada' });
    }

    res.json({ success: true });
  });
});

module.exports = router;
