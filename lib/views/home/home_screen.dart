import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../profile/profile.dart';
import '../focus_mode/deep_focus_screen.dart';
import '../ai_assistant/ai_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;


  final List<Widget> _pages = [
    const DashboardScreen(),
    const DeepFocusScreen(),
    const AIScreen(),
    const ProfileScreen(),
  ];


  
  final Color navBackground = const Color(0xFFFFFFFF); 
  final Color selectedAccent = const Color(0xFFB8E8E0); 
  final Color unselectedAccent = const Color(0xFFE6E0F0); 
  final Color selectedColor = const Color(0xFF000000); 
  final Color unselectedColor = const Color(0xFF333333);


  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBackground,
          boxShadow: [
            BoxShadow(
              color: selectedColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          backgroundColor: navBackground,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          iconSize: 24,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'SFProDisplay',
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'SFProDisplay',
            fontWeight: FontWeight.w400,
          ),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _animationController.forward(from: 0);
            });
          },
          items: List.generate(4, (index) => _buildNavItem(index)),
        ),
      ),
    );
  }


  BottomNavigationBarItem _buildNavItem(int index) {
    final List<IconData> icons = [
      Icons.grid_view_outlined, 
      Icons.center_focus_strong_outlined, 
      Icons.psychology_alt_outlined,
      Icons.person_outline, 
    ];


    final List<String> labels = [
      'Dashboard',
      'Deep Focus',
      'AI',
      'Profile',
    ];


    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _currentIndex == index ? _scaleAnimation.value : 1.0,
                child: Icon(
                  icons[index],
                  color: _currentIndex == index ? selectedColor : unselectedColor,
                ),
              );
            },
          ),
          if (_currentIndex == index)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 24,
              height: 2,
              color: selectedAccent,
            ),
        ],
      ),
      label: labels[index],
    );
  }
}

