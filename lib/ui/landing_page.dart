import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Landing Page")),
      body: Center(
        child: Text(
          "Opened from Notification!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
