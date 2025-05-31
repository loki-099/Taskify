import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taskify/utils/colors.dart';
import 'package:taskify/utils/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(color: AppColors.colorText),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: NotificationService.isThereNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data == true) {
              return NotifWidgets();
            } else {
              return Center(child: Text("No upcoming reminders"));
            }
          },
        ),
      ),
    );
  }
}

class NotifWidgets extends StatefulWidget {
  const NotifWidgets({super.key});

  @override
  State<NotifWidgets> createState() => _NotifWidgetsState();
}

class _NotifWidgetsState extends State<NotifWidgets> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: NotificationService.getPendingNotifications(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final pendingNotifications = snapshot.data!;
          // Replace this with your actual widget to display notifications
          return ListView.separated(
            itemCount: pendingNotifications.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              final notification = pendingNotifications[index];
              return Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xffDFF0FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Container(
                      child: Icon(
                        Icons.access_time_rounded,
                        size: 40,
                        color: AppColors.color1,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorText,
                          ),
                        ),
                        Text(
                          () {
                            try {
                              if (notification.payload != null &&
                                  notification.payload.isNotEmpty) {
                                final payload = jsonDecode(
                                  notification.payload,
                                );
                                return "Reminds ${payload['reminder_minutes']} mins before deadline!";
                                // return "Your task deadline is approaching soon!";
                              }
                            } catch (e) {
                              print("Payload error: $e");
                            }
                            return "No reminder data";
                          }(),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.colorText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return Center(child: Text("No pending notifications"));
        }
      },
    );
  }
}
