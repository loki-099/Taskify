import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/routes/app_routes.dart';
import 'package:taskify/utils/colors.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showInstantNotification({
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

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed:
          // () => Navigator.pushNamed(context, AppRoutes.notificationsScreen),
          () => showInstantNotification(
            id: 0,
            title: "Hello",
            body: "Try Notifications",
          ),
      icon: Badge(
        // label: Text(""),
        isLabelVisible: true,
        smallSize: 12,
        backgroundColor: Color(0xff06BEE1),
        child: Icon(Icons.notifications, color: AppColors.colorText),
      ),
      iconSize: 30,
    );
  }
}
