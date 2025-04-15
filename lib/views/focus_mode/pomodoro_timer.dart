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
  int _secondsRemaining = 25 * 60;
  int _pomodoroDuration = 25 * 60;
  int _shortBreakDuration = 5 * 60; 
  int _longBreakDuration = 15 * 60; 
  int _completedPomodoros = 0;
  String _currentTimerType = "Pomodoro";
  Color _backgroundColor = const Color(0xFFF9F9FB);
  late Timer _timer;
  late AnimationController _animationController;


  
  final Color _primaryColor = const Color(0xFF5E60CE);
  final Color _secondaryColor = const Color(0xFF64DFDF);
  final Color _pomodoroColor = const Color(0xFFFF5A5F);
  final Color _breakColor = const Color(0xFF56CFE1);
  final Color _neutralColor = const Color(0xFF6C757D);
  final Color _textColor = const Color(0xFF2B2D42);


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
    final Color activeColor = _isPomodoroActive ? _pomodoroColor : _breakColor;
   
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Focus Timer",
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: _textColor.withOpacity(0.7)),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
           
           
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    _buildTimerTypeButton("Pomodoro", _currentTimerType == "Pomodoro", () => _switchToPomodoro(), activeColor),
                    _buildTimerTypeButton("Short Break", _currentTimerType == "Short Break", () => _switchToShortBreak(), activeColor),
                    _buildTimerTypeButton("Long Break", _currentTimerType == "Long Break", () => _switchToLongBreak(), activeColor),
                  ],
                ),
              ),
            ),
           
            SizedBox(height: 40),
           
            
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: EdgeInsets.all(24),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                       
                        
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: CircleProgressPainter(
                                progress: _animationController.value,
                                color: activeColor,
                                strokeWidth: 12,
                              ),
                              size: Size.infinite,
                            );
                          },
                        ),
                       
                       
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatTime(_secondsRemaining),
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w300,
                                color: _textColor,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: activeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _currentTimerType,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: activeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
           
           
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  _buildControlButton(
                    Icons.refresh_rounded,
                    Colors.white,
                    _neutralColor.withOpacity(0.8),
                    _resetTimer,
                    size: 46,
                  ),
                  SizedBox(width: 24),
                 
                  
                  _buildControlButton(
                    _isTimerRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    Colors.white,
                    activeColor,
                    _toggleTimer,
                    size: 72,
                    iconSize: 36,
                  ),
                  SizedBox(width: 24),
                 
                 
                  _buildControlButton(
                    Icons.skip_next_rounded,
                    Colors.white,
                    _neutralColor.withOpacity(0.8),
                    () {
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
                    size: 46,
                  ),
                ],
              ),
            ),
           
           
            Container(
              margin: EdgeInsets.only(bottom: 32, left: 24, right: 24),
              child: Column(
                children: [
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final isCompleted = index < (_completedPomodoros % 4);
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted ? _pomodoroColor : Colors.grey.withOpacity(0.2),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "$_completedPomodoros sessions completed",
                    style: TextStyle(
                      fontSize: 14,
                      color: _textColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTimerTypeButton(String label, bool isActive, VoidCallback onTap, Color activeColor) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : _textColor.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildControlButton(
    IconData icon,
    Color iconColor,
    Color bgColor,
    VoidCallback onTap,
    {double size = 56, double iconSize = 24}
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: iconSize),
        onPressed: onTap,
        padding: EdgeInsets.zero,
      ),
    );
  }
}



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
   
    final trackPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
   
    canvas.drawCircle(center, radius, trackPaint);
   
   
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
   
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.14159 / 180),
      progress * 2 * 3.14159, 
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
    const Color(0xFFF9F9FB), 
    const Color(0xFFF0F4F8), 
    const Color(0xFFFFF8E8), 
    const Color(0xFFF8F9FF), 
    const Color(0xFFFFF0F3), 
    const Color(0xFFF0FFF4), 
    const Color(0xFFFFF9DB), 
  ];


  final Color _textColor = const Color(0xFF2B2D42);
  final Color _accentColor = const Color(0xFF5E60CE);


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
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _textColor),
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
              style: TextStyle(
                color: _accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              _buildSectionTitle("Timer Duration"),
              SizedBox(height: 24),
             
              
              _buildSliderSetting(
                "Focus Session",
                _secondsToMinutes(_pomodoroDuration),
                5,
                60,
                (value) {
                  setState(() {
                    _pomodoroDuration = _minutesToSeconds(value);
                  });
                },
                const Color(0xFFFF5A5F),
              ),
             
              SizedBox(height: 32),
             
             
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
                const Color(0xFF56CFE1),
              ),
             
              SizedBox(height: 32),
             
              
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
                const Color(0xFF4EA8DE),
              ),
             
              SizedBox(height: 48),
             
              
              _buildSectionTitle("Background Theme"),
              SizedBox(height: 24),
             
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: colorOptions.map((color) {
                    bool isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? _accentColor : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: _accentColor.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ] : [],
                        ),
                        child: isSelected
                            ? Icon(Icons.check_rounded, color: _accentColor)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _textColor,
        ),
      ),
    );
  }


  Widget _buildSliderSetting(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
    Color accentColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${value.round()} min",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: accentColor.withOpacity(0.7),
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: accentColor,
              overlayColor: accentColor.withOpacity(0.2),
              trackHeight: 4,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: (max - min).round(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

