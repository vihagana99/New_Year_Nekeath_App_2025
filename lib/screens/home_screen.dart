import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
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
  List<Event> upcomingEvents = [];
  List<Event> passedEvents = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
    checkAndRequestPermission();
  }

  Future<void> checkAndRequestPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      print("Location permission granted");
    } else if (status.isDenied) {
      var requestStatus = await Permission.location.request();
      if (requestStatus.isGranted) {
        print("Location permission granted");
      } else {
        print("Location permission denied");
        showPermissionDeniedDialog();
      }
    } else if (status.isPermanentlyDenied) {
      print("Location permission permanently denied");
      openAppSettings();
    }
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
              'Location permission is required to access certain features. Please allow it in the app settings.'),
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

  Future<void> loadEvents() async {
    String jsonString = await rootBundle.loadString('assets/events.json');
    List<dynamic> jsonList = json.decode(jsonString);

    upcomingEvents = jsonList
        .map((json) => Event.fromJson(json))
        .where((event) => event.targetDate.isAfter(DateTime.now()))
        .toList();

    passedEvents = jsonList
        .map((json) => Event.fromJson(json))
        .where((event) => event.targetDate.isBefore(DateTime.now()))
        .toList();

    setState(() {});
  }

  int getCrossAxisCount(BoxConstraints constraints) {
    if (constraints.maxWidth > 900) {
      return 3;
    } else if (constraints.maxWidth > 600) {
      return 2;
    } else {
      return 1;
    }
  }

  double getChildAspectRatio(BoxConstraints constraints) {
    if (constraints.maxWidth > 900) {
      return 1.5;
    } else if (constraints.maxWidth > 600) {
      return 2.0;
    } else {
      return 2.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(155, 255, 230, 2),
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
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = getCrossAxisCount(constraints);
          double aspectRatio = getChildAspectRatio(constraints);

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/bg_image_home.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
              upcomingEvents.isEmpty && passedEvents.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                children: [
                  if (upcomingEvents.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upcoming Events',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: aspectRatio,
                            ),
                            itemCount: upcomingEvents.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(event: upcomingEvents[index]),
                                    ),
                                  );
                                },
                                child: EventCard(event: upcomingEvents[index]),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  if (passedEvents.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Past Events',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: aspectRatio,
                            ),
                            itemCount: passedEvents.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(event: passedEvents[index]),
                                    ),
                                  );
                                },
                                child: EventCard(event: passedEvents[index]),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
