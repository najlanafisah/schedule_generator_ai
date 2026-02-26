import 'package:flutter/material.dart';
import 'package:schedule_gemerator_ai/models/task.dart';

class AddTaskCard extends StatefulWidget {
  final Function(Task) onAddTask;

  const AddTaskCard({super.key, required this.onAddTask});

  @override
  State<AddTaskCard> createState() => _AddTaskCardState();
}

class _AddTaskCardState extends State<AddTaskCard> {
  final taskController = TextEditingController();
  final durationController = TextEditingController();
  final deadlineController = TextEditingController();
  String? priority;

  @override
  // untuk membersihkan cache (di reset)
  void dispose() {
    taskController.dispose();
    durationController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  void _submit() {
    if (taskController.text.isNotEmpty && durationController.text.isNotEmpty && deadlineController.text.isNotEmpty && priority != null ) {
      widget.onAddTask(Task(
        name: taskController.text,
        priority: priority!,
        duration: int.tryParse(durationController.text) ?? 5,
        deadline: deadlineController.text
      ));

      // pastiin cachenya clear
      taskController.clear();
      durationController.clear();
      deadlineController.clear();
      setState(() => priority = null);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.playlist_add_check_circle_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  'Add Task',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            SizedBox(height: 12),

            // ini bagus kalo pake widget extraction

            // TASK NAME //
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Task name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.task_alt_rounded)
              ),
              textInputAction: TextInputAction.next, // ini kyk kalo misal udhh selesai ngisi nih di tefi 1, nanti kalo enter pindah ke tefi 2 kyk next gitu
            ),
            SizedBox(height: 12),
            
            // DURATION //
            TextField(
              controller: durationController,
              decoration: InputDecoration(
                labelText: 'Duration (min)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer_outlined)
              ),
              keyboardType: TextInputType.number, // ini biar keyboardnya berubah jadi angka
              textInputAction: TextInputAction.next, // ini kyk kalo misal udhh selesai ngisi nih di tefi 1, nanti kalo enter pindah ke tefi 2 kyk next gitu
            ),
            SizedBox(height: 12),

            // DEADLINE //
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: 'Deadline',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event_outlined)
              ),
              textInputAction: TextInputAction.done, // ini kyk kalo misal udhh selesai ngisi nih di tefi 1, nanti kalo enter dia langsung selesai, ga muncul lagi keyboardnya (dan di keyboardnya bagian enter bakal berubah jadi kyk checklist)
            ),
            SizedBox(height: 12),

            // DROPDOWN PRIORITY //
            DropdownButtonFormField<String>(
              initialValue: priority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                prefix: Icon(Icons.flag_outlined)
              ),
              items: ['High', 'Medium', 'Low']
                  .map((values) => DropdownMenuItem(value: values, child: Text(values)))
                  .toList(),
              onChanged: (value) => setState(() => priority = value),
            ),
            SizedBox(height: 16),
            
             // BUTTON //
             FilledButton.icon(
              onPressed: _submit,
              icon: Icon(Icons.add_rounded),
              label: Text('Add Task'),
             )
          ],
        ),
      ),
    );
  }
}