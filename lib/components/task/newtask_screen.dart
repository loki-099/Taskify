import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/components/button.dart';
import 'package:taskify/utils/colors.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  String _category = "School";
  bool? tSchedFDead;
  bool hasTimePref = false;

  List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  void changeCategory(String? selectedCategory) {
    if (selectedCategory is String) {
      setState(() {
        _category = selectedCategory;
      });
    }
  }

  Future showCustomReminder() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            color: AppColors.white,
            child: Column(
              children: [
                Text(
                  "Repeat",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppColors.colorText,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return ListTile(title: Text(days[index]));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                height: 390,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
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
                          spacing: 8,
                          children: [
                            Flexible(
                              child: PrefButton(
                                selected:
                                    tSchedFDead == null ? false : tSchedFDead!,
                                text: "Set Schedule",
                                onPressed: () {
                                  setState(() {
                                    if (tSchedFDead == null && !hasTimePref) {
                                      tSchedFDead = true;
                                      hasTimePref = true;
                                    } else if (tSchedFDead! && hasTimePref) {
                                      tSchedFDead = null;
                                      hasTimePref = false;
                                    } else {
                                      tSchedFDead = true;
                                    }
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              child: PrefButton(
                                selected:
                                    tSchedFDead == null ? false : !tSchedFDead!,
                                text: "Set Deadline",
                                onPressed: () {
                                  setState(() {
                                    if (tSchedFDead == null && !hasTimePref) {
                                      tSchedFDead = false;
                                      hasTimePref = true;
                                    } else if (!tSchedFDead! && hasTimePref) {
                                      tSchedFDead = null;
                                      hasTimePref = false;
                                    } else {
                                      tSchedFDead = false;
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: hasTimePref,
                          child: TimePreferenceWidget(tSchedFDead: tSchedFDead),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Set Reminder",
                          style: TextStyle(
                            color: AppColors.colorText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            Flexible(
                              child: PrefButton(
                                selected: true,
                                text: "OFF",
                                onPressed: () {
                                  setState(() {});
                                },
                              ),
                            ),
                            Flexible(
                              child: PrefButton(
                                selected: false,
                                text: "5 mins",
                                onPressed: () {
                                  setState(() {});
                                },
                              ),
                            ),
                            Flexible(
                              child: PrefButton(
                                selected: false,
                                text: "15 mins",
                                onPressed: () {
                                  setState(() {});
                                },
                              ),
                            ),
                            Flexible(
                              child: PrefButton(
                                selected: false,
                                text: "Custom",
                                onPressed: showCustomReminder,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 20,
                      right: 20,
                      child: CustomButton(
                        text: "Create Task",
                        onPressed: () {},
                      ),
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

class TimePreferenceWidget extends StatefulWidget {
  const TimePreferenceWidget({super.key, this.tSchedFDead});
  final bool? tSchedFDead;

  @override
  State<TimePreferenceWidget> createState() => _TimePreferenceWidgetState();
}

class _TimePreferenceWidgetState extends State<TimePreferenceWidget> {
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  void _showTimePicker() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  void _showDatePicker() async {
    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dateTime != null) {
      setState(() {
        selectedDate = dateTime;
      });
    }
  }

  final List<bool> _selectedPrio = List.generate(4, (index) => index == 0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Triangle pointer
        Positioned(
          top: -10,
          left:
              widget.tSchedFDead == true
                  ? 70
                  : null, // Point to the left button
          right:
              widget.tSchedFDead == false
                  ? 70
                  : null, // Point to the right button
          child: CustomPaint(
            size: const Size(20, 10),
            painter: _TrianglePainter(color: const Color(0xffCAE7FF)),
          ),
        ),
        // Main content
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xffCAE7FF),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   widget.tSchedFDead!
              //       ? "When would you like to start working on this task?"
              //       : "When is this task due or needs to be completed?",
              //   style: TextStyle(fontSize: 12, color: AppColors.colorText),
              // ),
              SizedBox(height: 4),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          widget.tSchedFDead!
                              ? _showTimePicker
                              : _showDatePicker,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.colorText,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          widget.tSchedFDead!
                              ? selectedTime != null
                                  ? "${selectedTime?.hourOfPeriod}:${selectedTime?.minute} ${selectedTime?.period.name}"
                                  : "Set Time"
                              : selectedDate != null
                              ? "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}"
                              : "Set Date",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          widget.tSchedFDead!
                              ? _showDatePicker
                              : _showTimePicker,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.colorText,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          !widget.tSchedFDead!
                              ? selectedTime != null
                                  ? "${selectedTime?.hourOfPeriod}:${selectedTime?.minute} ${selectedTime?.period.name}"
                                  : "Set Time"
                              : "Custom",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Priority",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ToggleButtons(
                    isSelected: _selectedPrio,
                    onPressed: (int index) {
                      setState(() {
                        if (_selectedPrio[index]) {
                          _selectedPrio[index] = false;
                        } else {
                          for (int i = 0; i < _selectedPrio.length; i++) {
                            _selectedPrio[i] = i == index;
                          }
                        }

                        if (!_selectedPrio.contains(true)) {
                          _selectedPrio[0] = true;
                        }
                      });
                    },
                    borderColor: AppColors.colorText,
                    borderRadius: BorderRadius.circular(4),
                    selectedColor: AppColors.white,
                    selectedBorderColor: AppColors.colorText,
                    fillColor: AppColors.colorText,
                    constraints: BoxConstraints(minHeight: 28, minWidth: 54),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                    children: [
                      Text("None"),
                      Text("!"),
                      Text("!!"),
                      Text("!!!"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Triangle painter
class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path =
        Path()
          ..moveTo(0, size.height)
          ..lineTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) => false;
}
