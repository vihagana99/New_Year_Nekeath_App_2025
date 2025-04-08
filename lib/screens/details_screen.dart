import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
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
  StreamSubscription<CompassEvent>? _compassSubscription;
  double? _lastDirection;

  @override
  void initState() {
    super.initState();
    updateCountdown();
    if (widget.event.compassRequired) {
      requestPermission();
    }
  }

  void requestPermission() async {
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      _startCompass();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      showPermissionDeniedDialog();
    }
  }

  void _startCompass() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent? event) {
      if (event == null) return;

      double newDirection = event.heading ?? 0;
      if (newDirection < 0) {
        newDirection += 360;
      }

      if (_lastDirection == null || (newDirection - _lastDirection!).abs() > 2) {
        setState(() {
          _direction = newDirection;
          _lastDirection = newDirection;
        });
      }
    });
  }

  void updateCountdown() {
    setState(() {
      countdown = widget.event.countdownDuration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (countdown.inSeconds <= 0) {
        setState(() {
          countdown = Duration.zero;
        });
        timer.cancel();
        return;
      }

      setState(() {
        countdown -= const Duration(seconds: 1);
      });
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
  void dispose() {
    _timer?.cancel();
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
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
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          widget.event.image,
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.2,
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
                      // 🔔 Countdown or Time's Up message
                      countdown == Duration.zero
                          ? Text(
                        "🎉 Time's Up!",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                          : Row(
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
                            fontSize: MediaQuery.of(context).size.width * 0.03,
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
                          angle: ((_direction ?? 0) * (-3.14159265359 / 180)),
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

// 📦 CountdownCard
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
