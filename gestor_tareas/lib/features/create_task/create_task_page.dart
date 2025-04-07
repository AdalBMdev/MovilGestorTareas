import 'package:flutter/material.dart';
import 'package:gestor_tareas/data/services/auth_service.dart';
import 'package:gestor_tareas/data/services/task_service.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final taskService = TaskService();
  final authService = AuthService();

  DateTime? selectedDate;
  List<dynamic> users = [];
  int? selectedUserId;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    try {
      final data = await authService.getAllUsers();
      setState(() {
        users = data;
        selectedUserId = data.isNotEmpty ? data.first['id'] : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al cargar usuarios")),
      );
    }
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitTask() async {
    if (!_formKey.currentState!.validate() || selectedDate == null || selectedUserId == null) return;

    setState(() => isLoading = true);

    final taskData = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'deadline': DateFormat('yyyy-MM-dd').format(selectedDate!),
      'assigned_to': selectedUserId,
    };

    final success = await taskService.createTask(taskData);

    setState(() => isLoading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al crear la tarea")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : 'Selecciona una fecha';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Tarea"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Nueva tarea",
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: "Título",
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) => value!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Descripción",
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                        validator: (value) => value!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: selectedUserId,
                        decoration: const InputDecoration(
                          labelText: "Asignar a",
                          prefixIcon: Icon(Icons.person),
                        ),
                        items: users.map<DropdownMenuItem<int>>((user) {
                          return DropdownMenuItem<int>(
                            value: user['id'],
                            child: Text(user['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedUserId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today),
                        title: Text("Fecha límite: $formattedDate"),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit_calendar),
                          onPressed: _selectDate,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _submitTask,
                  icon: const Icon(Icons.save),
                  label: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Guardar Tarea"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
