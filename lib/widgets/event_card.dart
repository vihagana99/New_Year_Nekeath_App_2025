import 'package:flutter/material.dart';
import 'dart:async';
import '/models/event_model.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late Timer _timer;
  late Duration _countdown;

  @override
  void initState() {
    super.initState();
    _countdown = widget.event.targetDate.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), _updateCountdown);
  }

  void _updateCountdown(Timer timer) {
    setState(() {
      _countdown = widget.event.targetDate.difference(DateTime.now());
      if (_countdown.isNegative) {
        _countdown = Duration.zero;
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double imageSize = constraints.maxWidth > 600 ? 160 : 90;
        double fontSize = constraints.maxWidth > 600 ? 20 : 18;

        return Card(
          margin: const EdgeInsets.all(5),
          elevation: 6,
          color: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.event.image,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.event.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        alignment: WrapAlignment.center,
                        children: [
                          CountdownCard(label: "Days", value: _countdown.inDays),
                          CountdownCard(label: "Hours", value: _countdown.inHours % 24),
                          CountdownCard(label: "Minutes", value: _countdown.inMinutes % 60),
                          CountdownCard(label: "Seconds", value: _countdown.inSeconds % 60),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CountdownCard extends StatelessWidget {
  final String label;
  final int value;

  const CountdownCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color.fromARGB(255, 231, 219, 167),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        child: Column(
          children: [
            Text(
              value.toString().padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
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
    );
  }
}
