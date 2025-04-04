import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFfe019a),
      body: Center(
        child: Text('Profile', style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}
