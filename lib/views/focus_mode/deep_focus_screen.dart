import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'pomodoro_timer.dart';
import 'distraction_blocker.dart';
import '../focus_mode/progress_tracking.dart';
import '../focus_mode/deadLine_buddy.dart';
import 'challenge_yourself.dart';
import '../focus_mode/to_do_list.dart';
import 'challenge_yourself.dart';
import 'modern_clock.dart';

class DeepFocusScreen extends StatefulWidget {
  const DeepFocusScreen({Key? key}) : super(key: key);

  @override
  _DeepFocusScreenState createState() => _DeepFocusScreenState();
}

class _DeepFocusScreenState extends State<DeepFocusScreen>
    with SingleTickerProviderStateMixin {
  final Color primaryBackground = const Color(0xFFF5F5F5);
  final Color cardBackground = const Color(0xFFFFFFFF);
  final Color accentBackground = const Color(0xFFE8ECEF);
  final Color primaryButton = const Color(0xFF4A90E2);
  final Color secondaryButton = const Color(0xFFD3E4F9);
  final Color primaryText = const Color(0xFF1A1A1A);
  final Color secondaryText = const Color(0xFF6B7280);
  final Color accentText = const Color(0xFF4A90E2);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _focusModules = [
    {
      'title': 'Pomodoro',
      'icon': Icons.timer,
      'description': 'Timed focus sessions.',
      'widget': const PomodoroScreen(),
    },
    {
      'title': 'Blocker',
      'icon': Icons.block,
      'description': 'Block distractions.',
      'widget': const DistractionBlocker(),
    },
    {
      'title': 'Progress',
      'icon': Icons.show_chart,
      'description': 'Track your progress.',
      'widget': const ProgressTrackerPage(),
    },
    // {
    //   'title': 'Deadline Buddy',
    //   'icon': Icons.alarm_on,
    //   'description': 'Smart reminders.',
    //   'widget': const DeadLineBuddy(),
    // },
    {
      'title': 'Challenge',
      'icon': Icons.star_border,
      'description': 'Engaging focus tasks.',
      'widget': const ChallengeYourself(),
    },
    {
      'title': 'To-Do List',
      'icon': Icons.check_circle_outline,
      'description': 'Organize your tasks.',
      'widget': const ToDoList(),
    },

    {
      'title': 'Modern Clock',
      'icon': Icons.check_circle_outline,
      'description': 'Organize your tasks.',
      'widget': const ModernClockPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                color: primaryBackground,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: accentBackground,
                      elevation: 0,
                      title: Text(
                        'Deep Focus',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: primaryText,
                          letterSpacing: 0.5,
                          fontFamily: 'SFProDisplay',
                        ),
                      ),
                      pinned: false,
                      floating: true,
                      centerTitle: false,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardBackground,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primaryText.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: -2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Focused Productivity',
                                      style: TextStyle(
                                        color: primaryText,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SFProDisplay',
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Tools for seamless work',
                                      style: TextStyle(
                                        color: secondaryText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'SFProDisplay',
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: primaryButton,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Start',
                                          style: TextStyle(
                                            color: cardBackground,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'SFProDisplay',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  color: secondaryButton,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.auto_awesome,
                                  color: primaryText,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Your Tools',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: primaryText,
                            fontFamily: 'SFProDisplay',
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.88,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final module = _focusModules[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => module['widget']),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardBackground,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryText.withOpacity(0.05),
                                      blurRadius: 8,
                                      spreadRadius: -1,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: secondaryButton,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          module['icon'],
                                          color: primaryText,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        module['title'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: primaryText,
                                          fontFamily: 'SFProDisplay',
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Expanded(
                                        child: Text(
                                          module['description'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: secondaryText,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'SFProDisplay',
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: primaryButton,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Open',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: cardBackground,
                                            fontFamily: 'SFProDisplay',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: _focusModules.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
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

