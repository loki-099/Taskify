import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/cubit/user_cubit.dart';
import 'package:taskify/cubit/user_state.dart';
import 'package:taskify/utils/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background and profile info
          SizedBox.expand(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kToolbarHeight,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.color1, AppColors.color4],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(height: 22),
                      GestureDetector(
                        child: Image.asset('assets/images/profile.png'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${state.userData[0]['first_name']} ${state.userData[0]['last_name']}",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        AuthService().getUserEmail() ?? "User email",
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          // DraggableScrollableSheet for bottom panel
          DraggableScrollableSheet(
            initialChildSize: 0.59, // Fraction of screen height
            minChildSize: 0.59,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "General",
                        style: TextStyle(
                          color: AppColors.colorText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffDFF0FF),
                          border: Border.all(color: AppColors.color4, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _profileOption("Edit Profile"),
                            _divider(),
                            _profileOption("Change Password"),
                            _divider(),
                            _profileOption("Settings"),
                            _divider(),
                            _profileOption("Terms & Conditions"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Danger Zone",
                        style: TextStyle(
                          color: AppColors.colorText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffDFF0FF),
                          border: Border.all(color: AppColors.color4, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _profileOption("Help & Support"),
                            _divider(),
                            _profileOption("Erase all content and data"),
                            _divider(),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: AuthService().signOut,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Log Out",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _profileOption(String text) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.color4,
                fontSize: 15,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.color4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    color: AppColors.color4,
    indent: 10,
    endIndent: 10,
  );
}
