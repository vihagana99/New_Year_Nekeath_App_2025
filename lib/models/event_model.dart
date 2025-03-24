import 'dart:convert';
import 'package:flutter/services.dart';

class Event {
  final String title;
  final String description;
  final String image;
  final DateTime targetDate;

  Event({
    required this.title,
    required this.description,
    required this.image,
    required this.targetDate,
  });

  // JSON එකෙන් Object එකක් හදාගන්න method එක
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      targetDate: DateTime.parse(json['targetDate']),
    );
  }

  // List එකක් JSON වලට Convert කරන්න
  static Future<List<Event>> loadEvents() async {
    final String response = await rootBundle.loadString('assets/events.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Event.fromJson(json)).toList();
  }

  // Calculate the countdown duration
  Duration get countdownDuration {
    return targetDate.difference(DateTime.now());
  }
}
