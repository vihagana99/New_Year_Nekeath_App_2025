import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor:
            Color.fromARGB(255, 255, 193, 7), // Matching theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(75), // Making image circular
              child: Image.asset("assets/images/me.png", height: 150),
            ),
            const SizedBox(height: 20),
            const Text(
              "This app provides Sinhala New Year auspicious times.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              "Developed by: G.V.P.S Vihagana",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Email: sayuruvihagana2@gmail.com",
              style: TextStyle(fontSize: 14, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
