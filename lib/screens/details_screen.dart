import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
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
        _direction = event.heading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          bool isLargeScreen = width > 600;

          return SingleChildScrollView(
            // Make the entire content scrollable
            child: Container(
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
                    width: isLargeScreen ? width * 0.6 : width * 0.9,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image:
                            AssetImage("assets/images/bg_image_details.jpeg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Card(
                      elevation: 10,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(widget.event.image,
                                  height: height * 0.2,
                                  width: width * 0.8,
                                  fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              widget.event.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isLargeScreen ? 28 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CountdownCard(
                                    label: "Days", value: countdown.inDays),
                                CountdownCard(
                                    label: "Hours",
                                    value: countdown.inHours % 24),
                                CountdownCard(
                                    label: "Minutes",
                                    value: countdown.inMinutes % 60),
                                CountdownCard(
                                    label: "Seconds",
                                    value: countdown.inSeconds % 60),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                widget.event.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isLargeScreen ? 18 : 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _direction == null
                                ? const CircularProgressIndicator()
                                : Transform.rotate(
                                    angle: (_direction ?? 0) * (3.14159 / 180),
                                    child: Image.asset(
                                      "assets/images/compass_arrow.png",
                                      width: height * 0.3,
                                      height: height * 0.3,
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 14.0,
                                    horizontal: isLargeScreen ? 40.0 : 20.0),
                                backgroundColor:
                                    const Color.fromARGB(255, 142, 87, 252),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isLargeScreen ? 18 : 15,
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
              ),
            ),
          );
        },
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
