import 'package:flutter/material.dart';
import 'package:schedule_gemerator_ai/models/task.dart';
import 'package:schedule_gemerator_ai/services/gemini_service.dart';
import 'package:schedule_gemerator_ai/ui/home/components/add_task_card.dart';
import 'package:schedule_gemerator_ai/ui/home/components/schedule_result_card.dart';
import 'package:schedule_gemerator_ai/ui/home/components/task_list_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // variable yang dibutuhkan
  bool isLoading = false;
  final List<Task> tasks = [];
  String scheduleResult = ''; // ini wadah untuk menmpung hasil generate schedule dari gemini
  final GeminiService geminiService = GeminiService();

  // function utama
  Future<void> _generateSchedule() async{
    setState(() => isLoading = true);
    try {
      String schedule = await geminiService.generateSchedule(tasks);
      setState(() => scheduleResult = schedule);
    } catch (e) {
      setState(() => scheduleResult = e.toString());
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Generator'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildHeader(),
          SizedBox(height: 16),
          AddTaskCard(onAddTask: (task) => setState(() => tasks.add(task))),
          SizedBox(height: 16),
          TaskListSection(
            tasks: tasks,
            // ignore: collection_methods_unrelated_type
            onDelete: (index) => setState(() => tasks.removeAt(index)) 
          ),
          SizedBox(height: 16),
          _buildGenerateButton(),
          SizedBox(height: 16),
          ScheduleResultCard(schedule: scheduleResult)
        ],
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer, // tema yang dimiliki oleh flutter / default
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline)
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Plan your day faster",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700
                  ),
                ),
                Text(
                  "Add task and generate",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              ],
            )
          ),
          Chip(label: Text('${tasks.length} task')) // ini untuk chip di sebelah kanan
        ],
      ),
    );
  }

  // Generate button
  Widget _buildGenerateButton() {
    return FilledButton.icon(
      onPressed: (isLoading || tasks.isEmpty) ? null : _generateSchedule, 
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(Icons.auto_awesome_rounded),
      label: Text(isLoading ? 'Generating...' : 'Generate Schedule'),
    );
  }

}


