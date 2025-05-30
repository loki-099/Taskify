import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskify/components/notif_button.dart';
import 'package:taskify/cubit/task_cubit.dart';
import 'package:taskify/cubit/task_state.dart';
import 'package:taskify/utils/colors.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  @override
  Widget build(BuildContext context) {
    bool scheduledTask(Map<String, dynamic> task) {
      String days = task['task_schedule_day'];
      List<String> dayList = days.split(',');

      for (int i = 0; i < dayList.length; i++) {
        if (dayList[i] == DateFormat("EEE").format(_focusedDay)) {
          return true;
        }
      }

      return false;
    }

    final allTasks = context.watch<TaskCubit>().state.taskDatas;
    final tasksForDay =
        allTasks.where((task) {
          final deadline = task['task_deadline'];
          if (deadline == null) return scheduledTask(task);
          final deadlineDate = DateTime.parse(deadline);
          return isSameDay(deadlineDate, _focusedDay);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0, // No shadow
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Calendar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.colorText,
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 8),
        actions: [NotificationButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.mainGradient.colors,
                  begin: AppColors.mainGradient.begin,
                  end: AppColors.mainGradient.end,
                  stops: [-0.5, 1],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 1, 1),
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  headerStyle: HeaderStyle(
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                    titleTextStyle: TextStyle(
                      color: Colors.white, // <-- Month title color
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    // Background color for today's date
                    todayDecoration: BoxDecoration(
                      color: AppColors.colorText,
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(8),
                    ),
                    // Background color for selected date
                    selectedDecoration: BoxDecoration(
                      color: AppColors.color1,
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(8),
                    ),
                    // Text color for default days
                    defaultTextStyle: TextStyle(color: Colors.white),
                    weekendTextStyle: TextStyle(color: Colors.white),
                    outsideTextStyle: TextStyle(color: Colors.white54),
                    weekNumberTextStyle: TextStyle(color: Colors.white),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Colors.white70, // Mon–Fri
                      fontWeight: FontWeight.bold,
                    ),
                    weekendStyle: TextStyle(
                      color: Colors.white70, // Mon–Fri
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isSameDay(_focusedDay, DateTime.now())
                      ? "TODAY"
                      : DateFormat("MMMM d").format(_focusedDay),
                  style: TextStyle(
                    color: AppColors.colorText,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(child: Text("${tasksForDay.length} Tasks")),
              ],
            ),
            Expanded(
              child:
                  tasksForDay.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            "No tasks for this day.",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                      : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 100),
                          child: Column(
                            spacing: 8,
                            children:
                                tasksForDay
                                    .map((task) => CalendarTask(task))
                                    .toList(),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarTask extends StatefulWidget {
  final Map<String, dynamic> task;
  const CalendarTask(this.task, {super.key});

  @override
  State<CalendarTask> createState() => _CalendarTaskState();
}

class _CalendarTaskState extends State<CalendarTask> {
  Map<String, LinearGradient> gradientClass = {
    "level3": LinearGradient(
      colors: [Color(0xeeBD1919), Color(0xffEF4444)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
    "level2": LinearGradient(
      colors: [Color(0xeeF59E0B), Color(0xffF2D200)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
    "level1": LinearGradient(
      colors: [Color(0xff00BA4D), Color(0xee10B984)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ),
  };

  Map<String, String> prioTexts = {
    "level3": "!!!",
    "level2": "!!",
    "level1": "!",
  };

  List convertDeadline(String? raw) {
    // Parse the string into DateTime
    if (raw != null) {
      DateTime parsed = DateTime.parse(raw);

      // Convert to local time if needed
      DateTime local = parsed.toLocal();

      // Format
      String formattedDate = DateFormat(
        'MMMM d, y',
      ).format(local); // e.g., May 31, 2025
      String formattedTime = DateFormat(
        'h:mm a',
      ).format(local); // e.g., 4:00 PM

      // String result = "Due: $formattedDate | $formattedTime";
      List results = [formattedDate, formattedTime];
      return results;
    } else {
      return List.empty();
    }
  }

  String formatTime(String? input) {
    // Parse as DateTime (assuming today's date)
    DateTime dateTime = DateTime.parse("2024-01-01T${input ?? "00:00:00+08"}");

    // Format to 12-hour time
    String formatted = DateFormat('hh:mm a').format(dateTime.toLocal());

    return formatted;
  }

  final SupabaseClient _supabase = Supabase.instance.client;
  bool isVisible = true;

  void updateTaskStatus(String value) async {
    setState(() {
      isVisible = false;
    });
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      await _supabase
          .from('task')
          .update({'task_status': value})
          .eq('id', widget.task['id']);
      if (mounted) {
        context.read<TaskCubit>().updateTaskDatas();
      }
    } catch (e) {
      throw Exception("Error updating task status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xffCAE7FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: gradientClass[widget.task['task_priority_level']],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                prioTexts[widget.task['task_priority_level']]!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task['task_title'],
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.task['task_deadline'] != null
                      ? "${widget.task['task_category']} | ${convertDeadline(widget.task['task_deadline']!)[1]}"
                      : "${widget.task['task_category']} | ${formatTime(widget.task['task_schedule_time']!)}",
                  style: TextStyle(fontSize: 13, color: AppColors.colorText),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 2,
            child: Checkbox(
              activeColor: Colors.transparent,
              checkColor: AppColors.color2,
              value: widget.task['task_status'] == 'com' ? true : false,
              side: BorderSide(color: AppColors.color2),
              onChanged: (value) {
                String stringValue = value == false ? "inp" : "com";
                updateTaskStatus(stringValue);
              },
            ),
          ),
        ],
      ),
    );
  }
}
