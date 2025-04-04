import 'package:flutter/material.dart';

class AIScreen extends StatelessWidget {
  const AIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFc43b82),
      body: Center(
        child: Text('AI Tools', style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}
