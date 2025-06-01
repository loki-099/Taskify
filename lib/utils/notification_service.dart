import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    initializeTimeZones();

    setLocalLocation(getLocation('Asia/Shanghai'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await notificationsPlugin.initialize(initializationSettings);
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notification_channel_id',
          'Instant Notifications',
          channelDescription: 'Instant notification channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> setReminderForDeadline({
    required int id,
    required String title,
    required String body,
    required DateTime deadline,
    required int reminderMinutesBefore,
  }) async {
    final reminderTime = deadline.subtract(
      Duration(minutes: reminderMinutesBefore),
    );

    // Convert to TZDateTime in local timezone
    final scheduledDate = tz.TZDateTime.from(reminderTime, tz.local);

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      // Don't schedule notifications in the past
      print('Reminder time is in the past, skipping notification scheduling');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'instant_notification_channel_id',
      'Instant Notifications',
      channelDescription: 'Instant notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // Match exact time on Android 12+
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: jsonEncode({
        'reminder_minutes': reminderMinutesBefore,
        'deadline': DateFormat('hh:mm a, MM/dd/yyyy').format(deadline),
      }),
    );
    print("Notification Set");
  }

  static setReminders(Map<String, dynamic> task) {
    print("Setting reminder...");
    if (task['task_status'] == 'inp') {
      if (task['task_deadline'] != null) {
        final deadline = DateTime.parse(task['task_deadline']).toLocal();
        final title = task['task_title'];
        final minutesBefore = task['reminder_minutes_before'];
        setReminderForDeadline(
          id: task['id'],
          title: title,
          body: "$title is due in $minutesBefore minutes!",
          deadline: deadline,
          reminderMinutesBefore: minutesBefore,
        );
      }
    }
  }

  static Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  static Future<bool> isThereNotifications() async {
    final pending = await notificationsPlugin.pendingNotificationRequests();
    if (pending.isNotEmpty) {
      print("True");
      return true;
    } else {
      print("False");
      return false;
    }
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await notificationsPlugin.pendingNotificationRequests();
  }
}
