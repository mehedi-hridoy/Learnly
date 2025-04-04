import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF7bf609),
      body: Center(
        child: Text('Dashboard', style: TextStyle(fontSize: 24, color: Colors.black)),
      ),
    );
  }
}
