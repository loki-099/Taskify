import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/utils/colors.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  String _category = "School";

  void changeCategory(String? selectedCategory) {
    if (selectedCategory is String) {
      setState(() {
        _category = selectedCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: AppColors.white,
        title: Text(
          "Create Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // backgroundColor: const Color(0xfff9f9f9),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(
            context,
          ).unfocus(); // Dismiss the keyboard when tapping outside
        },
        child: Stack(
          children: [
            SizedBox.expand(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.color1, AppColors.color4],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Task",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextField(
                      cursorColor: AppColors.white,
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter task title",
                        hintStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Description",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextField(
                      cursorColor: AppColors.white,
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: "Add a description",
                        hintStyle: TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Category",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 2, color: AppColors.white),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _category,
                          iconEnabledColor: AppColors.white,
                          dropdownColor: AppColors.color1,
                          isExpanded: true,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "School",
                              child: Text("School"),
                            ),
                            DropdownMenuItem(
                              value: "Daily",
                              child: Text("Daily"),
                            ),
                          ],
                          onChanged: changeCategory,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // _buildDraggableScrollableSheet(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 380,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Time Preference",
                      style: TextStyle(
                        color: AppColors.colorText,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        // * TODO!
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
