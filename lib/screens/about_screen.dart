import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset("assets/images/me.png", height: 150),
            const SizedBox(height: 20),
            const Text(
              "This app provides Sinhala New Year auspicious times.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            const Text("Developed by: G.V.P.S Vihagana"),
            const Text("Email: sayuruvihagana2@gmail.com"),
          ],
        ),
      ),
    );
  }
}
