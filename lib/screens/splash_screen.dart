import 'dart:async';
import 'package:flutter/material.dart';
import '/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _rotation = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Delay for 5 seconds before navigating to the HomeScreen
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });

    // Periodically change the rotation angle
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          _rotation += 0.05; // Adjust this value to change the speed of rotation
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_loding.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Applying the rotation to the logo using Transform
            Transform.rotate(
              angle: _rotation,  // Continuously rotating angle
              child: SizedBox(
                width: 300,  // Set the width of the image
                height: 300, // Set the height of the image
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain, // Ensure the logo scales properly
                ),
              ),
            ),

            const SizedBox(height: 20), // Space between logo and text

            // Text with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.center, // Vertically center the text
                child: const Text(
                  'අලුත් අවුරුදු නැකත් සීට්ටුව 2025',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,  // Slightly larger font size for the text
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30), // Optional: add some space after the text
          ],
        ),
      ),
    );
  }
}
