import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class WorldClock {
  final String city;
  final String timeZone;
  final String countryCode;
  final int offsetHours;

  WorldClock({
    required this.city, 
    required this.timeZone, 
    required this.countryCode,
    required this.offsetHours
  });
}

class ModernClockPage extends StatefulWidget {
  const ModernClockPage({Key? key}) : super(key: key);

  @override
  _ModernClockPageState createState() => _ModernClockPageState();
}

class _ModernClockPageState extends State<ModernClockPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showSettingsMenu = false;
  bool _showCitySelector = false;
  Color _selectedClockColor = const Color(0xFF2A9D8F);
  Color _backgroundColor = Colors.grey.shade100;
  Color _foregroundColor = Colors.white;
  
  final List<WorldClock> _worldClocks = [
    WorldClock(city: "Dhaka", timeZone: "Asia/Dhaka", countryCode: "BD", offsetHours: 6),
    WorldClock(city: "New York", timeZone: "America/New_York", countryCode: "US", offsetHours: -4),
    WorldClock(city: "London", timeZone: "Europe/London", countryCode: "GB", offsetHours: 1),
    WorldClock(city: "Tokyo", timeZone: "Asia/Tokyo", countryCode: "JP", offsetHours: 9),
    WorldClock(city: "Sydney", timeZone: "Australia/Sydney", countryCode: "AU", offsetHours: 10),
    WorldClock(city: "Dubai", timeZone: "Asia/Dubai", countryCode: "AE", offsetHours: 4),
    WorldClock(city: "Paris", timeZone: "Europe/Paris", countryCode: "FR", offsetHours: 2),
    WorldClock(city: "Singapore", timeZone: "Asia/Singapore", countryCode: "SG", offsetHours: 8),
    WorldClock(city: "Los Angeles", timeZone: "America/Los_Angeles", countryCode: "US", offsetHours: -7),
    WorldClock(city: "Berlin", timeZone: "Europe/Berlin", countryCode: "DE", offsetHours: 2),
  ];
  
  int _selectedClockIndex = 0;
  
  final List<Color> _colorOptions = [
    const Color(0xFFF0E4D7),
    const Color(0xFFE5ECF4),
    const Color(0xFFF9EAC2),
    const Color(0xFF000000),
    const Color(0xFF2D2D2D),
    const Color(0xFF2A9D8F),
    const Color(0xFFFFFFFF),
    const Color(0xFF808080),
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  DateTime _getTimeInTimeZone(String timeZone, int offsetHours) {
    final now = DateTime.now().toUtc();
    return now.add(Duration(hours: offsetHours));
  }
  
  void _toggleSettingsMenu() {
    setState(() {
      _showSettingsMenu = !_showSettingsMenu;
      if (_showSettingsMenu && _showCitySelector) {
        _showCitySelector = false;
      }
    });
  }
  
  void _toggleCitySelector() {
    setState(() {
      _showCitySelector = !_showCitySelector;
      if (_showCitySelector && _showSettingsMenu) {
        _showSettingsMenu = false;
      }
    });
  }
  
  void _selectClockColor(Color color) {
    setState(() {
      _selectedClockColor = color;
    });
  }
  
  void _selectBackgroundColor(Color color) {
    setState(() {
      _backgroundColor = color;
    });
  }
  
  void _selectForegroundColor(Color color) {
    setState(() {
      _foregroundColor = color;
    });
  }
  
  void _selectCity(int index) {
    setState(() {
      _selectedClockIndex = index;
      _showCitySelector = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWorldClockTab(),
          _buildStopwatchTab(),
        ],
      ),
    );
  }
  
  Widget _buildWorldClockTab() {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Stack(
          children: [
            orientation == Orientation.landscape
                ? _buildMainClockLandscape()
                : _buildMainClockPortrait(),
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: [
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: _selectedClockColor,
                    onPressed: _toggleCitySelector,
                    child: Icon(Icons.location_city, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: _selectedClockColor,
                    onPressed: _toggleSettingsMenu,
                    child: Icon(Icons.settings, color: Colors.white),
                  ),
                ],
              ),
            ),
            if (_showSettingsMenu) _buildSettingsMenu(),
            if (_showCitySelector) _buildCitySelectorDialog(),
          ],
        );
      },
    );
  }
  
  Widget _buildMainClockLandscape() {
    final selectedClock = _worldClocks[_selectedClockIndex];
    
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = _getTimeInTimeZone(selectedClock.timeZone, selectedClock.offsetHours);
        final hourStr = now.hour.toString().padLeft(2, '0');
        final minuteStr = now.minute.toString().padLeft(2, '0');
        final secondStr = now.second.toString().padLeft(2, '0');
        
        return Container(
          color: _backgroundColor,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hourStr,
                  style: TextStyle(
                    fontSize: 200,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    ":",
                    style: TextStyle(
                      fontSize: 200,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  minuteStr,
                  style: TextStyle(
                    fontSize: 200,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        secondStr,
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: _selectedClockColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMainClockPortrait() {
    final selectedClock = _worldClocks[_selectedClockIndex];
    
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = _getTimeInTimeZone(selectedClock.timeZone, selectedClock.offsetHours);
        final dateStr = DateFormat('dd/MM/yy').format(now);
        final dayName = DateFormat('EEEE').format(now);
        final hourStr = now.hour.toString().padLeft(2, '0');
        final minuteStr = now.minute.toString().padLeft(2, '0');
        final isPM = now.hour >= 12;
        
        return Container(
          color: _backgroundColor,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedClockColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _selectedClockColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            selectedClock.countryCode,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _selectedClockColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        selectedClock.city,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          height: 220,
                          color: _foregroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      hourStr,
                                      style: const TextStyle(
                                        fontSize: 120,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                color: _foregroundColor,
                                child: Center(
                                  child: Text(
                                    isPM ? "PM" : "AM",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          height: 220,
                          color: _foregroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      minuteStr,
                                      style: const TextStyle(
                                        fontSize: 120,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                color: _foregroundColor,
                                alignment: Alignment.center,
                                child: Text(
                                  now.second.toString().padLeft(2, '0'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  String _getTimeDifference(int offsetHours) {
    final localOffset = DateTime.now().timeZoneOffset.inHours;
    final difference = offsetHours - localOffset;
    
    if (difference == 0) {
      return "Same time";
    } else if (difference > 0) {
      return "+$difference ${difference == 1 ? 'hour' : 'hours'}";
    } else {
      return "$difference ${difference == -1 ? 'hour' : 'hours'}";
    }
  }
  
  Widget _buildSettingsMenu() {
    return GestureDetector(
      onTap: _toggleSettingsMenu,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.black26,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(40),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: _selectedClockColor),
                        onPressed: _toggleSettingsMenu,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.location_city, color: _selectedClockColor),
                    title: const Text("Select City"),
                    onTap: _toggleCitySelector,
                  ),
                  const Divider(),
                  const Text(
                    "Theme Settings",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Accent Color",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _colorOptions.map((color) {
                      final isSelected = _selectedClockColor == color;
                      return GestureDetector(
                        onTap: () => _selectClockColor(color),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(color: _selectedClockColor, width: 2)
                                : null,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: color == Colors.white ? Colors.black : Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Background Color",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _colorOptions.map((color) {
                      final isSelected = _backgroundColor == color;
                      return GestureDetector(
                        onTap: () => _selectBackgroundColor(color),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(color: _selectedClockColor, width: 2)
                                : null,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: color == Colors.white ? Colors.black : Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Foreground Color",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _colorOptions.map((color) {
                      final isSelected = _foregroundColor == color;
                      return GestureDetector(
                        onTap: () => _selectForegroundColor(color),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(color: _selectedClockColor, width: 2)
                                : null,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: color == Colors.white ? Colors.black : Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildCitySelectorDialog() {
    return GestureDetector(
      onTap: _toggleCitySelector,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.black26,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(40),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select City",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: _selectedClockColor),
                        onPressed: _toggleCitySelector,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 300,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _worldClocks.length,
                      itemBuilder: (context, index) {
                        final clock = _worldClocks[index];
                        final isSelected = _selectedClockIndex == index;
                        
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectCity(index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected ? _selectedClockColor.withOpacity(0.1) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _selectedClockColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        clock.countryCode,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _selectedClockColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          clock.city,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          _getTimeDifference(clock.offsetHours),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: Stream.periodic(const Duration(seconds: 1)),
                                    builder: (context, snapshot) {
                                      final now = _getTimeInTimeZone(clock.timeZone, clock.offsetHours);
                                      final timeStr = DateFormat('HH:mm').format(now);
                                      
                                      return Text(
                                        timeStr,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: _selectedClockColor,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildStopwatchTab() {
    return StopwatchScreen(
      key: UniqueKey(),
      accentColor: _selectedClockColor,
      backgroundColor: _backgroundColor,
      foregroundColor: _foregroundColor,
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  final Color accentColor;
  final Color backgroundColor;
  final Color foregroundColor;
  
  const StopwatchScreen({
    Key? key,
    required this.accentColor,
    required this.backgroundColor,
    required this.foregroundColor,
  }) : super(key: key);

  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> with SingleTickerProviderStateMixin {
  bool _isRunning = false;
  int _elapsedTimeInMilliseconds = 0;
  Timer? _timer;
  List<int> _laps = [];
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }
  
  void _toggleStopwatch() {
    if (_isRunning) {
      _pauseStopwatch();
    } else {
      _startStopwatch();
    }
  }
  
  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          _elapsedTimeInMilliseconds += 10;
        });
      });
    });
  }
  
  void _pauseStopwatch() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }
  
  void _resetStopwatch() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _elapsedTimeInMilliseconds = 0;
      _laps = [];
    });
  }
  
  void _recordLap() {
    if (_isRunning) {
      setState(() {
        _laps.insert(0, _elapsedTimeInMilliseconds);
      });
    }
  }
  
  String _formatTime(int milliseconds) {
    final minutes = (milliseconds / (1000 * 60)).floor().toString().padLeft(2, '0');
    final seconds = ((milliseconds / 1000) % 60).floor().toString().padLeft(2, '0');
    final ms = ((milliseconds % 1000) / 10).floor().toString().padLeft(2, '0');
    return '$minutes:$seconds.$ms';
  }
  
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape
            ? _buildLandscapeLayout()
            : _buildPortraitLayout();
      },
    );
  }
  
  Widget _buildPortraitLayout() {
    return Container(
      color: widget.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 16),
            child: Text(
              "STOPWATCH",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.accentColor,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: widget.accentColor.withOpacity(0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildStopwatchDisplay(),
          ),
          Expanded(
            flex: 4,
            child: _buildLapsListView(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLandscapeLayout() {
    return Container(
      color: widget.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "STOPWATCH",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.accentColor,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: widget.accentColor.withOpacity(0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildStopwatchDisplay(),
                ),
                Expanded(
                  child: _buildLapsListView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStopwatchDisplay() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: widget.foregroundColor,
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  widget.accentColor.withOpacity(0.1),
                  widget.accentColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _formatTime(_elapsedTimeInMilliseconds),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'monospace',
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStopwatchButton(
                icon: Icons.refresh,
                onPressed: _resetStopwatch,
                color: Colors.deepOrangeAccent,
              ),
              _buildStopwatchButton(
                icon: _isRunning ? Icons.pause : Icons.play_arrow,
                onPressed: _toggleStopwatch,
                color: widget.accentColor,
                size: 64,
                iconSize: 32,
              ),
              _buildStopwatchButton(
                icon: Icons.flag,
                onPressed: _recordLap,
                color: Colors.purpleAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStopwatchButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    double size = 50,
    double iconSize = 24,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: iconSize),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
  
  Widget _buildLapsListView() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.foregroundColor,
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            widget.accentColor.withOpacity(0.05),
            widget.accentColor.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  "LAPS",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.accentColor,
                  ),
                ),
                const Spacer(),
                Text(
                  "TIME",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.accentColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Expanded(
            child: _laps.isEmpty
                ? Center(
                    child: Text(
                      "No laps recorded",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _laps.length,
                    itemBuilder: (context, index) {
                      final lapNumber = _laps.length - index;
                      final lapTime = _laps[index];
                      final previousLapTime = index < _laps.length - 1 ? _laps[index + 1] : 0;
                      final lapDuration = index < _laps.length - 1 ? lapTime - previousLapTime : lapTime;
                      
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Lap $lapNumber",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _formatTime(lapTime),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'monospace',
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "+${_formatTime(lapDuration)}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: widget.accentColor,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class AnimatedClock extends StatelessWidget {
  final Color color;
  final Animation<double> controller;

  const AnimatedClock({
    Key? key,
    required this.color,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ClockPainter(
            color: color,
            secondHandAngle: controller.value * 2 * math.pi,
          ),
          size: const Size(40, 40),
        );
      },
    );
  }
}

class ClockPainter extends CustomPainter {
  final Color color;
  final double secondHandAngle;

  ClockPainter({
    required this.color,
    required this.secondHandAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 1, borderPaint);

    final handPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final handLength = radius * 0.8;
    final secondHandX = center.dx + handLength * math.sin(secondHandAngle);
    final secondHandY = center.dy - handLength * math.cos(secondHandAngle);
    
    canvas.drawLine(
      center,
      Offset(secondHandX, secondHandY),
      handPaint,
    );

    final centerDotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3, centerDotPaint);
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    return oldDelegate.secondHandAngle != secondHandAngle ||
        oldDelegate.color != color;
  }
}
