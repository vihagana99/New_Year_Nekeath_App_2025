import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart'; // Import the flutter_compass package
import '/models/event_model.dart';

class DetailsScreen extends StatefulWidget {
  final Event event;

  const DetailsScreen({super.key, required this.event});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Duration countdown = const Duration();
  double? _direction; // Variable to store the compass direction

  @override
  void initState() {
    super.initState();
    updateCountdown();
    _startCompass();
  }

  void updateCountdown() {
    setState(() {
      countdown = widget.event.countdownDuration;
    });
    Future.delayed(const Duration(seconds: 1), updateCountdown);
  }

  void _startCompass() {
    FlutterCompass.events!.listen((CompassEvent event) {
      setState(() {
        _direction = event.heading; // Update the compass direction
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 248, 192, 115),
              Color.fromARGB(255, 247, 139, 85)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/images/bg_image_details.jpeg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Card(
                elevation: 1000,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(widget.event.image,
                            height: 150, width: 300, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        widget.event.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CountdownCard(label: "Days", value: countdown.inDays),
                          CountdownCard(
                              label: "Hours", value: countdown.inHours % 24),
                          CountdownCard(
                              label: "Minutes",
                              value: countdown.inMinutes % 60),
                          CountdownCard(
                              label: "Seconds",
                              value: countdown.inSeconds % 60),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              widget.event.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _direction == null
                          ? const CircularProgressIndicator() // Loading spinner while waiting for compass data
                          : Transform.rotate(
                              angle: (_direction ?? 0) *
                                  (3.14159 / 180), // Convert degrees to radians
                              child: Image.asset(
                                "assets/images/compass_arrow.png",
                                width: 250,
                                height: 250,
                              ),
                            ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 30.0),
                          backgroundColor:
                              const Color.fromARGB(255, 142, 87, 252),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CountdownCard extends StatelessWidget {
  final String label;
  final int value;

  const CountdownCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        elevation: 5,
        color: Colors.deepPurple.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                value.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
