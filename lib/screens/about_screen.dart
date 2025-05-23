import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, color: Colors.white, size: 60),
                const SizedBox(height: 10),
                const Text(
                  "Thank You!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We appreciate your support! Enjoy the app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purpleAccent,
                  ),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: const Color(0xFFFFC107),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: Image.asset("assets/images/me.jpg", height: 150),
            ),
            const SizedBox(height: 20),
            const Text(
              "Aluth Avurudu Neketh 2025 - Your trusted guide for Sinhala New Year auspicious times, now with improved accuracy and user experience.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            const Text(
              "Developed by: G.V.P.S Vihagana",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.link, color: Colors.blueAccent),
                  onPressed: () => _launchURL("https://github.com/vihagana99"),
                ),
                GestureDetector(
                  onTap: () => _launchURL("https://github.com/vihagana99"),
                  child: const Text(
                    "GitHub: github.com/vihagana99",
                    style: TextStyle(fontSize: 14, color: Colors.blueAccent, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.email, color: Colors.redAccent),
                  onPressed: () => _launchURL("mailto:sayuruvihagana2@gmail.com"),
                ),
                GestureDetector(
                  onTap: () => _launchURL("mailto:sayuruvihagana2@gmail.com"),
                  child: const Text(
                    "Email: sayuruvihagana2@gmail.com",
                    style: TextStyle(fontSize: 14, color: Colors.blueAccent, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showThankYouDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text("Thank You for Downloading", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
