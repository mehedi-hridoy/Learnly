import 'package:flutter/material.dart';
import 'dart:async';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> with SingleTickerProviderStateMixin {
  bool _isTimerRunning = false;
  bool _isPomodoroActive = true;
  int _secondsRemaining = 25 * 60; // Default Pomodoro duration (25 minutes)
  int _pomodoroDuration = 25 * 60;
  int _shortBreakDuration = 5 * 60; // Default short break duration (5 minutes)
  int _longBreakDuration = 15 * 60; // Default long break duration (15 minutes)
  int _completedPomodoros = 0;
  String _currentTimerType = "Pomodoro";
  Color _backgroundColor = Colors.white;
  late Timer _timer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _pomodoroDuration),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (_isTimerRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      if (_isTimerRunning) {
        _isTimerRunning = false;
        _timer.cancel();
        _animationController.stop();
      } else {
        _isTimerRunning = true;
        _startTimer();
        _animationController.forward(from: 1 - (_secondsRemaining / getCurrentDuration()));
      }
    });
  }

  int getCurrentDuration() {
    if (_currentTimerType == "Pomodoro") {
      return _pomodoroDuration;
    } else if (_currentTimerType == "Short Break") {
      return _shortBreakDuration;
    } else {
      return _longBreakDuration;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          _animationController.value = 1 - (_secondsRemaining / getCurrentDuration());
        });
      } else {
        timer.cancel();
        _isTimerRunning = false;
        
        // Handle timer completion
        if (_currentTimerType == "Pomodoro") {
          _completedPomodoros++;
          
          // After every 4 pomodoros, take a long break
          if (_completedPomodoros % 4 == 0) {
            _switchToLongBreak();
          } else {
            _switchToShortBreak();
          }
        } else {
          _switchToPomodoro();
        }
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _isTimerRunning = false;
      if (_isTimerRunning) {
        _timer.cancel();
      }
      _secondsRemaining = getCurrentDuration();
      _animationController.reset();
    });
  }

  void _switchToPomodoro() {
    setState(() {
      _currentTimerType = "Pomodoro";
      _isPomodoroActive = true;
      _secondsRemaining = _pomodoroDuration;
      _animationController.duration = Duration(seconds: _pomodoroDuration);
      _animationController.reset();
    });
  }

  void _switchToShortBreak() {
    setState(() {
      _currentTimerType = "Short Break";
      _isPomodoroActive = false;
      _secondsRemaining = _shortBreakDuration;
      _animationController.duration = Duration(seconds: _shortBreakDuration);
      _animationController.reset();
    });
  }

  void _switchToLongBreak() {
    setState(() {
      _currentTimerType = "Long Break";
      _isPomodoroActive = false;
      _secondsRemaining = _longBreakDuration;
      _animationController.duration = Duration(seconds: _longBreakDuration);
      _animationController.reset();
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PomodoroSettingsScreen(
          pomodoroDuration: _pomodoroDuration,
          shortBreakDuration: _shortBreakDuration,
          longBreakDuration: _longBreakDuration,
          backgroundColor: _backgroundColor,
          onSettingsChanged: (pomodoro, shortBreak, longBreak, color) {
            setState(() {
              _pomodoroDuration = pomodoro;
              _shortBreakDuration = shortBreak;
              _longBreakDuration = longBreak;
              _backgroundColor = color;
              
              // Update current timer if needed
              if (_currentTimerType == "Pomodoro") {
                _secondsRemaining = _pomodoroDuration;
                _animationController.duration = Duration(seconds: _pomodoroDuration);
              } else if (_currentTimerType == "Short Break") {
                _secondsRemaining = _shortBreakDuration;
                _animationController.duration = Duration(seconds: _shortBreakDuration);
              } else {
                _secondsRemaining = _longBreakDuration;
                _animationController.duration = Duration(seconds: _longBreakDuration);
              }
              
              _resetTimer();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black87),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              
              // Timer Type Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimerTypeButton("Pomodoro", _currentTimerType == "Pomodoro", () => _switchToPomodoro()),
                  SizedBox(width: 10),
                  _buildTimerTypeButton("Short Break", _currentTimerType == "Short Break", () => _switchToShortBreak()),
                  SizedBox(width: 10),
                  _buildTimerTypeButton("Long Break", _currentTimerType == "Long Break", () => _switchToLongBreak()),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Timer Circle Animation
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Circle
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                        
                        // Progress Circle
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: CircleProgressPainter(
                                progress: _animationController.value,
                                color: _isPomodoroActive ? Colors.red.shade400 : Colors.green.shade400,
                                strokeWidth: 12,
                              ),
                              size: Size.infinite,
                            );
                          },
                        ),
                        
                        // Timer Display
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatTime(_secondsRemaining),
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _currentTimerType,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Control Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Reset Button
                    FloatingActionButton(
                      heroTag: "reset",
                      backgroundColor: Colors.grey.shade200,
                      elevation: 2,
                      child: Icon(
                        Icons.refresh,
                        color: Colors.black87,
                      ),
                      onPressed: _resetTimer,
                    ),
                    SizedBox(width: 24),
                    
                    // Play/Pause Button
                    FloatingActionButton(
                      heroTag: "play_pause",
                      backgroundColor: _isPomodoroActive ? Colors.red.shade400 : Colors.green.shade400,
                      elevation: 8,
                      child: Icon(
                        _isTimerRunning ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: _toggleTimer,
                    ),
                    SizedBox(width: 24),
                    
                    // Skip Button
                    FloatingActionButton(
                      heroTag: "skip",
                      backgroundColor: Colors.grey.shade200,
                      elevation: 2,
                      child: Icon(
                        Icons.skip_next,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        if (_currentTimerType == "Pomodoro") {
                          _completedPomodoros++;
                          if (_completedPomodoros % 4 == 0) {
                            _switchToLongBreak();
                          } else {
                            _switchToShortBreak();
                          }
                        } else {
                          _switchToPomodoro();
                        }
                      },
                    ),
                  ],
                ),
              ),
              
              // Pomodoro Counter
              Text(
                "$_completedPomodoros completed",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerTypeButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

// Custom painter for the circle progress
class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;
    
    // Draw the progress arc
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.14159 / 180), // Start from top (negative 90 degrees in radians)
      progress * 2 * 3.14159, // Full circle in radians * progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.color != color ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}

class PomodoroSettingsScreen extends StatefulWidget {
  final int pomodoroDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  final Color backgroundColor;
  final Function(int, int, int, Color) onSettingsChanged;

  const PomodoroSettingsScreen({
    Key? key,
    required this.pomodoroDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.backgroundColor,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  _PomodoroSettingsScreenState createState() => _PomodoroSettingsScreenState();
}

class _PomodoroSettingsScreenState extends State<PomodoroSettingsScreen> {
  late int _pomodoroDuration;
  late int _shortBreakDuration;
  late int _longBreakDuration;
  late Color _selectedColor;

  List<Color> colorOptions = [
    Colors.white,
    Colors.grey.shade100,
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.red.shade50,
    Colors.purple.shade50,
    Colors.yellow.shade50,
  ];

  @override
  void initState() {
    super.initState();
    _pomodoroDuration = widget.pomodoroDuration;
    _shortBreakDuration = widget.shortBreakDuration;
    _longBreakDuration = widget.longBreakDuration;
    _selectedColor = widget.backgroundColor;
  }

  int _minutesToSeconds(double minutes) {
    return (minutes * 60).round();
  }

  double _secondsToMinutes(int seconds) {
    return seconds / 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSettingsChanged(
                _pomodoroDuration,
                _shortBreakDuration,
                _longBreakDuration,
                _selectedColor,
              );
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timer Durations
            _buildSectionTitle("Timer (minutes)"),
            SizedBox(height: 16),
            
            // Pomodoro Duration
            _buildSliderSetting(
              "Pomodoro",
              _secondsToMinutes(_pomodoroDuration),
              5,
              60,
              (value) {
                setState(() {
                  _pomodoroDuration = _minutesToSeconds(value);
                });
              },
            ),
            
            SizedBox(height: 20),
            
            // Short Break Duration
            _buildSliderSetting(
              "Short Break",
              _secondsToMinutes(_shortBreakDuration),
              1,
              15,
              (value) {
                setState(() {
                  _shortBreakDuration = _minutesToSeconds(value);
                });
              },
            ),
            
            SizedBox(height: 20),
            
            // Long Break Duration
            _buildSliderSetting(
              "Long Break",
              _secondsToMinutes(_longBreakDuration),
              5,
              30,
              (value) {
                setState(() {
                  _longBreakDuration = _minutesToSeconds(value);
                });
              },
            ),
            
            SizedBox(height: 40),
            
            // Color Options
            _buildSectionTitle("Theme Colors"),
            SizedBox(height: 16),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colorOptions.map((color) {
                bool isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black87 : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.black87)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSliderSetting(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            Text(
              "${value.round()} min",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          activeColor: Colors.black87,
          inactiveColor: Colors.grey.shade300,
          onChanged: onChanged,
        ),
      ],
    );
  }
}