import 'package:flutter/material.dart';
import 'package:gestor_tareas/data/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final authService = AuthService();
  bool isLoading = false;
  String? errorMessage;

  void _register() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final result = await authService.register(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (result['success']) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => errorMessage = result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              const Text("Crear cuenta", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Regístrate para comenzar a colaborar", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nombre completo"),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Correo electrónico"),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
              ),

              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _register,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Registrarse"),
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("¿Ya tienes cuenta? Inicia sesión"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
