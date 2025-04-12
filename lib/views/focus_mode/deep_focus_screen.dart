import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'pomodoro_timer.dart'; // Assuming PomodoroScreen is in pomodoro_timer.dart
import 'distraction_blocker.dart'; // Add your DistractionBlocker widget
import '../focus_mode/progress_tracking.dart';
import '../focus_mode/deadLine_buddy.dart';
// Add your TaskManager widget
// Add your ProgressTracking widget

class DeepFocusScreen extends StatefulWidget {
  const DeepFocusScreen({Key? key}) : super(key: key);

  @override
  _DeepFocusScreenState createState() => _DeepFocusScreenState();
}

class _DeepFocusScreenState extends State<DeepFocusScreen> {
  final List<Map<String, dynamic>> _focusModules = [
    {
      'title': 'Pomodoro',
      'icon': Icons.timer,
      'color': Colors.blueAccent,
      'description': 'A timer to manage your focus sessions with short breaks.',
      'widget': const PomodoroScreen(),
    },
    {
      'title': 'Blocker',
      'icon': Icons.block,
      'color': Colors.redAccent,
      'description': 'Block distractions while you focus on your tasks.',
      'widget': const DistractionBlocker(),
    },
    
    // {
    //   'title': 'Tasks',
    //   'icon': Icons.check_circle_outline,
    //   'color': Colors.greenAccent,
    //   'description': 'Manage and organize your daily tasks effectively.',
    //   'widget': const TaskManager(),
    // },
    {
      'title': 'Progress',
      'icon': Icons.show_chart,
      'color': Colors.purpleAccent,
      'description': 'Track your progress and review completed tasks.',
      'widget': const ProgressTrackerPage(),
    },
     {
  'title': 'Deadline Buddy',
  'icon': Icons.alarm_on, // You can change this to any icon you like!
  'color': Colors.deepOrangeAccent, 
  'description': 'Never miss a due date with smart reminders and alerts.',
  'widget': const DeadLineBuddy(),
},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Focus'),
        backgroundColor: AppColors.primary, // Assuming AppColors is defined
      ),
      body: ListView.builder(
        itemCount: _focusModules.length,
        itemBuilder: (context, index) {
          final module = _focusModules[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the corresponding widget on tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => module['widget']),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: module['color'],
                      radius: 30,
                      child: Icon(module['icon'], color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            module['title'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            module['description'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
