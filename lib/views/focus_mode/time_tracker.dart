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
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isTimerRunning && _startTime != null) {
        setState(() {
          _elapsed = DateTime.now().difference(_startTime!);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _taskController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_currentTask.isNotEmpty && !_isTimerRunning) {
      setState(() {
        _startTime = DateTime.now();
        _elapsed = Duration.zero;
        _isTimerRunning = true;
      });
      _showSnackBar('Timer started: "$_currentTask"');
    } else if (_currentTask.isEmpty) {
      _showSnackBar('Please enter a task first');
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
        _elapsed = Duration.zero;
      });
      _showSnackBar('Task saved successfully');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF4A90E2), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Time Tracker',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTimerCard(),
              const SizedBox(height: 20),
              _buildTaskInputCard(),
              const SizedBox(height: 28),
              _buildTrackedTasksSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerCard() {
    String formattedElapsed =
        '${_elapsed.inHours.toString().padLeft(2, '0')}:${(_elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(_elapsed.inSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECEF), width: 1),
      ),
      child: Column(
        children: [
          Text(
            formattedElapsed,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w300,
              color: Color(0xFF2D3748),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isTimerRunning ? _currentTask : 'Start a new task',
            style: TextStyle(
              fontSize: 16,
              color: _isTimerRunning ? const Color.fromARGB(255, 133, 172, 218) : const Color(0xFFA0AEC0),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          _buildTimerButton(
            icon: _isTimerRunning ? Icons.stop_rounded : Icons.play_arrow_rounded,
            color: _isTimerRunning ? const Color(0xFFE53E3E) : const Color(0xFF4A90E2),
            onPressed: _isTimerRunning ? _stopTimer : _startTimer,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECEF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Task Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _taskController,
            style: const TextStyle(color: Color(0xFF2D3748), fontSize: 15),
            decoration: _inputDecoration('Task Name'),
            onChanged: (value) => _currentTask = value,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _subjectController,
            style: const TextStyle(color: Color(0xFF2D3748), fontSize: 15),
            decoration: _inputDecoration('Category (optional)'),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackedTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'History',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        _trackedTasks.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _trackedTasks.length,
                itemBuilder: (context, index) {
                  final task = _trackedTasks[index];
                  final duration = Duration(seconds: task['duration']);
                  final hours = duration.inHours;
                  final minutes = duration.inMinutes % 60;
                  final seconds = duration.inSeconds % 60;

                  String formattedDuration = '';
                  if (hours > 0) formattedDuration += '$hours h ';
                  if (minutes > 0) formattedDuration += '$minutes m ';
                  if (seconds > 0 || formattedDuration.isEmpty) formattedDuration += '$seconds s';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE8ECEF), width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['task'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${task['subject']} · ${task['date']}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFA0AEC0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F9FC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            formattedDuration,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.history_outlined,
            size: 40,
            color: Color(0xFFA0AEC0),
          ),
          const SizedBox(height: 12),
          Text(
            'No tasks tracked',
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF2D3748).withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your tasks will appear here',
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFFA0AEC0),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFFA0AEC0),
        fontSize: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE8ECEF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE8ECEF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 1.5),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  Widget _buildTimerButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}