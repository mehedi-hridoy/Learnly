import 'package:flutter/material.dart';
import 'dart:async';

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      home: const PomodoroScreen(),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  // Timer configuration
  int _defaultTime = 25 * 60; // Default Pomodoro session time (25 minutes)
  int _remainingTime = 25 * 60; // Remaining time for the current session
  bool _isRunning = false; // Is the timer currently running?
  String _sessionLabel = "Pomodoro"; // Label for the current session
  
  // Timer implementation
  Timer? _timer;
  double _progress = 1.0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Starts the timer
  void _startTimer() {
    if (_isRunning) return;
    
    setState(() => _isRunning = true);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _progress = _remainingTime / _defaultTime;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _showCompletionDialog();
        }
      });
    });
  }

  // Pauses the timer
  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  // Resets the timer
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = _defaultTime;
      _isRunning = false;
      _progress = 1.0;
    });
  }

  // Sets the session time and label (Pomodoro, Short Break, Long Break)
  void _setSession(int seconds, String label) {
    _timer?.cancel();
    setState(() {
      _defaultTime = seconds;
      _remainingTime = seconds;
      _isRunning = false;
      _sessionLabel = label;
      _progress = 1.0;
    });
  }

  // Shows a dialog when the session is completed
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.celebration, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              "$_sessionLabel Session Complete!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resetTimer();
              },
              child: const Text("Start New Session"),
            ),
          ],
        ),
      ),
    );
  }

  // Formats the remaining time in MM:SS format
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              _sessionLabel,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _formatTime(_remainingTime),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Text(
              "Stay focused and crush it!",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _setSession(25 * 60, "Pomodoro"),
                  child: const Text("Pomodoro"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _setSession(5 * 60, "Short Break"),
                  child: const Text("Short Break"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _setSession(15 * 60, "Long Break"),
                  child: const Text("Long Break"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  backgroundColor: Colors.black,
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _resetTimer,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}