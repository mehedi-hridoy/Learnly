import 'package:flutter/material.dart';

class DistractionBlocker extends StatelessWidget {
  const DistractionBlocker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Distraction Blocker'),
        ),
        body: Center(
            child: Text('Coocking ..!'),
        ),
    );
  }
}