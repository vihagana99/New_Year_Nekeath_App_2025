import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '/models/event_model.dart';
import '/screens/about_screen.dart';
import '/screens/details_screen.dart';
import '/widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    String jsonString = await rootBundle.loadString('assets/events.json');
    List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      events = jsonList.map((json) => Event.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(155, 255, 230, 2),
        title: const Text(
          "අලුත් අවුරුදු නැකත් සීට්ටුව",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg_image_home.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          events.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsScreen(event: events[index]),
                          ),
                        );
                      },
                      child: EventCard(event: events[index]),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
