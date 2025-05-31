import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/components/notif_button.dart';
import 'package:taskify/cubit/user_cubit.dart';
import 'package:taskify/cubit/user_state.dart';
import 'package:taskify/routes/app_routes.dart';

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
          padding: EdgeInsets.only(top: statusBarHeight - 15),
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
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        if (state.userData.isEmpty) {
                          return CircularProgressIndicator();
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello",
                              style: TextStyle(
                                fontFamily: montserratFont,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: darkColor,
                              ),
                            ),
                            Text(
                              (state.userData[0]['first_name'] ?? 'User')
                                  as String,
                              style: TextStyle(
                                fontFamily: montserratFont,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                NotificationButton(),
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
