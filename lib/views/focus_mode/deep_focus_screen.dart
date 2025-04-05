import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../focus_mode/pomodoro_timer.dart';
import '../focus_mode/distraction_blocker.dart';
import '../focus_mode/task_manager.dart';
import '../focus_mode/progress_tracking.dart';


class DeepFocusScreen extends StatefulWidget {
  const DeepFocusScreen({Key? key}) : super(key: key);

  @override
  _DeepFocusScreenState createState() => _DeepFocusScreenState();
}

class _DeepFocusScreenState extends State<DeepFocusScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deep Focus"),
        backgroundColor: AppColors.primary, 
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pomodoro"),
            Tab(text: "Blocker"),
            Tab(text: "Tasks"),
            Tab(text: "Progress"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PomodoroApp(),
          // DistractionBlocker(),
          // TaskManager(),
          // ProgressTracking(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
