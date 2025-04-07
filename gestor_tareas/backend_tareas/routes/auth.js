const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../db');
const router = express.Router();
const secret = 'clave_secreta';
const authMiddleware = require('../middleware/auth');

router.post('/register', async (req, res) => {
  const { name, email, password } = req.body;
  const hashed = await bcrypt.hash(password, 10);

  db.run(
    `INSERT INTO users (name, email, password) VALUES (?, ?, ?)`,
    [name, email, hashed],
    function (err) {
      if (err) return res.status(400).json({ error: 'Email ya existe' });

      const token = jwt.sign({ id: this.lastID, name }, secret);
      res.json({ token, user: { id: this.lastID, name, email } });
    }
  );
});

router.post('/login', (req, res) => {
  const { email, password } = req.body;

  db.get(`SELECT * FROM users WHERE email = ?`, [email], async (err, user) => {
    if (err || !user) return res.status(400).json({ error: 'Usuario no encontrado' });

    const valid = await bcrypt.compare(password, user.password);
    if (!valid) return res.status(401).json({ error: 'Contraseña incorrecta' });

    const token = jwt.sign({ id: user.id, name: user.name }, secret);
    res.json({ token, user: { id: user.id, name: user.name, email: user.email } });
  });
});

router.get('/users', authMiddleware, (req, res) => {
  db.all(`SELECT id, name, email FROM users`, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});


module.exports = router;
