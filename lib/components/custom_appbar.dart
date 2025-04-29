import 'package:flutter/material.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final montserratFont = GoogleFonts.montserrat().fontFamily;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final darkColor = Color(0xFF1C2D51);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(top: statusBarHeight, left: 4, right: 4),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: AuthService().signOut,
                      icon: Icon(Icons.account_circle_sharp, color: darkColor),
                      iconSize: 50,
                    ),
                    FutureBuilder(
                      future: AuthService().getFirstName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const Text("Hello, User!");
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hello!",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: darkColor,
                              ),
                            ),
                            Text(
                              snapshot.data ?? "User",
                              style: TextStyle(
                                fontFamily: montserratFont,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: darkColor,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                IconButton(
                  onPressed: AuthService().signOut,
                  icon: Icon(Icons.notifications, color: darkColor),
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize {
    final statusBarHeight =
        WidgetsBinding.instance.window.padding.top /
        WidgetsBinding.instance.window.devicePixelRatio;
    return Size.fromHeight(statusBarHeight + kToolbarHeight);
  }
}
