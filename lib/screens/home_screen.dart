import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler
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
  List<Event> upcomingEvents = []; // List to store upcoming events
  List<Event> passedEvents = []; // List to store passed events

  @override
  void initState() {
    super.initState();
    loadEvents(); // Load events from the JSON file when the screen is loaded
    checkAndRequestPermission(); // Request location permission as soon as the home screen is loaded
  }

  // Check and request location permission
  Future<void> checkAndRequestPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      print("Location permission granted"); // If permission is granted, print a message
    } else if (status.isDenied) {
      var requestStatus = await Permission.location.request();
      if (requestStatus.isGranted) {
        print("Location permission granted"); // If permission is granted after request, print a message
      } else {
        print("Location permission denied");
        // Optionally, show a dialog explaining why the permission is needed
        showPermissionDeniedDialog();
      }
    } else if (status.isPermanentlyDenied) {
      print("Location permission permanently denied");
      // If the permission is permanently denied, open app settings to manually enable permission
      openAppSettings();
    }
  }

  // Function to show a dialog when location permission is denied
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

  // Load events and filter them by target date
  Future<void> loadEvents() async {
    String jsonString = await rootBundle.loadString('assets/events.json');
    List<dynamic> jsonList = json.decode(jsonString);

    // Filter out events whose target date has already passed
    upcomingEvents = jsonList
        .map((json) => Event.fromJson(json))
        .where((event) => event.targetDate.isAfter(DateTime.now())) // Filter upcoming events
        .toList();

    passedEvents = jsonList
        .map((json) => Event.fromJson(json))
        .where((event) => event.targetDate.isBefore(DateTime.now())) // Filter passed events
        .toList();

    setState(() {}); // Update the UI after loading and filtering the events
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
                MaterialPageRoute(builder: (context) => const AboutScreen()), // Navigate to the AboutScreen
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          bool isLargeScreen = width > 600; // Check if the screen is large

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/bg_image_home.jpeg", // Background image
                  fit: BoxFit.cover,
                ),
              ),
              upcomingEvents.isEmpty
                  ? const Center(child: CircularProgressIndicator()) // Show a loading indicator if no events are loaded
                  : ListView(
                children: [
                  // Upcoming Events Section
                  if (upcomingEvents.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upcoming Events', // Title for upcoming events
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
                              crossAxisCount: isLargeScreen ? 3 : 1, // Adjust number of columns based on screen size
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: isLargeScreen ? 1.5 : 2.5,
                            ),
                            itemCount: upcomingEvents.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(event: upcomingEvents[index]), // Navigate to DetailsScreen on tap
                                    ),
                                  );
                                },
                                child: EventCard(event: upcomingEvents[index]), // Display each event in a card
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  // Passed Events Section (Optional)
                  if (passedEvents.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Past Events', // Title for past events
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
                              crossAxisCount: isLargeScreen ? 3 : 1, // Adjust number of columns based on screen size
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: isLargeScreen ? 1.5 : 2.5,
                            ),
                            itemCount: passedEvents.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(event: passedEvents[index]), // Navigate to DetailsScreen on tap
                                    ),
                                  );
                                },
                                child: EventCard(event: passedEvents[index]), // Display each event in a card
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
