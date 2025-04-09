import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TimeTrackerPage extends StatefulWidget {
  const TimeTrackerPage({super.key});

  @override
  State<TimeTrackerPage> createState() => _TimeTrackerPageState();
}

class _TimeTrackerPageState extends State<TimeTrackerPage> {
  final List<Map<String, dynamic>> _trackedTasks = [];
  String _currentTask = '';
  DateTime? _startTime;
  bool _isTimerRunning = false;
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  late Timer _timer; // Timer for live clock
  String _currentTime = DateFormat('HH:mm:ss').format(DateTime.now()); // Initial time

  @override
  void initState() {
    super.initState();
    // Start the timer to update the clock every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _taskController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_currentTask.isNotEmpty && !_isTimerRunning) {
      setState(() {
        _startTime = DateTime.now();
        _isTimerRunning = true;
      });
      _showSnackBar('✨ Timer started for "$_currentTask"');
    } else if (_currentTask.isEmpty) {
      _showSnackBar('⚠️ Please enter a task first');
    }
  }

  void _stopTimer() {
    if (_isTimerRunning && _startTime != null) {
      final endTime = DateTime.now();
      final duration = endTime.difference(_startTime!).inSeconds;
      setState(() {
        _trackedTasks.add({
          'task': _currentTask,
          'subject': _subjectController.text.isEmpty ? 'General' : _subjectController.text,
          'startTime': _startTime,
          'duration': duration,
          'date': DateFormat('MMM dd, yyyy').format(_startTime!),
        });
        _currentTask = '';
        _taskController.clear();
        _subjectController.clear();
        _startTime = null;
        _isTimerRunning = false;
      });
      _showSnackBar('🌟 Task completed & saved!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF6B48FF),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Time Tracker', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 193, 194, 137), 
              Color.fromARGB(255, 218, 106, 162), 
              Color.fromARGB(255, 209, 183, 228), 
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.5, 0.9],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTaskInputCard(),
                const SizedBox(height: 30),
                _buildTimerCard(),
                const SizedBox(height: 30),
                _buildTrackedTasksDashboard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskInputCard() {
    return Container(
      decoration: _glassCardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
              const SizedBox(width: 10),
              const Text(
                'New Task',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _taskController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Task Name', Icons.task_rounded),
            onChanged: (value) => _currentTask = value,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _subjectController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Subject (Optional)', Icons.category_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    return Container(
      decoration: _glassCardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.timer_rounded, color: Colors.white, size: 28),
              const SizedBox(width: 10),
              const Text(
                'Timer Control',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Live Clock
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  _currentTime,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _isTimerRunning ? 'Tracking: $_currentTask' : 'Ready to track your next task?',
            style: TextStyle(
              fontSize: 18,
              color: _isTimerRunning ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNeonButton(
                icon: Icons.play_circle_filled_rounded,
                label: 'Start',
                color: const Color.fromARGB(255, 20, 71, 57), 
                onPressed: _isTimerRunning ? null : _startTimer,
              ),
              const SizedBox(width: 20),
              _buildNeonButton(
                icon: Icons.stop_circle_rounded,
                label: 'Stop',
                color: const Color.fromARGB(255, 9, 9, 9), 
                onPressed: _isTimerRunning ? _stopTimer : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackedTasksDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.analytics_rounded, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            const Text(
              'Task History',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _trackedTasks.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'No tasks tracked yet. Let’s get started!',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _trackedTasks.length,
                itemBuilder: (context, index) {
                  final task = _trackedTasks[index];
                  final duration = Duration(seconds: task['duration']);
                  final formattedDuration =
                      '${duration.inHours}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s';
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: _glassCardDecoration(),
                    child: ListTile(
                      leading: const Icon(Icons.history_rounded, color: Colors.white, size: 26),
                      title: Text(
                        task['task'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      subtitle: Text(
                        '${task['subject']} • ${task['date']} • $formattedDuration',
                        style: const TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      trailing: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF34D399)),
                    ),
                  );
                },
              ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }

  BoxDecoration _glassCardDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 30,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  Widget _buildNeonButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 248, 247, 247), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}