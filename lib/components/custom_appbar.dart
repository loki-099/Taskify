import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/cubit/user_cubit.dart';
import 'package:taskify/cubit/user_state.dart';

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
          color: Color(0xfff9f9f9),
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
                IconButton(
                  onPressed: AuthService().signOut,
                  icon: Badge(
                    // label: Text(""),
                    isLabelVisible: true,
                    smallSize: 12,
                    backgroundColor: Color(0xff06BEE1),
                    child: Icon(Icons.notifications, color: darkColor),
                  ),
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
