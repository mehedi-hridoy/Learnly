import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
// import 'profile_screen.dart';
import '../profile/profile.dart';
import '../focus_mode/deep_focus_screen.dart';
import '../ai_assistant/ai_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const DeepFocusScreen(),
    const AIScreen(),
    const ProfileScreen(),
  ];

  final List<Color> _navColors = [
    Color(0xFF7bf609),
    Color(0xFF2f91d0),
    Color(0xFFc43b82),
    Color(0xFFfe019a),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: _navColors[_currentIndex],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.center_focus_strong),
            label: 'Deep Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
