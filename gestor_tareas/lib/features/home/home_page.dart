import 'package:flutter/material.dart';
import 'package:gestor_tareas/data/services/task_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskService taskService = TaskService();
  List<dynamic> tareas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    try {
      final data = await taskService.getTasks();
      setState(() {
        tareas = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al cargar tareas")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas del equipo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tareas.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final tarea = tareas[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(tarea['title']),
                    subtitle: Text("Asignado a: ${tarea['assigned_name'] ?? 'Sin asignar'}\nFecha: ${tarea['deadline']}"),
                    trailing: tarea['completed'] == 1
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.radio_button_unchecked),
                    onTap: () async {
                    final result = await Navigator.pushNamed(context, '/task_detail', arguments: tarea);
                    if (result == true) loadTasks();
                  },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.pushNamed(context, '/create_task');
        if (result == true) {
          loadTasks(); 
        }
      },
      child: const Icon(Icons.add),
    ),
    );
  }
}
