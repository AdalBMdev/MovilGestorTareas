import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/home/home_page.dart';
import 'features/create_task/create_task_page.dart';
import 'features/task_detail/task_detail_page.dart';
import 'features/profile/profile_page.dart'; // Asegúrate de importar esta

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const HomePage(),
        '/create_task': (_) => const CreateTaskPage(),
        '/task_detail': (_) => const TaskDetailPage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
