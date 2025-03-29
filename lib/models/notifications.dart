import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz; // Import timezone package
import 'package:timezone/data/latest.dart'
    as tz_data; // Import the timezone data

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    // Initialize timezone package with the latest timezone data
    tz_data.initializeTimeZones();
  }

  static Future<void> scheduleNotification(
      String eventTitle, Duration duration) async {
    // Check if the duration is at least 5 minutes
    if (duration.inMinutes >= 5) {
      // Calculate the notification time
      DateTime notificationTime =
          DateTime.now().add(Duration(minutes: duration.inMinutes - 5));

      // Convert DateTime to TZDateTime (Timezone-aware DateTime)
      tz.TZDateTime tzNotificationTime =
          tz.TZDateTime.from(notificationTime, tz.local);

      // Ensure the notification time is not in the past
      if (tzNotificationTime.isBefore(tz.TZDateTime.now(tz.local))) {
        tzNotificationTime = tz.TZDateTime.now(tz.local).add(const Duration(
            minutes: 2)); // Default to 1 minute if the time is in the past
      }

      await _notificationsPlugin.zonedSchedule(
        0,
        "Event Reminder",
        "$eventTitle නැකතට තව මිනිත්තු 5යි!", // Message showing 5 minutes remaining
        tzNotificationTime, // Schedule notification at the calculated time
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'event_channel_id', // Notification channel ID
            'Event Notifications', // Channel name
            importance: Importance.high, // Notification importance level
            priority: Priority.high, // Notification priority level
          ),
        ),
        androidAllowWhileIdle:
            true, // Allow notification to be shown even if the app is idle
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation
                .absoluteTime, // Ensure the notification fires at the correct time
      );
    }
  }
}
