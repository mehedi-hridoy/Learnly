import 'package:flutter/material.dart';
// Commiting for test
void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: const Text( 
              'Learnly',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: const Center(
          child: Text(
            'Welcome to Learnly!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
