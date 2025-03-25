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
    // Update countdown every second
    _timer = Timer.periodic(const Duration(seconds: 1), _updateCountdown);
  }

  void _updateCountdown(Timer timer) {
    setState(() {
      _countdown = widget.event.targetDate.difference(DateTime.now());
      if (_countdown.isNegative) {
        _countdown = Duration.zero;
        timer.cancel(); // Stop the timer if the event is in the past
      }
    });
  }

  String _formatDuration(Duration duration) {
    return "${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s";
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      elevation: 5,
      color: Color.fromARGB(0, 0, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.event.title,
              style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Add space between title and countdown
            // Countdown Row with spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CountdownCard(label: "Days", value: _countdown.inDays),
                const SizedBox(width: 10), // Space between countdown cards
                CountdownCard(label: "Hours", value: _countdown.inHours % 24),
                const SizedBox(width: 10), // Space between countdown cards
                CountdownCard(
                    label: "Minutes", value: _countdown.inMinutes % 60),
                const SizedBox(width: 10), // Space between countdown cards
                CountdownCard(
                    label: "Seconds", value: _countdown.inSeconds % 60),
              ],
            ),
          ],
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            widget.event.image,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Card(
        elevation: 5,
        color: Color.fromARGB(255, 231, 219, 167),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Column(
            children: [
              Text(
                value.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 20, // Increase font size for better readability
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 0),
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
