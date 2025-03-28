import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async'; // Import Timer package
import '/models/event_model.dart';

class DetailsScreen extends StatefulWidget {
  final Event event;

  const DetailsScreen({super.key, required this.event});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Duration countdown = const Duration();
  double? _direction;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    updateCountdown();

    if (widget.event.compassRequired) {
      requestPermission();
    }
  }

  void requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _startCompass();
    } else {
      showPermissionDeniedDialog();
    }
  }

  void _startCompass() {
    FlutterCompass.events!.listen((CompassEvent event) {
      setState(() {
        _direction = event.heading;
      });
    });
  }

  void updateCountdown() {
    setState(() {
      countdown = widget.event.countdownDuration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.inSeconds <= 0) {
        setState(() {
          countdown = const Duration(seconds: 0); // Stop at 00:00:00
        });
        timer.cancel(); // Cancel the timer when countdown hits zero
      } else {
        setState(() {
          countdown -= const Duration(seconds: 1);
        });
      }
    });
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Location permission is required to access the compass.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/images/bg_image_details.jpeg",
            fit: BoxFit.cover,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(  // Add border here
                      color: Colors.black,  // Set your desired border color
                      width: 2,  // Set the width of the border
                    ),
                    color: Colors.white.withOpacity(0.1),  // slightly opaque white
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          widget.event.image,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.event.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CountdownCard(label: "Days", value: countdown.inDays),
                          CountdownCard(label: "Hours", value: countdown.inHours % 24),
                          CountdownCard(label: "Minutes", value: countdown.inMinutes % 60),
                          CountdownCard(label: "Seconds", value: countdown.inSeconds % 60),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          widget.event.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (widget.event.compassRequired) ...[
                        _direction == null
                            ? const CircularProgressIndicator()
                            : Transform.rotate(
                          angle: (_direction ?? 0) * (3.14159 / 180),
                          child: Image.asset(
                            "assets/images/compass_arrow.png",
                            width: MediaQuery.of(context).size.height * 0.25,
                            height: MediaQuery.of(context).size.height * 0.25,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: MediaQuery.of(context).size.width * 0.15,
                          ),
                          backgroundColor: const Color.fromARGB(255, 142, 87, 252),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CountdownCard class definition
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
                  fontSize: 23,
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
