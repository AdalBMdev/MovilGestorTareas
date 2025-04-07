const jwt = require('jsonwebtoken');
const secret = 'clave_secreta';

module.exports = function (req, res, next) {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Token requerido' });

  try {
    const user = jwt.verify(token, secret);
    req.user = user;
    next();
  } catch {
    return res.status(403).json({ error: 'Token inválido' });
  }
};
