import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/components/button.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/utils/colors.dart';

class EditTask extends StatefulWidget {
  final int taskId;
  final String initialTitle;
  final String initialDescription;
  final String initialCategory;
  final bool? initialtSchedFDead;
  final TimeOfDay? initialSchedTime;
  final TimeOfDay? initialDeadTime;
  final DateTime? initialDate;
  final String initialSchedDays;
  final String? initialTaskPrio;
  final List<bool> initialSelectedDays;
  final int initialReminderMinutesBefore;
  final VoidCallback? onUpdate;

  const EditTask({
    super.key,
    required this.taskId,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialCategory,
    required this.initialtSchedFDead,
    this.initialSchedTime,
    this.initialDeadTime,
    this.initialDate,
    this.initialSchedDays = "",
    this.initialTaskPrio,
    this.initialSelectedDays = const [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    this.initialReminderMinutesBefore = 0,
    this.onUpdate,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late String _category;
  late bool? tSchedFDead;
  late bool hasTimePref;
  late TextEditingController _taskTitleController;
  late TextEditingController _taskDescriptionController;

  // TimePrefVariables
  TimeOfDay? _selectedSchedTime;
  TimeOfDay? _selectedDeadTime;
  DateTime? _selectedDate;
  String _selectedSchedDays = "";
  String? _selectedTaskPrio;
  List<bool> _selectedDays = List.generate(7, (_) => false);
  int taskReminderMinutesBefore = 0;
  List<bool> _selectedReminder = List.generate(7, (_) => false);

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    tSchedFDead = widget.initialtSchedFDead;
    hasTimePref = widget.initialtSchedFDead != null;
    _taskTitleController = TextEditingController(text: widget.initialTitle);
    _taskDescriptionController = TextEditingController(
      text: widget.initialDescription,
    );
    _selectedSchedTime = widget.initialSchedTime;
    _selectedDeadTime = widget.initialDeadTime;
    _selectedDate = widget.initialDate;
    _selectedSchedDays = widget.initialSchedDays;
    _selectedTaskPrio = widget.initialTaskPrio;
    _selectedDays = List<bool>.from(widget.initialSelectedDays);
    taskReminderMinutesBefore = widget.initialReminderMinutesBefore;

    // Set _selectedReminder based on initialReminderMinutesBefore
    if (taskReminderMinutesBefore != 0) {
      final idx = [
        5,
        15,
        20,
        30,
        45,
        60,
        1440,
      ].indexOf(taskReminderMinutesBefore);
      if (idx != -1) _selectedReminder[idx] = true;
    }
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  void changeCategory(String? selectedCategory) {
    if (selectedCategory is String) {
      setState(() {
        _category = selectedCategory;
      });
    }
  }

  Future<void> showMultiRemindersPicker() async {
    List<List<dynamic>> reminders = [
      ["5 min before", 5],
      ["15 min before", 15],
      ["20 min before", 20],
      ["30 min before", 30],
      ["45 min before", 45],
      ["1 hour before", 60],
      ["1 day before", 1440],
    ];
    List<bool> tempSelected = List<bool>.from(_selectedReminder);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: const Text(
                  "Custom Reminder",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppColors.colorText,
                  ),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(reminders[index][0]),
                      value: tempSelected[index],
                      onChanged: (bool? value) {
                        setState(() {
                          tempSelected[index] = value ?? false;
                          taskReminderMinutesBefore = reminders[index][1];
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    _selectedReminder = tempSelected;
                    Navigator.pop(context, tempSelected);
                  },
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null && result is List<bool>) {
        setState(() {
          _selectedReminder = List<bool>.from(result);
        });
      }
    });
  }

  // Leave your update logic here for you to implement
  Future<void> _onUpdateTask() async {
    final taskTitle = _taskTitleController.text;
    final taskDescription = _taskDescriptionController.text;
    if (tSchedFDead != null) {
      if (tSchedFDead!) {
        final hour = _selectedSchedTime!.hour.toString().padLeft(2, '0');
        final minute = _selectedSchedTime!.minute.toString().padLeft(2, '0');
        final timetzString = "$hour:$minute:00+08:00";
        await AuthService().insertSchedTask(
          taskTitle,
          taskDescription,
          _category,
          _selectedSchedDays,
          timetzString,
          _selectedTaskPrio,
          taskReminderMinutesBefore,
        );
      } else {
        final combinedDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedDeadTime!.hour,
          _selectedDeadTime!.minute,
          0,
        );
        final formatted =
            "${combinedDateTime.year.toString().padLeft(4, '0')}-"
            "${combinedDateTime.month.toString().padLeft(2, '0')}-"
            "${combinedDateTime.day.toString().padLeft(2, '0')} "
            "${combinedDateTime.hour.toString().padLeft(2, '0')}:"
            "${combinedDateTime.minute.toString().padLeft(2, '0')}:"
            "${combinedDateTime.second.toString().padLeft(2, '0')}+08";
        await AuthService().updateDeadTask(
          widget.taskId,
          taskTitle,
          taskDescription,
          _category,
          formatted,
          _selectedTaskPrio,
          taskReminderMinutesBefore,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: AppColors.white,
        title: Text("Edit Task", style: TextStyle(fontWeight: FontWeight.bold)),
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
                      controller: _taskTitleController,
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
                      controller: _taskDescriptionController,
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
                            DropdownMenuItem(
                              value: "Hobby",
                              child: Text("Hobby"),
                            ),
                            DropdownMenuItem(
                              value: "Others",
                              child: Text("Others"),
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
                          child: TimePreferenceWidget(
                            tSchedFDead: tSchedFDead,
                            selectedPrioLevel: _selectedTaskPrio,
                            selectedDeadlineDate: _selectedDate,
                            onChanged: ({
                              TimeOfDay? selectedSchedTime,
                              TimeOfDay? selectedDeadTime,
                              DateTime? selectedDate,
                              String selectedSchedDays = "",
                              String? selectedTaskPrio,
                              List<bool>? selectedDays,
                            }) {
                              _selectedSchedTime = selectedSchedTime;
                              _selectedDeadTime = selectedDeadTime;
                              _selectedDate = selectedDate;
                              _selectedSchedDays = selectedSchedDays;
                              _selectedTaskPrio =
                                  selectedTaskPrio ??
                                  _selectedTaskPrio; // <-- This line ensures it doesn't become null
                              _selectedDays =
                                  selectedDays ??
                                  List.generate(7, (_) => false);
                            },
                          ),
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
                                selected: !_selectedReminder.contains(true),
                                text: "OFF",
                                onPressed: () {
                                  setState(() {
                                    taskReminderMinutesBefore = 0;
                                    _selectedReminder = List.generate(
                                      7,
                                      (_) => false,
                                    );
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              child: PrefButton(
                                selected: _selectedReminder[0],
                                text: "5 mins",
                                onPressed: () {
                                  setState(() {
                                    taskReminderMinutesBefore = 5;
                                    _selectedReminder[0] =
                                        !_selectedReminder[0];
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              child: PrefButton(
                                selected: _selectedReminder[1],
                                text: "15 mins",
                                onPressed: () {
                                  setState(() {
                                    taskReminderMinutesBefore = 15;
                                    _selectedReminder[1] =
                                        !_selectedReminder[1];
                                  });
                                },
                              ),
                            ),
                            Flexible(
                              child: PrefButton(
                                selected: _selectedReminder
                                    .sublist(2)
                                    .contains(true),
                                text: "Custom",
                                onPressed: showMultiRemindersPicker,
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
                        text: "Update Task",
                        onPressed: () async {
                          await _onUpdateTask();
                          await context.read<TaskCubit>().updateTaskDatas();
                          if (mounted) Navigator.pop(context, true);
                        },
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
  final bool? tSchedFDead;
  final String? selectedPrioLevel;
  final DateTime? selectedDeadlineDate;
  final void Function({
    TimeOfDay? selectedSchedTime,
    TimeOfDay? selectedDeadTime,
    DateTime? selectedDate,
    String selectedSchedDays,
    String? selectedTaskPrio,
    List<bool> selectedDays,
  })?
  onChanged;

  const TimePreferenceWidget({
    super.key,
    this.tSchedFDead,
    this.selectedPrioLevel,
    this.selectedDeadlineDate,
    this.onChanged,
  });

  @override
  State<TimePreferenceWidget> createState() => _TimePreferenceWidgetState();
}

class _TimePreferenceWidgetState extends State<TimePreferenceWidget> {
  TimeOfDay? selectedSchedTime;
  TimeOfDay? selectedDeadTime;
  DateTime? selectedDate;
  String selectedSchedDays = "";
  String? selectedTaskPrio;

  void _notifyParent() {
    widget.onChanged?.call(
      selectedSchedTime: selectedSchedTime,
      selectedDeadTime: selectedDeadTime,
      selectedDate: selectedDate,
      selectedSchedDays: selectedSchedDays,
      selectedTaskPrio: selectedTaskPrio,
      selectedDays: List<bool>.from(_selectedDays),
    );
  }

  List<bool> _selectedDays = List.generate(7, (_) => false);

  List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  void setSelectedSchedDays() {
    setState(() {
      List<String> initDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
      if (!_selectedDays.contains(true)) {
        selectedSchedDays = "";
      } else {
        selectedSchedDays = "";
        for (int i = 0; i < _selectedDays.length; i++) {
          if (_selectedDays[i]) {
            selectedSchedDays += "${initDays[i]},";
          }
        }
        selectedSchedDays = selectedSchedDays.substring(
          0,
          selectedSchedDays.length - 1,
        );
      }
    });
    _notifyParent();
    // print(selectedSchedDays);
  }

  Future<void> showMultiDayPickerDialog() async {
    // Temporary selection for dialog
    List<bool> tempSelected = List<bool>.from(_selectedDays);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: const Text(
                  "Repeat",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppColors.colorText,
                  ),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(days[index]),
                      value: tempSelected[index],
                      onChanged: (bool? value) {
                        setState(() {
                          tempSelected[index] = value ?? false;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // Do nothing here, handle after dialog
                    _selectedDays = tempSelected;
                    Navigator.pop(context, tempSelected);
                  },
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
    ).then((result) {
      if (result != null && result is List<bool>) {
        setSelectedSchedDays();
      }
    });
  }

  void _showTimePickerSched() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        selectedSchedTime = timeOfDay;
      });
      _notifyParent();
    }
  }

  void _showTimePickerDead() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        selectedDeadTime = timeOfDay;
      });
      _notifyParent();
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
    _notifyParent();
  }

  final List<bool> _selectedPrio = List.generate(4, (index) => false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final int indexPrio = [
      "none",
      "level1",
      "level2",
      "level3",
    ].indexOf(widget.selectedPrioLevel!);
    _selectedPrio[indexPrio] = true;

    selectedDate = widget.selectedDeadlineDate;
    selectedDeadTime = TimeOfDay.fromDateTime(
      widget.selectedDeadlineDate!.toLocal(),
    );
  }

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
              SizedBox(height: 4),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          widget.tSchedFDead!
                              ? _showTimePickerSched
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
                              ? selectedSchedTime != null
                                  ? "${selectedSchedTime?.hourOfPeriod}:${selectedSchedTime?.minute} ${selectedSchedTime?.period.name}"
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
                              ? showMultiDayPickerDialog
                              : _showTimePickerDead,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.colorText,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          !widget.tSchedFDead!
                              ? selectedDeadTime != null
                                  ? "${selectedDeadTime?.hourOfPeriod}:${selectedDeadTime?.minute} ${selectedDeadTime?.period.name}"
                                  : "Set Time"
                              : selectedSchedDays == ""
                              ? "Custom"
                              : selectedSchedDays,
                          overflow: TextOverflow.ellipsis,
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
                          selectedTaskPrio =
                              ["none", "level1", "level2", "level3"][index];
                          // print(selectedTaskPrio);
                        }

                        if (!_selectedPrio.contains(true)) {
                          _selectedPrio[0] = true;
                          selectedTaskPrio = "none";
                        }
                      });
                      _notifyParent();
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
