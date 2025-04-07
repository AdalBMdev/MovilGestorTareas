
# 🧠 Gestor de Tareas Colaborativo

**Gestor de Tareas Colaborativo** es una aplicación móvil desarrollada con **Flutter** que permite a múltiples usuarios gestionar tareas de manera eficiente dentro de un equipo de trabajo. La app está respaldada por un backend en **Node.js + SQLite**, ofreciendo autenticación, persistencia de datos y comunicación con API RESTful.

---

## 📱 Características principales

- ✅ Registro e inicio de sesión con autenticación JWT
- ✅ Crear, editar, eliminar y completar tareas
- ✅ Asignar tareas a miembros del equipo
- ✅ Notificaciones visuales de estado
- ✅ Persistencia de sesión (`SharedPreferences`)
- ✅ Diseño moderno y responsivo
- ✅ Perfil de usuario y cierre de sesión
- ✅ Arquitectura modular y escalable

---

## ⚙️ Tecnologías utilizadas

### 🔸 Frontend (Flutter)
- `flutter_riverpod`
- `http`
- `intl`
- `shared_preferences`
- `jwt_decode`

### 🔹 Backend (Node.js + SQLite)
- `express`
- `sqlite3`
- `bcrypt`
- `jsonwebtoken`
- `cors`
- `body-parser`

---

## 📦 Instalación y configuración

### 🔧 Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Node.js](https://nodejs.org)
- Git
- Android Studio o VSCode (con soporte Flutter)

---

### 📁 1. Clona el repositorio

```bash
git clone https://github.com/tu_usuario/gestor_tareas.git
cd gestor_tareas
```

---

### 🛠️ 2. Backend (Node.js + SQLite)

```bash
cd backend_tareas
npm install
node server.js
```

> El servidor quedará activo en `http://localhost:3000`  
> Se crearán automáticamente las tablas `users` y `tasks` en `database.db`.

---

### 📲 3. App Flutter

```bash
flutter pub get
flutter run -d chrome  # o usa android, windows, etc.
```

> 💡 Si usas emulador Android, reemplaza `localhost` por `10.0.2.2` en `auth_service.dart` y `task_service.dart`.

---

## 🧪 Endpoints disponibles

| Método | Endpoint           | Descripción                         |
|--------|--------------------|-------------------------------------|
| POST   | `/auth/register`   | Registrar nuevo usuario             |
| POST   | `/auth/login`      | Autenticar usuario                  |
| GET    | `/auth/users`      | Listar todos los usuarios           |
| GET    | `/tasks`           | Obtener todas las tareas            |
| POST   | `/tasks`           | Crear una nueva tarea               |
| PUT    | `/tasks/:id`       | Marcar tarea como completada        |
| DELETE | `/tasks/:id`       | Eliminar una tarea                  |

---

## 🧪 Ejemplo de uso

### 1. Registro de usuario

```json
POST /auth/register
{
  "name": "Juan Pérez",
  "email": "juan@example.com",
  "password": "123456"
}
```

### 2. Crear tarea

```json
POST /tasks
{
  "title": "Revisar diseño",
  "description": "Asegurarse que el diseño UI esté aprobado",
  "deadline": "2025-04-20",
  "assigned_to": 1
}
```

### 3. Respuesta de éxito

```json
{
  "id": 7,
  "title": "Revisar diseño",
  "description": "Asegurarse que el diseño UI esté aprobado",
  "deadline": "2025-04-20",
  "assigned_to": 1
}
```

---

## 👤 Perfil del usuario

Desde la vista de perfil puedes:

- Ver nombre y correo extraídos del token JWT
- Cerrar sesión (remueve el token de `SharedPreferences`)
- Acceder desde el botón en la esquina superior derecha de Home

---

