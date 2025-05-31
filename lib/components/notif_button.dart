import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/routes/app_routes.dart';
import 'package:taskify/utils/colors.dart';
import 'package:taskify/utils/notification_service.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed:
          () => Navigator.pushNamed(context, AppRoutes.notificationsScreen),
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
