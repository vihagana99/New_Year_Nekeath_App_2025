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
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
    checkAndRequestPermission(); // Request permission as soon as the home screen is loaded
  }

  // Check and request location permission
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
        // Optionally, you can show a dialog explaining why the permission is needed
        showPermissionDeniedDialog();
      }
    } else if (status.isPermanentlyDenied) {
      print("Location permission permanently denied");
      // Open app settings to manually enable permission
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
    setState(() {
      events = jsonList.map((json) => Event.fromJson(json)).toList();
    });
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
          double width = constraints.maxWidth;
          bool isLargeScreen = width > 600;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/bg_image_home.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
              events.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isLargeScreen ? 3 : 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: isLargeScreen ? 1.5 : 2.5,
                ),
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
          );
        },
      ),
    );
  }
}
